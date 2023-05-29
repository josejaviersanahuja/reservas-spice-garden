-- cambia el nombre de la base de datos y añade _test
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
  is_deleted BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (fecha, hora, res_number, res_name, room)
);

INSERT INTO agenda (fecha, restaurant_theme_id) VALUES 
('2023-05-01', 1),
('2023-05-02', 2),
('2023-05-03', 1),
('2023-05-04', 3),
('2023-05-05', 1),
('2023-05-08', 3),
('2023-05-09', 1),
('2023-05-10', 2),
('2023-05-13', 1),
('2023-05-14', 2),
('2023-05-15', 1),
('2023-05-16', 3),
('2023-05-17', 1),
('2023-05-18', 2),
('2023-05-19', 1),
('2023-05-20', 3),
('2023-05-22', 2),
('2023-05-23', 1),
('2023-05-26', 2),
('2023-05-27', 1);

INSERT INTO reservations (fecha, hora, res_number, res_name, room, meal_plan, pax_number, cost, observations)
VALUES
  ('2023-05-01', '19:00', 001, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-01', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-01', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-01', '19:15', 004, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-01', '19:30', 005, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-01', '20:00', 006, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-01', '20:00', 007, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-01', '20:15', 008, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-01', '20:15', 009, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-01', '20:30', 010, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-01', '20:45', 011, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-01', '20:45', 012, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-01', '21:00', 013, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-01', '21:00', 014, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-01', '21:15', 015, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 2023-05-02
  ('2023-05-02', '19:00', 016, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-02', '19:00', 017, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-02', '19:15', 018, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-02', '19:15', 019, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-02', '19:30', 020, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-02', '20:00', 021, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-02', '20:00', 022, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-02', '20:15', 023, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-02', '20:15', 024, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-02', '20:30', 025, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-02', '20:45', 026, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-02', '20:45', 027, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-02', '21:00', 028, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-02', '21:00', 029, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-02', '21:15', 030, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 2023-05-03
  ('2023-05-03', '19:00', 031, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-03', '19:00', 032, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-03', '19:15', 033, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-03', '19:15', 034, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-03', '19:30', 035, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-03', '20:00', 036, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-03', '20:00', 037, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-03', '20:15', 038, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-03', '20:15', 039, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-03', '20:30', 040, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-03', '20:45', 041, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-03', '20:45', 042, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-03', '21:00', 043, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-03', '21:00', 044, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-03', '21:15', 045, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 04 de mayo
  ('2023-05-04', '19:00', 046, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-04', '19:00', 047, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-04', '19:15', 048, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-04', '19:15', 049, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-04', '19:30', 050, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-04', '20:00', 051, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-04', '20:00', 052, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-04', '20:15', 053, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-04', '20:15', 054, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-04', '20:30', 055, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-04', '20:45', 056, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-04', '20:45', 057, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-04', '21:00', 058, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-04', '21:00', 059, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-04', '21:15', 060, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 05 de mayo
  ('2023-05-05', '19:00', 061, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-05', '19:00', 062, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-05', '19:15', 063, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-05', '19:15', 064, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-05', '19:30', 065, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-05', '20:00', 066, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-05', '20:00', 067, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  
-- Reservas para el 8 de mayo de 2023
('2023-05-08', '19:00', 001, 'Juan Perez', 'P01', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-08', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-08', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-08', '20:00', 004, 'Ana Garcia', 'P04', 'FB', 4, 120.00, 'Observaciones de la reserva'),
('2023-05-08', '20:15', 005, 'Luisa Fernandez', 'P05', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-08', '21:00', 006, 'Carlos Sanchez', 'P06', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-08', '21:15', 007, 'Sofia Martinez', 'P07', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 9 de mayo de 2023
('2023-05-09', '19:00', 008, 'Juan Perez', 'P08', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-09', '19:00', 009, 'Maria Rodriguez', 'P09', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-09', '19:15', 010, 'Pedro Gomez', 'P10', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-09', '20:00', 011, 'Ana Garcia', 'P11', 'FB', 4, 120.00, 'Observaciones de la reserva'),
('2023-05-09', '20:15', 012, 'Luisa Fernandez', 'P12', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-09', '21:00', 013, 'Carlos Sanchez', 'P13', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-09', '21:15', 014, 'Sofia Martinez', 'P14', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 10 de mayo de 2023
('2023-05-10', '19:00', 015, 'Juan Perez', 'P15', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-10', '19:00', 016, 'Maria Rodriguez', 'P16', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-10', '19:30', 017, 'Pedro Gomez', 'P17', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-10', '20:15', 018, 'Luisa Fernandez', 'P18', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-10', '21:00', 019, 'Carlos Sanchez', 'P19', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-10', '21:30', 020, 'Sofia Martinez', 'P20', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 13 de mayo de 2023
('2023-05-13', '19:00', 021, 'Juan Perez', 'P21', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-13', '19:00', 022, 'Maria Rodriguez', 'P22', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-13', '19:30', 023, 'Pedro Gomez', '023', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-13', '20:15', 024, 'Luisa Fernandez', '124', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-13', '21:00', 025, 'Carlos Sanchez', '225', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-13', '21:30', 026, 'Sofia Martinez', '306', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 14 de mayo de 2023
('2023-05-14', '19:00', 027, 'Juan Perez', '307', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-14', '19:00', 028, 'Maria Rodriguez', '308', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-14', '19:30', 029, 'Pedro Gomez', '309', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-14', '20:15', 030, 'Luisa Fernandez', '212', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-14', '21:00', 031, 'Carlos Sanchez', '212', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-14', '21:30', 032, 'Sofia Martinez', '212', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 15 de mayo de 2023
('2023-05-15', '19:00', 033, 'Juan Perez', '212', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-15', '19:00', 034, 'Maria Rodriguez', '212', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-15', '19:30', 035, 'Pedro Gomez', '212', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-15', '20:15', 036, 'Luisa Fernandez', '212', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-15', '21:00', 037, 'Carlos Sanchez', '212', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-15', '21:30', 038, 'Sofia Martinez', '212', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 16 de mayo de 2023
('2023-05-16', '19:00', 039, 'Juan Perez', '212', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-16', '19:00', 040, 'Maria Rodriguez', '101', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-16', '19:30', 041, 'Pedro Gomez', '101', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-16', '20:15', 042, 'Luisa Fernandez', '101', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-16', '21:00', 043, 'Carlos Sanchez', '101', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-16', '21:30', 044, 'Sofia Martinez', '101', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 17 de mayo de 2023
('2023-05-17', '19:00', 045, 'Juan Perez', '101', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-17', '19:00', 046, 'Maria Rodriguez', '101', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-17', '19:30', 047, 'Pedro Gomez', '101', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-17', '20:15', 048, 'Luisa Fernandez', '101', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-17', '21:00', 049, 'Carlos Sanchez', '101', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-17', '21:30', 050, 'Sofia Martinez', '050', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 18 de mayo de 2023
('2023-05-18', '19:00', 051, 'Juan Perez', '101', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-18', '19:00', 052, 'Maria Rodriguez', '102', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-18', '19:30', 053, 'Pedro Gomez', '103', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-18', '20:15', 054, 'Luisa Fernandez', '104', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-18', '21:00', 055, 'Carlos Sanchez', '105', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-18', '21:30', 056, 'Sofia Martinez', '106', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 19 de mayo de 2023
('2023-05-19', '19:00', 057, 'Juan Perez', '107', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-19', '19:00', 058, 'Maria Rodriguez', '108', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-19', '19:30', 059, 'Pedro Gomez', '109', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-19', '20:15', 060, 'Luisa Fernandez', '110', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-19', '21:00', 061, 'Carlos Sanchez', '111', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-19', '21:30', 062, 'Sofia Martinez', '112', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 20 de mayo de 2023
('2023-05-20', '19:00', 063, 'Juan Perez', '113', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-20', '19:00', 064, 'Maria Rodriguez', '114', 'BB', 8, 80.00, 'Observaciones de la reserva'),

-- Reservas para el 22 de mayo de 2023
('2023-05-22', '19:00', 001, 'Juan Perez', 'P01', 'SC', 5, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '19:00', 003, 'Pedro Gomez', 'P03', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '19:00', 004, 'Ana Garcia', 'P04', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '19:00', 005, 'Luisa Fernandez', 'P05', 'AI', 10, 250.00, 'Observaciones de la reserva'),
('2023-05-22', '19:15', 006, 'Carlos Sanchez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-22', '19:15', 007, 'Sofia Hernandez', 'P07', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '19:15', 008, 'Jorge Ramirez', 'P08', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '19:15', 009, 'Laura Torres', 'P09', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '19:30', 010, 'Miguel Castro', 'P10', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-22', '19:30', 011, 'Fernanda Diaz', 'P11', 'SC', 3, 60.00, 'Observaciones de la reserva'),
('2023-05-22', '19:30', 012, 'Ricardo Martinez', 'P12', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '19:30', 013, 'Isabel Jimenez', 'P13', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '20:00', 014, 'Diego Vargas', 'P14', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '20:00', 015, 'Valentina Gutierrez', 'P15', 'AI', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '20:00', 016, 'Roberto Flores', 'P16', 'SC', 1, 20.00, 'Observaciones de la reserva'),
('2023-05-22', '20:00', 017, 'Carla Ortiz', 'P17', 'BB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '20:15', 018, 'Hector Aguilar', 'P18', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '20:15', 019, 'Paola Castro', 'P19', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '20:15', 020, 'Santiago Ramirez', 'P20', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-22', '20:15', 021, 'Daniela Torres', 'P21', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-22', '20:30', 022, 'Andres Hernandez', 'P22', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '20:30', 023, 'Camila Perez', '023', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '20:30', 024, 'Felipe Gomez', '124', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '20:30', 025, 'Lucia Garcia', '225', 'AI', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '20:45', 026, 'Gustavo Fernandez', '306', 'SC', 6, 120.00, 'Observaciones de la reserva'),
('2023-05-22', '20:45', 027, 'Natalia Rodriguez', '307', 'BB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '20:45', 028, 'Oscar Torres', '308', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '20:45', 029, 'Mariana Jimenez', '309', 'FB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '21:00', 030, 'Raul Martinez', '212', 'AI', 5, 125.00, 'Observaciones de la reserva'),
('2023-05-22', '21:00', 031, 'Carmen Jimenez', '212', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-22', '21:00', 032, 'Javier Ramirez', '212', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '21:00', 033, 'Lorena Gutierrez', '212', 'HB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '21:15', 034, 'Pablo Flores', '212', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '21:15', 035, 'Gabriela Ortiz', '212', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-22', '21:15', 036, 'Mauricio Aguilar', '212', 'SC', 2, 40.00, 'Observaciones de la reserva'),
('2023-05-22', '21:15', 037, 'Adriana Castro', '212', 'BB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '21:30', 038, 'Hugo Ramirez', '212', 'HB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '21:30', 039, 'Sara Torres', '212', 'FB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '21:30', 040, 'Luis Garcia', '101', 'AI', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '21:30', 041, 'Ana Fernandez', '101', 'SC', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '21:45', 042, 'Jorge Perez', '101', 'BB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '21:45', 043, 'Maria Rodriguez', '101', 'HB', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-22', '21:45', 044, 'Pedro Gomez', '101', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '21:45', 045, 'Ana Garcia', '101', 'AI', 2, 50.00, 'Observaciones de la reserva'),

-- Reservas para el 23 de mayo de 2023
('2023-05-23', '19:00', 046, 'Juan Perez', 'P01', 'SC', 5, 100.00, 'Observaciones de la reserva'),
('2023-05-23', '19:00', 047, 'Maria Rodriguez', 'P02', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '19:00', 048, 'Pedro Gomez', 'P03', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-23', '19:00', 049, 'Ana Garcia', 'P04', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-23', '19:00', 050, 'Luisa Fernandez', 'P05', 'AI', 10, 250.00, 'Observaciones de la reserva'),
('2023-05-23', '19:15', 051, 'Carlos Sanchez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-23', '19:15', 052, 'Sofia Hernandez', 'P07', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '19:15', 053, 'Jorge Ramirez', 'P08', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-23', '19:15', 054, 'Laura Torres', 'P09', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-23', '19:30', 055, 'Miguel Castro', 'P10', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-23', '19:30', 056, 'Fernanda Diaz', 'P11', 'SC', 3, 60.00, 'Observaciones de la reserva'),
('2023-05-23', '19:30', 057, 'Ricardo Martinez', 'P12', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '19:30', 058, 'Isabel Jimenez', 'P13', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-23', '20:00', 059, 'Diego Vargas', 'P14', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-23', '20:00', 060, 'Valentina Gutierrez', 'P15', 'AI', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '20:00', 061, 'Roberto Flores', 'P16', 'SC', 1, 20.00, 'Observaciones de la reserva'),
('2023-05-23', '20:00', 062, 'Carla Ortiz', 'P17', 'BB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-23', '20:15', 063, 'Hector Aguilar', 'P18', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '20:15', 064, 'Paola Castro', 'P19', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-23', '20:15', 065, 'Santiago Ramirez', 'P20', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-23', '20:15', 066, 'Daniela Torres', 'P21', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-23', '20:30', 067, 'Andres Hernandez', 'P22', 'BB', 2, 50.00, 'Observaciones de la reserva'),

-- Reservas para el 26 de mayo de 2023
('2023-05-26', '19:00', 001, 'Juan Perez', 'P01', 'SC', 8, 100.00, 'Observaciones de la reserva'),
('2023-05-26', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 6, 120.00, 'Observaciones de la reserva'),
('2023-05-26', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 4, 150.00, 'Observaciones de la reserva'),
('2023-05-26', '19:15', 004, 'Ana Fernandez', 'P04', 'FB', 2, 200.00, 'Observaciones de la reserva'),
('2023-05-26', '19:30', 005, 'Luisa Martinez', 'P05', 'AI', 6, 300.00, 'Observaciones de la reserva'),
('2023-05-26', '19:30', 006, 'Jorge Hernandez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-26', '20:00', 007, 'Carla Perez', 'P07', 'BB', 2, 60.00, 'Observaciones de la reserva'),
('2023-05-26', '20:00', 008, 'Miguel Rodriguez', 'P08', 'HB', 4, 120.00, 'Observaciones de la reserva'),
('2023-05-26', '20:15', 009, 'Sofia Gomez', 'P09', 'FB', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-26', '20:15', 010, 'Pablo Fernandez', 'P10', 'AI', 4, 240.00, 'Observaciones de la reserva'),
('2023-05-26', '20:30', 011, 'Laura Martinez', 'P11', 'SC', 2, 40.00, 'Observaciones de la reserva'),
('2023-05-26', '20:30', 012, 'Carlos Hernandez', 'P12', 'BB', 4, 80.00, 'Observaciones de la reserva'),


-- Reservas para el 27 de mayo de 2023
('2023-05-27', '19:00', 013, 'Ana Perez', 'P13', 'HB', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-27', '19:00', 014, 'Juan Rodriguez', 'P14', 'FB', 4, 160.00, 'Observaciones de la reserva'),
('2023-05-27', '19:15', 015, 'Maria Gomez', 'P15', 'AI', 2, 100.00, 'Observaciones de la reserva'),
('2023-05-27', '19:15', 016, 'Pedro Fernandez', 'P16', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-27', '19:30', 017, 'Ana Martinez', 'P17', 'BB', 6, 120.00, 'Observaciones de la reserva'),
('2023-05-27', '19:30', 018, 'Juan Hernandez', 'P18', 'HB', 4, 150.00, 'Observaciones de la reserva'),
('2023-05-27', '20:00', 019, 'Maria Perez', 'P19', 'FB', 2, 80.00, 'Observaciones de la reserva'),
('2023-05-27', '20:00', 020, 'Pedro Rodriguez', 'P20', 'AI', 4, 200.00, 'Observaciones de la reserva'),
('2023-05-27', '20:15', 021, 'Ana Gomez', 'P21', 'SC', 6, 120.00, 'Observaciones de la reserva'),
('2023-05-27', '20:15', 022, 'Juan Fernandez', 'P22', 'BB', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-27', '20:30', 023, 'Maria Martinez', '023', 'HB', 2, 60.00, 'Observaciones de la reserva'),
('2023-05-27', '20:30', 024, 'Pedro Hernandez', '124', 'FB', 4, 160.00, 'Observaciones de la reserva');

INSERT INTO reservations (fecha, hora, res_number, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations)
VALUES
  ('2023-05-26', '19:00', 1, 'JJ', '212', 'true', 2, 'AI', 2, 0, 'Primera reserva con bonus'),
  ('2023-05-27', '19:00', 1, 'JJ', '212', 'true', 2, 'AI', 2, 0, 'Segunda reserva con bonus');

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
    RETURN -1; -- fecha no encontrada en agenda
  ELSIF reserved_seats IS NULL THEN
    RETURN max_seats; -- no hay reservas para esa fecha y hora
  ELSE
    RETURN max_seats - reserved_seats; -- devuelve el número de asientos disponibles
  END IF;
END;
$$ LANGUAGE plpgsql;
