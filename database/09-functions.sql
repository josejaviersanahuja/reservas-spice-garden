
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
) RETURNS reservations AS $$
DECLARE
  updated_reservation reservations;
BEGIN
  UPDATE reservations
  SET
    fecha = COALESCE(_fecha, fecha),
    hora = COALESCE(_hora, hora),
    res_number = COALESCE(_res_number, res_number),
    res_name = COALESCE(_res_name, res_name),
    room = COALESCE(_room, room),
    is_bonus = COALESCE(_is_bonus, is_bonus),
    bonus_qty = COALESCE(_bonus_qty, bonus_qty),
    meal_plan = COALESCE(_meal_plan, meal_plan),
    pax_number = COALESCE(_pax_number, pax_number),
    cost = COALESCE(_cost, cost),
    observations = COALESCE(_observations, observations),
    is_noshow = COALESCE(_is_noshow, is_noshow)
  WHERE id = _id
  RETURNING * INTO updated_reservation;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'El update falló en la base de datos.';
  END IF;

  RETURN updated_reservation;
END;
$$ LANGUAGE plpgsql;

/*
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

CREATE OR REPLACE FUNCTION update_agenda(_fecha DATE, _restaurant_theme_id INTEGER DEFAULT NULL,
                                        _t1900 INTEGER DEFAULT NULL, _t1915 INTEGER DEFAULT NULL,
                                        _t1930 INTEGER DEFAULT NULL, _t1945 INTEGER DEFAULT NULL,
                                        _t2000 INTEGER DEFAULT NULL, _t2015 INTEGER DEFAULT NULL,
                                        _t2030 INTEGER DEFAULT NULL, _t2045 INTEGER DEFAULT NULL,
                                        _t2100 INTEGER DEFAULT NULL, _t2115 INTEGER DEFAULT NULL,
                                        _t2130 INTEGER DEFAULT NULL, _t2145 INTEGER DEFAULT NULL)
RETURNS JSON AS $$
DECLARE
    agenda_info JSON;
BEGIN
    -- Verificar si la fecha es anterior al CURRENT_DATE
    IF _fecha < CURRENT_DATE THEN
        RAISE EXCEPTION 'No se puede modificar una agenda pasada';
    END IF;

    -- Actualizar los campos modificables de la tabla agenda
    UPDATE agenda
    SET
        restaurant_theme_id = COALESCE(_restaurant_theme_id, agenda.restaurant_theme_id),
        t1900 = COALESCE(_t1900, agenda.t1900),
        t1915 = COALESCE(_t1915, agenda.t1915),
        t1930 = COALESCE(_t1930, agenda.t1930),
        t1945 = COALESCE(_t1945, agenda.t1945),
        t2000 = COALESCE(_t2000, agenda.t2000),
        t2015 = COALESCE(_t2015, agenda.t2015),
        t2030 = COALESCE(_t2030, agenda.t2030),
        t2045 = COALESCE(_t2045, agenda.t2045),
        t2100 = COALESCE(_t2100, agenda.t2100),
        t2115 = COALESCE(_t2115, agenda.t2115),
        t2130 = COALESCE(_t2130, agenda.t2130),
        t2145 = COALESCE(_t2145, agenda.t2145),
        updated_at = NOW()
    WHERE
        agenda.fecha = _fecha;

    -- Obtener la información actualizada de la agenda y el tema del restaurante
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

CREATE OR REPLACE FUNCTION delete_agenda(_fecha DATE)
RETURNS JSON AS $$
DECLARE
  res_count INTEGER;
BEGIN
  IF _fecha < CURRENT_DATE THEN
    RETURN '{"statusCode": 400, "message": "No se puede borrar una agenda pasada"}';
  END IF;
  UPDATE agenda SET is_deleted = TRUE WHERE fecha = _fecha;
  GET DIAGNOSTICS res_count = ROW_COUNT;
  IF res_count = 0 THEN
    RETURN '{"statusCode": 404, "message": "No se encontró agenda con la fecha especificada"}';
  END IF;
  UPDATE reservations SET is_deleted = TRUE WHERE fecha = _fecha;
  GET DIAGNOSTICS res_count = ROW_COUNT;
  RETURN '{"statusCode": 202, "message": "Agenda con ' || _fecha || ' borrada y ' || res_count || ' reservas canceladas"}';
EXCEPTION
  WHEN OTHERS THEN
    RETURN '{"statusCode": 500, "message": "Error al borrar agenda con ' || _fecha || '", "sqlError": "' || SQLERRM || '"}';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_restaurant_theme(
  _theme_name VARCHAR(255),
  _description TEXT,
  _image_url VARCHAR(255) DEFAULT ''
)
RETURNS JSON AS $$
DECLARE
  res restaurant_themes;
BEGIN
  INSERT INTO restaurant_themes (theme_name, description, image_url)
  VALUES (_theme_name, _description, _image_url)
  RETURNING id, theme_name, description, image_url, created_at, updated_at, is_deleted
  INTO res;
  
  RETURN json_build_object(
    'statusCode', 201,
    'message', 'Restaurant theme created successfully',
    'data', row_to_json(res)
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'statusCode', 500,
      'message', 'Error creating restaurant theme',
      'sqlError', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

-- Función para actualizar un restaurant_theme
CREATE OR REPLACE FUNCTION update_restaurant_theme(
  _id INTEGER,
  _theme_name VARCHAR(255) DEFAULT NULL,
  _description TEXT DEFAULT NULL,
  _image_url VARCHAR(255) DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
  result restaurant_themes;
BEGIN
  UPDATE restaurant_themes
  SET
    theme_name = COALESCE(_theme_name, theme_name),
    description = COALESCE(_description, description),
    image_url = COALESCE(_image_url, image_url),
    updated_at = NOW()
  WHERE id = _id
  RETURNING id, theme_name, description, image_url, created_at, updated_at, is_deleted
  INTO result;
  
  IF result IS NULL THEN
    RETURN json_build_object(
      'statusCode', 404,
      'message', 'Restaurant theme not found'
    );
  ELSE
    RETURN json_build_object(
      'statusCode', 202,
      'message', 'Restaurant theme updated successfully',
      'data', row_to_json(result)
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'statusCode', 500,
      'message', 'Error updating restaurant theme',
      'sqlError', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

-- Función para borrar un restaurant_theme
CREATE OR REPLACE FUNCTION delete_restaurant_theme(
  _id INTEGER
)
RETURNS JSON AS $$
BEGIN
  UPDATE restaurant_themes
  SET is_deleted = TRUE
  WHERE id = _id AND is_deleted = FALSE;
  
  IF FOUND THEN
    RETURN json_build_object(
      'statusCode', 202,
      'message', 'Restaurant theme deleted successfully'
    );
  ELSE
    RETURN json_build_object(
      'statusCode', 404,
      'message', 'Restaurant theme not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'statusCode', 500,
      'message', 'Error deleting restaurant theme',
      'sqlError', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;
