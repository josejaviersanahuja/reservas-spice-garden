
CREATE OR REPLACE FUNCTION get_available_seats(in_fecha DATE, in_hora TIME_OPTIONS_ENUM) 
RETURNS INTEGER AS $$
DECLARE
  max_seats INTEGER;
  reserved_seats INTEGER;
BEGIN
  BEGIN
    IF in_hora = '19:00' THEN
      SELECT agenda.t1900 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '19:15' THEN
      SELECT agenda.t1915 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '19:30' THEN
      SELECT agenda.t1930 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '19:45' THEN
      SELECT agenda.t1945 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '20:00' THEN
      SELECT agenda.t2000 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '20:15' THEN
      SELECT agenda.t2015 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '20:30' THEN
      SELECT agenda.t2030 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '20:45' THEN
      SELECT agenda.t2045 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '21:00' THEN
      SELECT agenda.t2100 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '21:15' THEN
      SELECT agenda.t2115 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '21:30' THEN
      SELECT agenda.t2130 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    ELSIF in_hora = '21:45' THEN
      SELECT agenda.t2145 INTO max_seats FROM agenda WHERE agenda.fecha = in_fecha;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
    RETURN -101; -- Excepción general agenda, se devuelve -101
  END;
  BEGIN
    SELECT SUM(reservations.pax_number) INTO reserved_seats FROM reservations 
      WHERE reservations.fecha = in_fecha
      AND reservations.hora = in_hora
      AND reservations.is_deleted = FALSE;
  EXCEPTION
    WHEN OTHERS THEN
    RETURN -102; -- Excepción general en reservations, se devuelve -102
  END;
  IF max_seats IS NULL THEN
    RETURN -100; -- fecha no encontrada en agenda
  ELSIF reserved_seats IS NULL THEN
    RETURN max_seats; -- no hay reservas para esa fecha y hora
  ELSE
    RETURN max_seats - reserved_seats; -- devuelve el número de asientos disponibles
  END IF;
END;
$$ LANGUAGE plpgsql;
/*
SELECT get_available_seats('2023-05-23', '19:00');
-[ RECORD 1 ]-------+----
get_available_seats | -14
*/

CREATE OR REPLACE FUNCTION get_assistants(fecha_in DATE)
RETURNS JSON AS $$
DECLARE 
    total_standard_res INT;
    total_no_show_res INT;
    total_standard_pax INT;
    total_no_show_pax INT;
    stack_info TEXT;
    result JSON;
BEGIN 
    BEGIN
        SELECT COUNT(*) INTO total_standard_res
        FROM standard_reservations
        WHERE fecha = fecha_in;

        SELECT COUNT(*) INTO total_no_show_res
        FROM no_show_reservations
        WHERE fecha = fecha_in;

        SELECT SUM(pax_number) INTO total_standard_pax
        FROM standard_reservations
        WHERE fecha = fecha_in;

        SELECT SUM(pax_number) INTO total_no_show_pax
        FROM no_show_reservations
        WHERE fecha = fecha_in;

        result := json_build_object(
            'isError', FALSE,
            'result', json_build_object(
                'fecha', fecha_in, -- DATE
                'num_standard_res', total_standard_res, -- INTEGER
                'num_no_show_res', total_no_show_res, -- INTEGER
                'num_standard_pax', total_standard_pax, --  INTEGER | NULL
                'no_show_pax', total_no_show_pax -- INTEGER | NULL
            )
        );
    EXCEPTION
        WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
            result := json_build_object(
                'isError', TRUE,
                'message', SQLERRM,
                'errorCode', SQLSTATE,
                'stack', stack_info
            );
    END;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

/*
SELECT get_assistants('2023-05-27');
*/


CREATE OR REPLACE FUNCTION get_statistics(fecha_i DATE, fecha_f DATE)
RETURNS TABLE (
  fecha DATE,
  theme_name VARCHAR(255),
  reserved BIGINT,
  assistants BIGINT,
  total_cash NUMERIC(10, 2),
  total_bonus BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.fecha,
        r.theme_name,
        COALESCE(s.reserved, 0) AS reserved,
        COALESCE(s.assistants, 0) AS assistants,
        COALESCE(s.total_cash, 0.0) AS total_cash,
        COALESCE(n.total_bonus, 0) AS total_bonus
    FROM
        agenda a
    LEFT JOIN
        restaurant_themes r ON a.restaurant_theme_id = r.id
    LEFT JOIN LATERAL (
        SELECT
            COUNT(*) AS reserved,
            SUM(cost) AS total_cash,
            COUNT(*) FILTER (WHERE is_bonus = TRUE) AS total_bonus,
            SUM(pax_number) AS assistants
        FROM
            standard_reservations
        WHERE
            standard_reservations.fecha = a.fecha
            AND standard_reservations.fecha >= fecha_i
            AND standard_reservations.fecha < fecha_f
    ) s ON true
    LEFT JOIN LATERAL (
        SELECT
            COUNT(*) AS total_bonus
        FROM
            no_show_reservations
        WHERE
            no_show_reservations.fecha = a.fecha 
            AND no_show_reservations.fecha >= fecha_i
            AND no_show_reservations.fecha < fecha_f
            AND is_bonus = TRUE
    ) n ON true
    WHERE a.fecha >= fecha_i AND a.fecha < fecha_f
    ORDER BY a.fecha;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_percentage_per_theme(fecha_i DATE, fecha_f DATE)
RETURNS TABLE (
	theme_name VARCHAR(255),
	num_res_theme BIGINT,
	num_res_total NUMERIC,
	pax_res_theme BIGINT,
	pax_res_total NUMERIC,
	bonus_res_theme BIGINT,
	bonus_res_total NUMERIC,
	cash_theme NUMERIC(10,2),
	cash_total NUMERIC(10,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.theme_name,
        COUNT(*) AS num_res_theme,
		    SUM(COUNT(*)) OVER() AS num_res_total,
        SUM(s.pax_number) AS pax_res_theme,
		    SUM(SUM(s.pax_number)) OVER() AS pax_res_total,
        COUNT(*) FILTER (WHERE s.is_bonus = TRUE) AS bonus_res_theme,
		    SUM(COUNT(*) FILTER (WHERE s.is_bonus = TRUE)) OVER() AS bonus_res_total,
        SUM(s.cost) AS cash_theme,
		    SUM(SUM(s.cost)) OVER() AS cash_total
    FROM
        standard_reservations s
    JOIN
        agenda a ON s.fecha = a.fecha
    JOIN
        restaurant_themes r ON a.restaurant_theme_id = r.id
    WHERE
        s.is_deleted = FALSE AND
        a.is_deleted = FALSE AND
        s.is_noshow = FALSE AND
        s.fecha >= fecha_i AND
        s.fecha < fecha_f
    GROUP BY
        r.theme_name;

END;
$$ LANGUAGE plpgsql;
