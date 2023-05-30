
-- La función se llama "get_bonus_reservations" y recibe un parámetro de entrada "reservation_number" de tipo INTEGER.
-- La función devuelve una tabla con los mismos campos que la tabla "reservations".
-- Dentro de la función, se utiliza la cláusula "RETURN QUERY" para devolver los registros que cumplen con las condiciones especificadas en la cláusula "WHERE".
-- La condición "res_number = reservation_number" filtra los registros por el número de reserva que se ha pasado como parámetro.
-- La condición "is_bonus = TRUE" filtra los registros por aquellos que tienen el campo "is_bonus" igual a true.

CREATE OR REPLACE FUNCTION get_bonus_reservations(reservation_number INTEGER)
RETURNS TABLE (
  id INTEGER,
  fecha DATE,
  hora TIME_OPTIONS_ENUM,
  res_number INTEGER,
  res_name VARCHAR(100),
  room ROOM_OPTIONS_ENUM,
  is_bonus BOOLEAN,
  bonus_qty INTEGER,
  meal_plan MEAL_PLAN_ENUM,
  pax_number INTEGER,
  cost NUMERIC(10,2),
  observations TEXT,
  is_noshow BOOLEAN,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  is_deleted BOOLEAN
) AS $$
BEGIN
  RETURN QUERY SELECT *
    FROM reservations 
    WHERE reservations.res_number = reservation_number 
    AND reservations.is_bonus = TRUE 
    AND reservations.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql;

-- the way to use functions that returns tables is:
-- SELECT * FROM get_bonus_reservations(1);

CREATE OR REPLACE FUNCTION get_available_seats(in_fecha DATE, in_hora TIME_OPTIONS_ENUM) 
RETURNS INTEGER AS $$
DECLARE
  max_seats INTEGER;
  reserved_seats INTEGER;
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
  SELECT SUM(reservations.pax_number) INTO reserved_seats FROM reservations 
    WHERE reservations.fecha = in_fecha
    AND reservations.hora = in_hora
    AND reservations.is_deleted = FALSE;
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
SELECT * FROM get_bonus_reservations(1);

SELECT get_available_seats('2023-05-23', '19:00');
-[ RECORD 1 ]-------+----
get_available_seats | -14
*/

CREATE VIEW no_show_reservations AS
SELECT *
FROM reservations
WHERE is_noshow = TRUE AND is_deleted = FALSE;

CREATE VIEW cancelled_reservations AS
SELECT *
FROM reservations
WHERE is_deleted = TRUE;

CREATE VIEW standard_reservations AS
SELECT *
FROM reservations
WHERE is_deleted = FALSE AND is_noshow = FALSE;

CREATE OR REPLACE FUNCTION get_assistants(fecha_in DATE)
RETURNS TABLE (num_standard_res INT, num_no_show_res INT, num_pax INT, no_show_pax INT) AS $$
DECLARE
    total_standard_res INT;
    total_no_show_res INT;
    total_pax INT;
    total_no_show_pax INT;
BEGIN
    SELECT COUNT(*) INTO total_standard_res
    FROM standard_reservations
    WHERE fecha = fecha_in;

    SELECT COUNT(*) INTO total_no_show_res
    FROM no_show_reservations
    WHERE fecha = fecha_in;

    SELECT SUM(pax_number) INTO total_pax
    FROM standard_reservations
    WHERE fecha = fecha_in;

    SELECT SUM(pax_number) INTO total_no_show_pax
    FROM no_show_reservations
    WHERE fecha = fecha_in;

    RETURN QUERY SELECT total_standard_res, total_no_show_res, total_pax, total_no_show_pax;
END;
$$ LANGUAGE plpgsql;

/*
SELECT * FROM get_assistants('2023-05-27');
*/

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_reservations_between_dates(fecha_i DATE, fecha_f DATE)
RETURNS TABLE (
  fecha DATE,
  standard_reservations JSON,
  no_show_reservations JSON,
  cancelled_reservations JSON,
  theme_name TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    agenda.fecha AS fecha,
    JSON_AGG(standard_reservations.*) AS standard_reservations,
    JSON_AGG(no_show_reservations.*) AS no_show_reservations,
    JSON_AGG(cancelled_reservations.*) AS cancelled_reservations,
    MAX(DISTINCT(restaurant_themes.theme_name)) AS theme_name
  FROM
    agenda
  LEFT JOIN
    standard_reservations ON agenda.fecha = standard_reservations.fecha
  LEFT JOIN
    no_show_reservations ON agenda.fecha = no_show_reservations.fecha
  LEFT JOIN
    cancelled_reservations ON agenda.fecha = cancelled_reservations.fecha
  LEFT JOIN
    restaurant_themes ON agenda.restaurant_theme_id = restaurant_themes.id
  WHERE
    agenda.fecha >= fecha_i AND agenda.fecha < fecha_f
  GROUP BY
    agenda.fecha
  ORDER BY
    agenda.fecha;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_reservations_between_dates(fecha_i DATE)
RETURNS TABLE (
  fecha DATE,
  standard_reservations JSON,
  no_show_reservations JSON,
  cancelled_reservations JSON,
  theme_name TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    agenda.fecha AS fecha,
    JSON_AGG(standard_reservations.*) AS standard_reservations,
    JSON_AGG(no_show_reservations.*) AS no_show_reservations,
    JSON_AGG(cancelled_reservations.*) AS cancelled_reservations,
    MAX(DISTINCT(restaurant_themes.theme_name)) AS theme_name
  FROM
    agenda
  LEFT JOIN
    standard_reservations ON agenda.fecha = standard_reservations.fecha
  LEFT JOIN
    no_show_reservations ON agenda.fecha = no_show_reservations.fecha
  LEFT JOIN
    cancelled_reservations ON agenda.fecha = cancelled_reservations.fecha
  LEFT JOIN
    restaurant_themes ON agenda.restaurant_theme_id = restaurant_themes.id
  WHERE
    agenda.fecha = fecha_i
  GROUP BY
    agenda.fecha;
END;
$$ LANGUAGE plpgsql;

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

/*
SELECT * FROM get_percentage_per_theme('2023-05-01','2023-05-10');
*/

CREATE OR REPLACE FUNCTION insert_reservation(
  _fecha DATE,
  _hora TIME_OPTIONS_ENUM,
  _res_number INTEGER,
  _res_name VARCHAR(100),
  _room ROOM_OPTIONS_ENUM,
  _is_bonus BOOLEAN,
  _bonus_qty INTEGER,
  _meal_plan MEAL_PLAN_ENUM,
  _pax_number INTEGER,
  _cost NUMERIC(10,2),
  _observations TEXT,
  _is_noshow BOOLEAN
) RETURNS reservations AS $$
DECLARE
  inserted_reservation reservations;
BEGIN
  INSERT INTO reservations (
    fecha,
    hora,
    res_number,
    res_name,
    room,
    is_bonus,
    bonus_qty,
    meal_plan,
    pax_number,
    cost,
    observations,
    is_noshow
  ) VALUES (
    _fecha,
    _hora,
    _res_number,
    _res_name,
    _room,
    _is_bonus,
    _bonus_qty,
    _meal_plan,
    _pax_number,
    _cost,
    _observations,
    _is_noshow
  )
  RETURNING * INTO inserted_reservation;

  RETURN inserted_reservation;
END;
$$ LANGUAGE plpgsql;

/*
SELECT insert_reservation(
  '2023-05-27',
  '19:00',
  1,
  'John Doe',
  '024',
  FALSE,
  0,
  'HB',
  2,
  50.00,
  'No special instructions',
  FALSE
) AS new_reservation;
*/

CREATE OR REPLACE FUNCTION get_payable_reservations(reservation_number INTEGER)
RETURNS TABLE (
  id INTEGER,
  fecha DATE,
  hora TIME_OPTIONS_ENUM,
  res_number INTEGER,
  res_name VARCHAR(100),
  room ROOM_OPTIONS_ENUM,
  is_bonus BOOLEAN,
  bonus_qty INTEGER,
  meal_plan MEAL_PLAN_ENUM,
  pax_number INTEGER,
  cost NUMERIC(10,2),
  observations TEXT,
  is_noshow BOOLEAN,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  is_deleted BOOLEAN
) AS $$
BEGIN
  RETURN QUERY SELECT *
    FROM reservations 
    WHERE reservations.res_number = reservation_number 
    AND reservations.is_bonus = FALSE 
    AND reservations.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_reservation(reservation_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    rows_affected INTEGER;
BEGIN
    UPDATE reservations
    SET is_deleted = TRUE
    WHERE id = reservation_id
    RETURNING id INTO rows_affected;

    IF rows_affected IS NULL THEN
        -- No se borró ningún registro
        RETURN 0;
    ELSE
        -- Se borró exitosamente
        RETURN 1;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Hubo un error durante la actualización
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_agenda_info(_fecha DATE)
RETURNS JSON AS $$
DECLARE
    agenda_info JSON;
BEGIN
    -- Obtener la información de la agenda y el tema del restaurante para la fecha especificada
    SELECT
        json_build_object(
            'fecha', a.fecha,
            'theme_name', rt.theme_name,
            'image_url', rt.image_url,
            'capacidad a las 19:00', a.t1900,
            'capacidad a las 19:15', a.t1915,
            'capacidad a las 19:30', a.t1930,
            'capacidad a las 19:45', a.t1945,
            'capacidad a las 20:00', a.t2000,
            'capacidad a las 20:15', a.t2015,
            'capacidad a las 20:30', a.t2030,
            'capacidad a las 20:45', a.t2045,
            'capacidad a las 21:00', a.t2100,
            'capacidad a las 21:15', a.t2115,
            'capacidad a las 21:30', a.t2130,
            'capacidad a las 21:45', a.t2145
        ) INTO agenda_info
    FROM
        agenda AS a
    JOIN
        restaurant_themes AS rt ON a.restaurant_theme_id = rt.id
    WHERE
        a.fecha = _fecha;
    
    RETURN agenda_info;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Capturar y devolver el error como objeto JSON
        RETURN json_build_object('error', SQLERRM);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_agenda(_fecha DATE, _restaurant_theme_id INTEGER)
RETURNS JSON AS $$
DECLARE
    agenda_info JSON;
BEGIN
    -- Verificar si la fecha es anterior al CURRENT_DATE
    IF _fecha < CURRENT_DATE THEN
        RAISE EXCEPTION 'No se puede crear una agenda pasada';
    END IF;

    -- Insertar el nuevo registro en la tabla agenda
    INSERT INTO agenda (fecha, restaurant_theme_id)
    VALUES (_fecha, _restaurant_theme_id);

    -- Obtener la información de la agenda y el tema del restaurante para el registro recién creado
    SELECT
        json_build_object(
            'fecha', a.fecha,
            'theme_name', rt.theme_name,
            'image_url', rt.image_url,
            'capacidad a las 19:00', a.t1900,
            'capacidad a las 19:15', a.t1915,
            'capacidad a las 19:30', a.t1930,
            'capacidad a las 19:45', a.t1945,
            'capacidad a las 20:00', a.t2000,
            'capacidad a las 20:15', a.t2015,
            'capacidad a las 20:30', a.t2030,
            'capacidad a las 20:45', a.t2045,
            'capacidad a las 21:00', a.t2100,
            'capacidad a las 21:15', a.t2115,
            'capacidad a las 21:30', a.t2130,
            'capacidad a las 21:45', a.t2145
        ) INTO agenda_info
    FROM
        agenda a
    JOIN
        restaurant_themes rt ON a.restaurant_theme_id = rt.id
    WHERE
        a.fecha = _fecha;

    RETURN agenda_info;

EXCEPTION
    WHEN OTHERS THEN
        -- Capturar y devolver el error como objeto JSON
        RETURN json_build_object('error', SQLERRM);
END;
$$ LANGUAGE plpgsql;

