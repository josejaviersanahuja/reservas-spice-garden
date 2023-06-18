
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  user_password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO users (username, user_password) VALUES ('reception', 'Welcome123');
INSERT INTO users (username, user_password) VALUES ('cocina', 'Cocina123');
INSERT INTO users (username, user_password) VALUES ('maitre', 'Maitre123');
INSERT INTO users (username, user_password) VALUES ('direccion', 'Direccion123');
DROP TABLE IF EXISTS restaurant_themes;

CREATE TABLE restaurant_themes (
  id SERIAL PRIMARY KEY,
  theme_name VARCHAR(255) NOT NULL,
  description TEXT,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_deleted BOOLEAN DEFAULT FALSE
);

INSERT INTO restaurant_themes (theme_name, description, image_url) VALUES
('Restaurante Mexicano', 'Restaurante de comida mexicana', ''),
('Restaurante Italiano', 'Restaurante de comida italiana', ''),
('Restaurante Hindú', 'Restaurante de comida hindú', '');

DROP TABLE IF EXISTS agenda;

CREATE TABLE agenda (
  fecha DATE NOT NULL DEFAULT CURRENT_DATE PRIMARY KEY,
  restaurant_theme_id INTEGER NOT NULL,
  t1900 INTEGER NOT NULL DEFAULT 10,
  t1915 INTEGER NOT NULL DEFAULT 8,
  t1930 INTEGER NOT NULL DEFAULT 6,
  t1945 INTEGER NOT NULL DEFAULT 0,
  t2000 INTEGER NOT NULL DEFAULT 4,
  t2015 INTEGER NOT NULL DEFAULT 6,
  t2030 INTEGER NOT NULL DEFAULT 4,
  t2045 INTEGER NOT NULL DEFAULT 6,
  t2100 INTEGER NOT NULL DEFAULT 6,
  t2115 INTEGER NOT NULL DEFAULT 6,
  t2130 INTEGER NOT NULL DEFAULT 4,
  t2145 INTEGER NOT NULL DEFAULT 4,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_deleted BOOLEAN DEFAULT FALSE
);

DROP TABLE IF EXISTS reservations;
DROP TYPE IF EXISTS MEAL_PLAN_ENUM;
DROP TYPE IF EXISTS TIME_OPTIONS_ENUM;
DROP TYPE IF EXISTS ROOM_OPTIONS_ENUM;

CREATE TYPE MEAL_PLAN_ENUM AS ENUM ('SC', 'BB', 'HB', 'FB', 'AI');

CREATE TYPE TIME_OPTIONS_ENUM AS ENUM ('19:00', '19:15', '19:30', '19:45', '20:00', '20:15', '20:30', '20:45', '21:00', '21:15', '21:30', '21:45');

CREATE TYPE ROOM_OPTIONS_ENUM AS ENUM (
  'P01', 'P02', 'P03', 'P04', 'P05', 'P06', 'P07', 'P08', 'P09', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P20', 'P21', 'P22',
  '001', '002', '003', '004', '005', '006', '007', '008', '009', '010', '011', '012', '013', '014', '015', '016', '017', '018', '019', '020', '021', '022',
  '023', '024', '025', '026', '027', '028', '029', '030', '031', '032', '033', '034', '035', '036', '037', '038', '039', '040', '041', '042', '043', '044',
  '045', '046', '047', '048', '049', '050',
  '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122',
  '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143',
  '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222',
  '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242',
  '301', '302', '303', '304', '305', '306', '307', '308', '309', '310', '311', '312', '313', '314', '315', '316',
  'S/N'
);

CREATE TABLE reservations (
  id SERIAL PRIMARY KEY,
  fecha DATE NOT NULL DEFAULT CURRENT_DATE,
  hora TIME_OPTIONS_ENUM NOT NULL,
  res_number INTEGER NOT NULL DEFAULT 0, -- reservation number, if there isn't one, use 0
  res_name VARCHAR(100),
  room ROOM_OPTIONS_ENUM, -- if res number is 0, room must be S/N
  is_bonus BOOLEAN DEFAULT FALSE, -- if true, means cost is 0 and bonus_qty is > 0 Meal plan is AI
  bonus_qty INTEGER DEFAULT 0,
  meal_plan MEAL_PLAN_ENUM, -- if is_bonus is true, meal_plan must be AI
  pax_number INTEGER,
  cost NUMERIC(10,2), -- if is_bonus is true, cost must be 0
  observations TEXT,
  is_noshow BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_deleted BOOLEAN DEFAULT FALSE
);

ALTER TABLE agenda
DROP CONSTRAINT IF EXISTS fk_agenda_restaurant_theme_id;

ALTER TABLE reservations
DROP CONSTRAINT IF EXISTS fk_reservations_agenda;

ALTER TABLE agenda
ADD CONSTRAINT fk_agenda_restaurant_theme_id
FOREIGN KEY (restaurant_theme_id)
REFERENCES restaurant_themes(id)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE reservations
ADD CONSTRAINT fk_reservations_agenda
FOREIGN KEY (fecha)
REFERENCES agenda(fecha)
ON DELETE CASCADE
ON UPDATE CASCADE;

CREATE INDEX idx_reservations_res_number ON reservations (res_number);

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

CREATE VIEW agendas_view AS
SELECT *
FROM agenda
WHERE is_deleted = FALSE;

CREATE VIEW restaurant_themes_view AS
SELECT *
FROM restaurant_themes
WHERE is_deleted = FALSE;

CREATE VIEW cancelled_agendas AS
SELECT *
FROM agenda
WHERE is_deleted = TRUE;

CREATE VIEW cancelled_restaurant_themes AS
SELECT *
FROM restaurant_themes
WHERE is_deleted = TRUE;

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

CREATE OR REPLACE FUNCTION get_agenda_info(_fecha DATE)
RETURNS JSON AS $$
DECLARE
    agenda_info JSON;
    stack_info TEXT;
BEGIN
    -- Obtener la información de la agenda y el tema del restaurante para la fecha especificada
    SELECT
        json_build_object(
            'fecha', a.fecha,
            'themeName', rt.theme_name,
            'imageUrl', rt.image_url,
            '19:00', a.t1900,
            '19:15', a.t1915,
            '19:30', a.t1930,
            '19:45', a.t1945,
            '20:00', a.t2000,
            '20:15', a.t2015,
            '20:30', a.t2030,
            '20:45', a.t2045,
            '21:00', a.t2100,
            '21:15', a.t2115,
            '21:30', a.t2130,
            '21:45', a.t2145
        ) INTO agenda_info
    FROM
        agenda AS a
    JOIN
        restaurant_themes AS rt ON a.restaurant_theme_id = rt.id
    WHERE
        a.fecha = _fecha;
    
    RETURN json_build_object(
        'isError', FALSE,
        'result', agenda_info -- schema | NULL
    );
    
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
        -- Capturar y devolver el error como objeto JSON
        RETURN json_build_object(
            'isError', TRUE,
            'message', SQLERRM,
            'errorCode', SQLSTATE,
            'stack', stack_info
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_agenda(_fecha DATE, _restaurant_theme_id INTEGER)
RETURNS JSON AS $$
DECLARE
    stack_info TEXT;
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
            'themeName', rt.theme_name,
            'imageUrl', rt.image_url,
            '19:00', a.t1900,
            '19:15', a.t1915,
            '19:30', a.t1930,
            '19:45', a.t1945,
            '20:00', a.t2000,
            '20:15', a.t2015,
            '20:30', a.t2030,
            '20:45', a.t2045,
            '21:00', a.t2100,
            '21:15', a.t2115,
            '21:30', a.t2130,
            '21:45', a.t2145
        ) INTO agenda_info
    FROM
        agenda a
    JOIN
        restaurant_themes rt ON a.restaurant_theme_id = rt.id
    WHERE
        a.fecha = _fecha;

    -- Retornar JSON con statusCode y data en caso de éxito
    RETURN json_build_object('isError', FALSE, 'result', agenda_info);

EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
        RETURN json_build_object(
            'isError', TRUE,
            'message', SQLERRM,
            'errorCode', SQLSTATE,
            'stack', stack_info
        );
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
    stack_info TEXT;
BEGIN
    -- Verificar si la fecha es anterior al CURRENT_DATE
    IF _fecha < CURRENT_DATE THEN
        RETURN json_build_object(
            'isError', TRUE,
            'message', 'Bad Request 400 No se puede modificar una agenda pasada',
            'errorCode', 'P0001'
        );
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

    -- Verificar si se modificó alguna fila
    IF FOUND THEN
        -- Obtener la información actualizada de la agenda y el tema del restaurante
        SELECT
            json_build_object(
                'fecha', a.fecha,
                'themeName', rt.theme_name,
                'imageUrl', rt.image_url,
                '19:00', a.t1900,
                '19:15', a.t1915,
                '19:30', a.t1930,
                '19:45', a.t1945,
                '20:00', a.t2000,
                '20:15', a.t2015,
                '20:30', a.t2030,
                '20:45', a.t2045,
                '21:00', a.t2100,
                '21:15', a.t2115,
                '21:30', a.t2130,
                '21:45', a.t2145
            ) INTO agenda_info
        FROM
            agenda a
        JOIN
            restaurant_themes rt ON a.restaurant_theme_id = rt.id
        WHERE
            a.fecha = _fecha;

        RETURN json_build_object('isError', FALSE, 'result', agenda_info, 'rowsAffected', 1);
    ELSE
        RETURN json_build_object('isError', FALSE, 'result', NULL, 'rowsAffected', 0);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
        RETURN json_build_object('isError', TRUE, 'message', SQLERRM, 'errorCode', SQLSTATE);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_agenda(_fecha DATE)
RETURNS JSON AS $$
DECLARE
  res_count INTEGER;
  stack_info TEXT;
BEGIN
  IF _fecha < CURRENT_DATE THEN
    RETURN '{"isError": true, "message": "BAD REQUEST 400 No se puede borrar una agenda pasada"}';
  END IF;
  UPDATE agenda SET is_deleted = TRUE WHERE fecha = _fecha AND is_deleted = FALSE;
  GET DIAGNOSTICS res_count = ROW_COUNT;
  IF res_count = 0 THEN
    RETURN '{"isError": false, "message": "No se encontró agenda con la fecha especificada", "rowsAffected":0, "reservationsDeleted":0}';
  END IF;
  UPDATE reservations SET is_deleted = TRUE WHERE fecha = _fecha AND is_deleted = FALSE;
  GET DIAGNOSTICS res_count = ROW_COUNT;
  -- RAISE NOTICE 'reservas %', res_count; 
  RETURN json_build_object(
    'isError', FALSE,
    'message', 'Agenda del día '||_fecha||' borrada con '||res_count||' reservas borradas',
    'rowsAffected', 1,
    'reservationsDeleted', COALESCE(res_count, 0)
  );
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object(
        'isError', TRUE,
        'message', SQLERRM,
        'errorCode', SQLSTATE,
        'stack', stack_info
    );
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
  stack_info TEXT;
BEGIN
  INSERT INTO restaurant_themes (theme_name, description, image_url)
  VALUES (_theme_name, _description, _image_url)
  RETURNING id, theme_name, description, image_url, created_at, updated_at, is_deleted
  INTO res;
  
  RETURN json_build_object(
    'isError', FALSE,
    'message', 'Restaurant theme created successfully',
    'result', row_to_json(res)
  );
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object(
      'isError', TRUE,
      'message', SQLERRM,
      'errorCode', SQLSTATE,
      'stack', stack_info
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
  stack_info TEXT;
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
      'isError', FALSE,
      'message', 'Restaurant theme not found',
      'result', NULL,
      'rowsAffected', 0
    );
  ELSE
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'Restaurant theme updated successfully',
      'result', row_to_json(result),
      'rowsAffected', 1
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object(
        'isError', TRUE,
        'message', SQLERRM,
        'errorCode', SQLSTATE,
        'stack', stack_info
    );
END;
$$ LANGUAGE plpgsql;

-- Función para borrar un restaurant_theme
CREATE OR REPLACE FUNCTION delete_restaurant_theme(
  _id INTEGER
)
RETURNS JSON AS $$
DECLARE
  stack_info TEXT;
BEGIN
  UPDATE restaurant_themes
  SET is_deleted = TRUE
  WHERE id = _id AND is_deleted = FALSE;
  
  IF FOUND THEN
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'Restaurant theme deleted successfully',
      'rowsAffected', 1
    );
  ELSE
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'Restaurant theme not found',
      'rowsAffected', 0
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object(
        'isError', TRUE,
        'message', SQLERRM,
        'errorCode', SQLSTATE,
        'stack', stack_info
    );
END;
$$ LANGUAGE plpgsql;

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

CREATE OR REPLACE FUNCTION create_user(
  _username VARCHAR(50),
  _user_password VARCHAR(255)
)
RETURNS JSON AS $$
DECLARE
  res users;
  stack_info TEXT;
BEGIN
  INSERT INTO users (username, user_password)
  VALUES (_username, _user_password)
  RETURNING id, username, user_password, created_at, updated_at, is_deleted
  INTO res;
  
  RETURN json_build_object(
    'isError', FALSE,
    'message', 'User created successfully',
    'result', row_to_json(res)
  );
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object(
      'isError', TRUE,
      'message', SQLERRM,
      'errorCode', SQLSTATE,
      'stack', stack_info
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_user(
  _id INTEGER,
  _username VARCHAR(50) DEFAULT NULL,
  _user_password VARCHAR(255) DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
  stack_info TEXT;
  result users;
BEGIN
  UPDATE users
  SET
    username = COALESCE(_username, username),
    user_password = COALESCE(_user_password, user_password),
    updated_at = NOW()
  WHERE id = _id
  RETURNING id, username, user_password, created_at, updated_at, is_deleted
  INTO result;
  
  IF result IS NULL THEN
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'User not found',
      'result', NULL,
      'rowsAffected', 0
    );
  ELSE
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'User updated successfully',
      'result', row_to_json(result),
      'rowsAffected', 1
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object(
      'isError', TRUE,
      'message', SQLERRM,
      'errorCode', SQLSTATE,
      'stack', stack_info
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_user(
  _id INTEGER
)
RETURNS JSON AS $$
DECLARE
  stack_info TEXT;
BEGIN
  UPDATE users
  SET is_deleted = TRUE
  WHERE id = _id AND is_deleted = FALSE;
  
  IF FOUND THEN
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'User deleted successfully',
      'rowsAffected', 1
    );
  ELSE
    RETURN json_build_object(
      'isError', FALSE,
      'message', 'User not found',
      'rowsAffected', 0
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS stack_info = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object(
      'isError', TRUE,
      'message', SQLERRM,
      'errorCode', SQLSTATE,
      'stack', stack_info
    );
END;
$$ LANGUAGE plpgsql;

-- FUNCTIONS TRIGGERS

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_reservation_bonus() 
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_bonus = TRUE THEN
    NEW.meal_plan = 'AI';
    NEW.cost = 0;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGERS

CREATE TRIGGER update_reservation_bonus_trigger
BEFORE UPDATE ON reservations
FOR EACH ROW
WHEN (OLD.is_bonus <> NEW.is_bonus AND NEW.is_bonus = TRUE)
EXECUTE FUNCTION update_reservation_bonus();

CREATE OR REPLACE TRIGGER trigger_updated_at_agenda
BEFORE UPDATE ON agenda
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE OR REPLACE TRIGGER trigger_updated_at_reservations
BEFORE UPDATE ON reservations
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at();

CREATE OR REPLACE TRIGGER trigger_updated_at_users
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE OR REPLACE TRIGGER trigger_updated_at_restaurant_themes
BEFORE UPDATE ON restaurant_themes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
