
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

CREATE OR REPLACE FUNCTION get_monthly_statistics(fecha_i DATE, fecha_f DATE)
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

/*
UPDATE reservations SET is_noshow = TRUE WHERE fecha = '2023-05-27' AND room = 'P13';
*/
