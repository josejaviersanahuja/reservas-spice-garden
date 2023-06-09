
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

/* 
SELECT * FROM get_bonus_reservations(1);
*/


CREATE OR REPLACE FUNCTION get_reservations_between_dates(fecha_i DATE, fecha_f DATE)
RETURNS TABLE (
  fecha DATE,
  standard_reservations JSON,
  no_show_reservations JSON,
  cancelled_reservations JSON,
  theme_name TEXT
) AS $$
BEGIN
  BEGIN
    RETURN QUERY
    SELECT
      agenda.fecha AS fecha,
      JSON_AGG(standard_reservations.*) FILTER (WHERE standard_reservations.* IS NOT NULL) AS standard_reservations,
      JSON_AGG(no_show_reservations.*) FILTER (WHERE no_show_reservations.* IS NOT NULL) AS no_show_reservations,
      JSON_AGG(cancelled_reservations.*) FILTER (WHERE cancelled_reservations.* IS NOT NULL) AS cancelled_reservations,
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
  EXCEPTION
    WHEN OTHERS THEN
      RETURN QUERY
      SELECT
        '1900-01-01'::DATE AS fecha,
        '[]'::JSON AS standard_reservations,
        '[]'::JSON AS no_show_reservations,
        '[]'::JSON AS cancelled_reservations,
        SQLERRM::TEXT AS theme_name;
  END;
END;
$$ LANGUAGE plpgsql;

/*
SELECT * FROM get_reservations_between_dates('2000-01-01','2023-05-31');
*/

CREATE OR REPLACE FUNCTION get_reservations_between_dates(fecha_i DATE)
RETURNS TABLE (
  fecha DATE,
  standard_reservations JSON,
  no_show_reservations JSON,
  cancelled_reservations JSON,
  theme_name TEXT
) AS $$
BEGIN
  BEGIN
    RETURN QUERY
    SELECT
        agenda.fecha AS fecha,
        JSON_AGG(standard_reservations.*) FILTER (WHERE standard_reservations.* IS NOT NULL) AS standard_reservations,
      JSON_AGG(no_show_reservations.*) FILTER (WHERE no_show_reservations.* IS NOT NULL) AS no_show_reservations,
      JSON_AGG(cancelled_reservations.*) FILTER (WHERE cancelled_reservations.* IS NOT NULL) AS cancelled_reservations,
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
        agenda.fecha
    ORDER BY
        agenda.fecha;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN QUERY
      SELECT
        '1900-01-01'::DATE AS fecha,
        '[]'::JSON AS standard_reservations,
        '[]'::JSON AS no_show_reservations,
        '[]'::JSON AS cancelled_reservations,
        SQLERRM::TEXT AS theme_name;
  END;
END;
$$ LANGUAGE plpgsql;

/*
SELECT * FROM get_reservations_between_dates('2023-05-31');
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
) RETURNS JSON AS $$
DECLARE
  inserted_reservation reservations;
  response JSON;
  stack_info TEXT;
BEGIN
  BEGIN
    IF _fecha < CURRENT_DATE THEN
      response := json_build_object(
        'isError', FALSE,
        'message', 'Bad request: No record inserted - Date is in the past',
        'rowsAffected', 0
      );
    ELSE
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

        IF inserted_reservation IS NULL THEN
          response := json_build_object(
            'isError', TRUE, 'message', 'No record inserted',
            'rowsAffected', 0
            );
        ELSE
          response := json_build_object(
            'isError', FALSE, 'result', inserted_reservation, 'rowsAffected', 1
            );
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
          response := json_build_object(
            'isError', TRUE, 'message', SQLERRM, 'errorCode', SQLSTATE,
            'stack', stack_info
            );
      END;
    END IF;

    RETURN response;
  END;
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


CREATE OR REPLACE FUNCTION update_reservation(
  _id INTEGER,
  _fecha DATE DEFAULT NULL,
  _hora TIME_OPTIONS_ENUM DEFAULT NULL,
  _res_number INTEGER DEFAULT NULL,
  _res_name VARCHAR(100) DEFAULT NULL,
  _room ROOM_OPTIONS_ENUM DEFAULT NULL,
  _is_bonus BOOLEAN DEFAULT NULL,
  _bonus_qty INTEGER DEFAULT NULL,
  _meal_plan MEAL_PLAN_ENUM DEFAULT NULL,
  _pax_number INTEGER DEFAULT NULL,
  _cost NUMERIC(10,2) DEFAULT NULL,
  _observations TEXT DEFAULT NULL,
  _is_noshow BOOLEAN DEFAULT NULL
) RETURNS JSON AS $$
DECLARE
  updated reservations;
  response JSON;
  stack_info TEXT;
  fecha_reserva DATE;
BEGIN
  BEGIN
    fecha_reserva := COALESCE(_fecha, (SELECT fecha FROM reservations WHERE id = _id));
    IF fecha_reserva < CURRENT_DATE THEN
      response := json_build_object(
        'isError', TRUE,
        'message', 'Bad request: No record inserted - Date is in the past',
        'rowsAffected', 0,
        'errorCode', 'P0001'
      );
    ELSE
      BEGIN
        UPDATE reservations 
        SET
          fecha = COALESCE(_fecha, reservations.fecha),
          hora = COALESCE(_hora, reservations.hora),
          res_number = COALESCE(_res_number, reservations.res_number),
          res_name = COALESCE(_res_name, reservations.res_name),
          room = COALESCE(_room, reservations.room),
          is_bonus = COALESCE(_is_bonus, reservations.is_bonus),
          bonus_qty = COALESCE(_bonus_qty, reservations.bonus_qty),
          meal_plan = COALESCE(_meal_plan, reservations.meal_plan),
          pax_number = COALESCE(_pax_number, reservations.pax_number),
          cost = COALESCE(_cost, reservations.cost),
          observations = COALESCE(_observations, reservations.observations),
          is_noshow = COALESCE(_is_noshow, reservations.is_noshow)
        WHERE id = _id;

        IF FOUND THEN
          SELECT * FROM reservations WHERE id = _id INTO updated;
          response := json_build_object(
            'isError', FALSE,
            'result', json_build_object(
              'id', updated.id,
              'fecha', updated.fecha,
              'hora', updated.hora,
              'res_number', updated.res_number,
              'res_name', updated.res_name,
              'room', updated.room,
              'is_bonus', updated.is_bonus,
              'bonus_qty', updated.bonus_qty,
              'meal_plan', updated.meal_plan,
              'pax_number', updated.pax_number,
              'cost', updated.cost,
              'observations', updated.observations,
              'is_noshow', updated.is_noshow,
              'created_at', updated.created_at,
              'updated_at', updated.updated_at,
              'is_deleted', updated.is_deleted
            ),
            'rowsAffected', 1
            );
        ELSE
          response := json_build_object(
            'isError', FALSE, 'message', 'Not found: No record updated',
            'rowsAffected', 0
            );
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
          response := json_build_object(
            'isError', TRUE, 'message', SQLERRM, 'errorCode', SQLSTATE,
            'stack', stack_info
            );
      END;
    END IF;

    RETURN response;
  END;
END;
$$ LANGUAGE plpgsql;

/*
SELECT update_reservation(
	226,
  '2023-05-31',
  '19:00',
  1,
  'Jane Doe',
  '025',
  FALSE,
  0,
  'HB',
  2,
  50.00,
  'No special instructions',
  FALSE
) AS new_reservation;
SELECT * FROM update_reservation(15, NULL, NULL, NULL, NULL, NULL, TRUE);
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
RETURNS JSON AS $$
DECLARE
    rows_affected INTEGER;
    response JSON;
    stack_info TEXT;
BEGIN
  BEGIN
    UPDATE reservations
    SET is_deleted = TRUE
    WHERE id = reservation_id
	AND is_deleted = FALSE
    RETURNING id INTO rows_affected;

    IF rows_affected IS NULL THEN
      response := json_build_object('isError', FALSE, 'message', 'Not found: Reservation not deleted',
      'rowsAffected', 0);
    ELSE
      response := json_build_object('isError', FALSE, 'message', 'Reservation deleted successfully',
      'rowsAffected', 1);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
      response := json_build_object(
        'isError', TRUE, 'message', SQLERRM, 'sqlError', SQLSTATE,
        'stack', stack_info
        );
  END;

  RETURN response;
END;
$$ LANGUAGE plpgsql;

/*
SELECT delete_reservation(226);
*/

CREATE OR REPLACE FUNCTION get_reservation_suggestion(reservation_number INTEGER)
RETURNS JSON AS $$
DECLARE
    reservation_data JSON;
    stack_info TEXT;
BEGIN
    BEGIN
    SELECT
        json_build_object(
            'isError', FALSE,
            'result', (
                SELECT
                    json_build_object(
                        'hora', r.hora,
                        'res_number', r.res_number,
                        'res_name', r.res_name,
                        'room', r.room,
                        'is_bonus', r.is_bonus,
                        'bonus_qty', r.bonus_qty,
                        'meal_plan', r.meal_plan,
                        'pax_number', r.pax_number,
                        'cost', r.cost,
                        'observations', r.observations
                    )
                FROM
                    reservations r
                WHERE
                    r.res_number = reservation_number
                ORDER BY
                    r.created_at DESC
                LIMIT 1
            )
        ) INTO reservation_data;

    IF NOT FOUND THEN
        reservation_data := json_build_object(
            'isError', FALSE,
            'result', NULL,
            'message', 'This is the first reservation for this reservation number'
        );
    END IF;

    RETURN reservation_data;
    EXCEPTION
    WHEN OTHERS THEN
      GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
      reservation_data := json_build_object(
        'isError', TRUE, 'message', SQLERRM, 'sqlError', SQLSTATE,
        'stack', stack_info
        );
  END;
END;
$$ LANGUAGE plpgsql;
