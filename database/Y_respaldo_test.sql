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

INSERT INTO users (username, user_password) VALUES ('reception', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('cocina', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('maitre', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('direccion', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
DROP TABLE IF EXISTS restaurant_themes;

CREATE TABLE restaurant_themes (
  id SERIAL PRIMARY KEY,
  theme_name VARCHAR(255) NOT NULL,
  description TEXT,
  image_url VARCHAR(255) DEFAULT NULL,
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

TRUNCATE agenda RESTART IDENTITY CASCADE;
INSERT INTO agenda (fecha, restaurant_theme_id) VALUES 
('2023-07-01', 1),
('2023-07-02', 2),
('2023-07-03', 1),
('2023-07-04', 3),
('2023-07-05', 1),
('2023-07-08', 3),
('2023-07-09', 1),
('2023-07-10', 2),
('2023-07-13', 1),
('2023-07-14', 2),
('2023-07-15', 1),
('2023-07-16', 3),
('2023-07-17', 1),
('2023-07-18', 2),
('2023-07-19', 1),
('2023-07-20', 3),
('2023-07-22', 2),
('2023-07-23', 1),
('2023-07-26', 2),
('2023-07-27', 1);

TRUNCATE reservations RESTART IDENTITY;
INSERT INTO reservations (fecha, hora, res_number, res_name, room, meal_plan, pax_number, cost, observations)
VALUES
  ('2023-07-01', '19:00', 001, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-01', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-01', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-01', '19:15', 004, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-01', '19:30', 005, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-01', '20:00', 006, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-01', '20:00', 007, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-01', '20:15', 008, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-01', '20:15', 009, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-01', '20:30', 010, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-01', '20:45', 011, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-01', '20:45', 012, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-01', '21:00', 013, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-01', '21:00', 014, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-01', '21:15', 015, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 2023-07-02
  ('2023-07-02', '19:00', 016, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-02', '19:00', 017, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-02', '19:15', 018, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-02', '19:15', 019, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-02', '19:30', 020, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-02', '20:00', 021, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-02', '20:00', 022, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-02', '20:15', 023, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-02', '20:15', 024, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-02', '20:30', 025, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-02', '20:45', 026, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-02', '20:45', 027, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-02', '21:00', 028, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-02', '21:00', 029, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-02', '21:15', 030, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 2023-07-03
  ('2023-07-03', '19:00', 031, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-03', '19:00', 032, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-03', '19:15', 033, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-03', '19:15', 034, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-03', '19:30', 035, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-03', '20:00', 036, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-03', '20:00', 037, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-03', '20:15', 038, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-03', '20:15', 039, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-03', '20:30', 040, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-03', '20:45', 041, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-03', '20:45', 042, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-03', '21:00', 043, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-03', '21:00', 044, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-03', '21:15', 045, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 04 de mayo
  ('2023-07-04', '19:00', 046, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-04', '19:00', 047, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-04', '19:15', 048, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-04', '19:15', 049, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-04', '19:30', 050, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-04', '20:00', 051, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-04', '20:00', 052, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-04', '20:15', 053, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-04', '20:15', 054, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-04', '20:30', 055, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-04', '20:45', 056, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-04', '20:45', 057, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-04', '21:00', 058, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-04', '21:00', 059, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-04', '21:15', 060, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 05 de mayo
  ('2023-07-05', '19:00', 061, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-05', '19:00', 062, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-05', '19:15', 063, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-05', '19:15', 064, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-05', '19:30', 065, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-05', '20:00', 066, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-05', '20:00', 067, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  
-- Reservas para el 8 de mayo de 2023
('2023-07-08', '19:00', 001, 'Juan Perez', 'P01', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-08', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-08', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-08', '20:00', 004, 'Ana Garcia', 'P04', 'FB', 4, 120.00, 'Observaciones de la reserva'),
('2023-07-08', '20:15', 005, 'Luisa Fernandez', 'P05', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-08', '21:00', 006, 'Carlos Sanchez', 'P06', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-08', '21:15', 007, 'Sofia Martinez', 'P07', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 9 de mayo de 2023
('2023-07-09', '19:00', 008, 'Juan Perez', 'P08', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-09', '19:00', 009, 'Maria Rodriguez', 'P09', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-09', '19:15', 010, 'Pedro Gomez', 'P10', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-09', '20:00', 011, 'Ana Garcia', 'P11', 'FB', 4, 120.00, 'Observaciones de la reserva'),
('2023-07-09', '20:15', 012, 'Luisa Fernandez', 'P12', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-09', '21:00', 013, 'Carlos Sanchez', 'P13', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-09', '21:15', 014, 'Sofia Martinez', 'P14', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 10 de mayo de 2023
('2023-07-10', '19:00', 015, 'Juan Perez', 'P15', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-10', '19:00', 016, 'Maria Rodriguez', 'P16', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-10', '19:30', 017, 'Pedro Gomez', 'P17', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-10', '20:15', 018, 'Luisa Fernandez', 'P18', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-10', '21:00', 019, 'Carlos Sanchez', 'P19', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-10', '21:30', 020, 'Sofia Martinez', 'P20', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 13 de mayo de 2023
('2023-07-13', '19:00', 021, 'Juan Perez', 'P21', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-13', '19:00', 022, 'Maria Rodriguez', 'P22', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-13', '19:30', 023, 'Pedro Gomez', '023', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-13', '20:15', 024, 'Luisa Fernandez', '124', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-13', '21:00', 025, 'Carlos Sanchez', '225', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-13', '21:30', 026, 'Sofia Martinez', '306', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 14 de mayo de 2023
('2023-07-14', '19:00', 027, 'Juan Perez', '307', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-14', '19:00', 028, 'Maria Rodriguez', '308', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-14', '19:30', 029, 'Pedro Gomez', '309', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-14', '20:15', 030, 'Luisa Fernandez', '212', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-14', '21:00', 031, 'Carlos Sanchez', '212', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-14', '21:30', 032, 'Sofia Martinez', '212', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 15 de mayo de 2023
('2023-07-15', '19:00', 033, 'Juan Perez', '212', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-15', '19:00', 034, 'Maria Rodriguez', '212', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-15', '19:30', 035, 'Pedro Gomez', '212', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-15', '20:15', 036, 'Luisa Fernandez', '212', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-15', '21:00', 037, 'Carlos Sanchez', '212', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-15', '21:30', 038, 'Sofia Martinez', '212', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 16 de mayo de 2023
('2023-07-16', '19:00', 039, 'Juan Perez', '212', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-16', '19:00', 040, 'Maria Rodriguez', '101', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-16', '19:30', 041, 'Pedro Gomez', '101', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-16', '20:15', 042, 'Luisa Fernandez', '101', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-16', '21:00', 043, 'Carlos Sanchez', '101', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-16', '21:30', 044, 'Sofia Martinez', '101', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 17 de mayo de 2023
('2023-07-17', '19:00', 045, 'Juan Perez', '101', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-17', '19:00', 046, 'Maria Rodriguez', '101', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-17', '19:30', 047, 'Pedro Gomez', '101', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-17', '20:15', 048, 'Luisa Fernandez', '101', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-17', '21:00', 049, 'Carlos Sanchez', '101', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-17', '21:30', 050, 'Sofia Martinez', '050', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 18 de mayo de 2023
('2023-07-18', '19:00', 051, 'Juan Perez', '101', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-18', '19:00', 052, 'Maria Rodriguez', '102', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-18', '19:30', 053, 'Pedro Gomez', '103', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-18', '20:15', 054, 'Luisa Fernandez', '104', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-18', '21:00', 055, 'Carlos Sanchez', '105', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-18', '21:30', 056, 'Sofia Martinez', '106', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 19 de mayo de 2023
('2023-07-19', '19:00', 057, 'Juan Perez', '107', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-19', '19:00', 058, 'Maria Rodriguez', '108', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-19', '19:30', 059, 'Pedro Gomez', '109', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-19', '20:15', 060, 'Luisa Fernandez', '110', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-19', '21:00', 061, 'Carlos Sanchez', '111', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-19', '21:30', 062, 'Sofia Martinez', '112', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 20 de mayo de 2023
('2023-07-20', '19:00', 063, 'Juan Perez', '113', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-20', '19:00', 064, 'Maria Rodriguez', '114', 'BB', 8, 80.00, 'Observaciones de la reserva'),

-- Reservas para el 22 de mayo de 2023
('2023-07-22', '19:00', 001, 'Juan Perez', 'P01', 'SC', 5, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '19:00', 003, 'Pedro Gomez', 'P03', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '19:00', 004, 'Ana Garcia', 'P04', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '19:00', 005, 'Luisa Fernandez', 'P05', 'AI', 10, 250.00, 'Observaciones de la reserva'),
('2023-07-22', '19:15', 006, 'Carlos Sanchez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-22', '19:15', 007, 'Sofia Hernandez', 'P07', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '19:15', 008, 'Jorge Ramirez', 'P08', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '19:15', 009, 'Laura Torres', 'P09', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '19:30', 010, 'Miguel Castro', 'P10', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-22', '19:30', 011, 'Fernanda Diaz', 'P11', 'SC', 3, 60.00, 'Observaciones de la reserva'),
('2023-07-22', '19:30', 012, 'Ricardo Martinez', 'P12', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '19:30', 013, 'Isabel Jimenez', 'P13', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '20:00', 014, 'Diego Vargas', 'P14', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '20:00', 015, 'Valentina Gutierrez', 'P15', 'AI', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '20:00', 016, 'Roberto Flores', 'P16', 'SC', 1, 20.00, 'Observaciones de la reserva'),
('2023-07-22', '20:00', 017, 'Carla Ortiz', 'P17', 'BB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '20:15', 018, 'Hector Aguilar', 'P18', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '20:15', 019, 'Paola Castro', 'P19', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '20:15', 020, 'Santiago Ramirez', 'P20', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-22', '20:15', 021, 'Daniela Torres', 'P21', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-22', '20:30', 022, 'Andres Hernandez', 'P22', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '20:30', 023, 'Camila Perez', '023', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '20:30', 024, 'Felipe Gomez', '124', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '20:30', 025, 'Lucia Garcia', '225', 'AI', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '20:45', 026, 'Gustavo Fernandez', '306', 'SC', 6, 120.00, 'Observaciones de la reserva'),
('2023-07-22', '20:45', 027, 'Natalia Rodriguez', '307', 'BB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '20:45', 028, 'Oscar Torres', '308', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '20:45', 029, 'Mariana Jimenez', '309', 'FB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '21:00', 030, 'Raul Martinez', '212', 'AI', 5, 125.00, 'Observaciones de la reserva'),
('2023-07-22', '21:00', 031, 'Carmen Jimenez', '212', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-22', '21:00', 032, 'Javier Ramirez', '212', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '21:00', 033, 'Lorena Gutierrez', '212', 'HB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '21:15', 034, 'Pablo Flores', '212', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '21:15', 035, 'Gabriela Ortiz', '212', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-22', '21:15', 036, 'Mauricio Aguilar', '212', 'SC', 2, 40.00, 'Observaciones de la reserva'),
('2023-07-22', '21:15', 037, 'Adriana Castro', '212', 'BB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '21:30', 038, 'Hugo Ramirez', '212', 'HB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '21:30', 039, 'Sara Torres', '212', 'FB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '21:30', 040, 'Luis Garcia', '101', 'AI', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '21:30', 041, 'Ana Fernandez', '101', 'SC', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '21:45', 042, 'Jorge Perez', '101', 'BB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '21:45', 043, 'Maria Rodriguez', '101', 'HB', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-22', '21:45', 044, 'Pedro Gomez', '101', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '21:45', 045, 'Ana Garcia', '101', 'AI', 2, 50.00, 'Observaciones de la reserva'),

-- Reservas para el 23 de mayo de 2023
('2023-07-23', '19:00', 046, 'Juan Perez', 'P01', 'SC', 5, 100.00, 'Observaciones de la reserva'),
('2023-07-23', '19:00', 047, 'Maria Rodriguez', 'P02', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '19:00', 048, 'Pedro Gomez', 'P03', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-23', '19:00', 049, 'Ana Garcia', 'P04', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-23', '19:00', 050, 'Luisa Fernandez', 'P05', 'AI', 10, 250.00, 'Observaciones de la reserva'),
('2023-07-23', '19:15', 051, 'Carlos Sanchez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-23', '19:15', 052, 'Sofia Hernandez', 'P07', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '19:15', 053, 'Jorge Ramirez', 'P08', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-23', '19:15', 054, 'Laura Torres', 'P09', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-23', '19:30', 055, 'Miguel Castro', 'P10', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-23', '19:30', 056, 'Fernanda Diaz', 'P11', 'SC', 3, 60.00, 'Observaciones de la reserva'),
('2023-07-23', '19:30', 057, 'Ricardo Martinez', 'P12', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '19:30', 058, 'Isabel Jimenez', 'P13', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-23', '20:00', 059, 'Diego Vargas', 'P14', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-23', '20:00', 060, 'Valentina Gutierrez', 'P15', 'AI', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '20:00', 061, 'Roberto Flores', 'P16', 'SC', 1, 20.00, 'Observaciones de la reserva'),
('2023-07-23', '20:00', 062, 'Carla Ortiz', 'P17', 'BB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-23', '20:15', 063, 'Hector Aguilar', 'P18', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '20:15', 064, 'Paola Castro', 'P19', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-23', '20:15', 065, 'Santiago Ramirez', 'P20', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-23', '20:15', 066, 'Daniela Torres', 'P21', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-23', '20:30', 067, 'Andres Hernandez', 'P22', 'BB', 2, 50.00, 'Observaciones de la reserva'),

-- Reservas para el 26 de mayo de 2023
('2023-07-26', '19:00', 001, 'Juan Perez', 'P01', 'SC', 8, 100.00, 'Observaciones de la reserva'),
('2023-07-26', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 6, 120.00, 'Observaciones de la reserva'),
('2023-07-26', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 4, 150.00, 'Observaciones de la reserva'),
('2023-07-26', '19:15', 004, 'Ana Fernandez', 'P04', 'FB', 2, 200.00, 'Observaciones de la reserva'),
('2023-07-26', '19:30', 005, 'Luisa Martinez', 'P05', 'AI', 6, 300.00, 'Observaciones de la reserva'),
('2023-07-26', '19:30', 006, 'Jorge Hernandez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-26', '20:00', 007, 'Carla Perez', 'P07', 'BB', 2, 60.00, 'Observaciones de la reserva'),
('2023-07-26', '20:00', 008, 'Miguel Rodriguez', 'P08', 'HB', 4, 120.00, 'Observaciones de la reserva'),
('2023-07-26', '20:15', 009, 'Sofia Gomez', 'P09', 'FB', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-26', '20:15', 010, 'Pablo Fernandez', 'P10', 'AI', 4, 240.00, 'Observaciones de la reserva'),
('2023-07-26', '20:30', 011, 'Laura Martinez', 'P11', 'SC', 2, 40.00, 'Observaciones de la reserva'),
('2023-07-26', '20:30', 012, 'Carlos Hernandez', 'P12', 'BB', 4, 80.00, 'Observaciones de la reserva'),


-- Reservas para el 27 de mayo de 2023
('2023-07-27', '19:00', 013, 'Ana Perez', 'P13', 'HB', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-27', '19:00', 014, 'Juan Rodriguez', 'P14', 'FB', 4, 160.00, 'Observaciones de la reserva'),
('2023-07-27', '19:15', 015, 'Maria Gomez', 'P15', 'AI', 2, 100.00, 'Observaciones de la reserva'),
('2023-07-27', '19:15', 016, 'Pedro Fernandez', 'P16', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-27', '19:30', 017, 'Ana Martinez', 'P17', 'BB', 6, 120.00, 'Observaciones de la reserva'),
('2023-07-27', '19:30', 018, 'Juan Hernandez', 'P18', 'HB', 4, 150.00, 'Observaciones de la reserva'),
('2023-07-27', '20:00', 019, 'Maria Perez', 'P19', 'FB', 2, 80.00, 'Observaciones de la reserva'),
('2023-07-27', '20:00', 020, 'Pedro Rodriguez', 'P20', 'AI', 4, 200.00, 'Observaciones de la reserva'),
('2023-07-27', '20:15', 021, 'Ana Gomez', 'P21', 'SC', 6, 120.00, 'Observaciones de la reserva'),
('2023-07-27', '20:15', 022, 'Juan Fernandez', 'P22', 'BB', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-27', '20:30', 023, 'Maria Martinez', '023', 'HB', 2, 60.00, 'Observaciones de la reserva'),
('2023-07-27', '20:30', 024, 'Pedro Hernandez', '124', 'FB', 4, 160.00, 'Observaciones de la reserva');

INSERT INTO reservations (fecha, hora, res_number, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations)
VALUES
  ('2023-07-26', '19:00', 1, 'JJ', '212', 'true', 2, 'AI', 2, 0, 'Primera reserva con bonus'),
  ('2023-07-27', '19:00', 1, 'JJ', '212', 'true', 2, 'AI', 2, 0, 'Segunda reserva con bonus');

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

-- this function was used inside agenda component
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
        RETURN json_build_object(
            'isError', TRUE,
            'message', 'Bad Request 400 Cant create agenda in the past',
            'errorCode', 'P0001'
        );
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

CREATE OR REPLACE FUNCTION get_agenda_info_between_dates(_fechai DATE, _fechaf DATE)
RETURNS JSON AS $$
DECLARE
    agenda_info JSON;
    stack_info TEXT;
BEGIN
    -- Obtener la información de la agenda y el tema del restaurante para la fecha especificada
    SELECT
        json_agg(
            json_build_object(
                'fecha', a.fecha,
                'themeName', rt.theme_name,
                'imageUrl', rt.image_url,
                't1900', a.t1900,
                't1915', a.t1915,
                't1930', a.t1930,
                't1945', a.t1945,
                't2000', a.t2000,
                't2015', a.t2015,
                't2030', a.t2030,
                't2045', a.t2045,
                't2100', a.t2100,
                't2115', a.t2115,
                't2130', a.t2130,
                't2145', a.t2145
            ) ORDER BY a.fecha ASC
        ) INTO agenda_info
    FROM
        agenda AS a
    JOIN
        restaurant_themes AS rt ON a.restaurant_theme_id = rt.id
    WHERE
        a.fecha >= _fechai
    AND
        a.fecha < _fechaf;

    RETURN json_build_object(
        'isError', FALSE,
        'result', agenda_info
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

CREATE OR REPLACE FUNCTION create_restaurant_theme(
  _theme_name VARCHAR(255),
  _description TEXT,
  _image_url VARCHAR(255) DEFAULT NULL
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
    'result', json_build_object(
      'id', res.id,
      'themeName', res.theme_name,
      'description', res.description,
      'imageUrl', res.image_url,
      'createdAt', res.created_at,
      'updatedAt', res.updated_at,
      'isDeleted', res.is_deleted
    )
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
      'result', json_build_object(
        'id', result.id,
        'themeName', result.theme_name,
        'description', result.description,
        'imageUrl', result.image_url,
        'createdAt', result.created_at,
        'updatedAt', result.updated_at,
        'isDeleted', result.is_deleted
      ),
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
CREATE OR REPLACE PROCEDURE seed()
LANGUAGE SQL
AS $$

TRUNCATE restaurant_themes RESTART IDENTITY CASCADE;
TRUNCATE agenda RESTART IDENTITY CASCADE;
TRUNCATE reservations RESTART IDENTITY;
TRUNCATE users RESTART IDENTITY;

INSERT INTO users (username, user_password) VALUES ('reception', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('cocina', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('maitre', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('direccion', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');

INSERT INTO restaurant_themes (theme_name, description, image_url) VALUES
('Restaurante Mexicano', 'Restaurante de comida mexicana', ''),
('Restaurante Italiano', 'Restaurante de comida italiana', ''),
('Restaurante Hindú', 'Restaurante de comida hindú', '');

INSERT INTO agenda (fecha, restaurant_theme_id) VALUES 
('2023-07-01', 1),
('2023-07-02', 2),
('2023-07-03', 1),
('2023-07-04', 3),
('2023-07-05', 1),
('2023-07-08', 3),
('2023-07-09', 1),
('2023-07-10', 2),
('2023-07-13', 1),
('2023-07-14', 2),
('2023-07-15', 1),
('2023-07-16', 3),
('2023-07-17', 1),
('2023-07-18', 2),
('2023-07-19', 1),
('2023-07-20', 3),
('2023-07-22', 2),
('2023-07-23', 1),
('2023-07-26', 2),
('2023-07-27', 1);

INSERT INTO reservations (fecha, hora, res_number, res_name, room, meal_plan, pax_number, cost, observations)
VALUES
  ('2023-07-01', '19:00', 001, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-01', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-01', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-01', '19:15', 004, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-01', '19:30', 005, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-01', '20:00', 006, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-01', '20:00', 007, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-01', '20:15', 008, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-01', '20:15', 009, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-01', '20:30', 010, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-01', '20:45', 011, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-01', '20:45', 012, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-01', '21:00', 013, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-01', '21:00', 014, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-01', '21:15', 015, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 2023-07-02
  ('2023-07-02', '19:00', 016, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-02', '19:00', 017, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-02', '19:15', 018, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-02', '19:15', 019, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-02', '19:30', 020, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-02', '20:00', 021, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-02', '20:00', 022, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-02', '20:15', 023, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-02', '20:15', 024, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-02', '20:30', 025, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-02', '20:45', 026, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-02', '20:45', 027, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-02', '21:00', 028, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-02', '21:00', 029, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-02', '21:15', 030, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 2023-07-03
  ('2023-07-03', '19:00', 031, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-03', '19:00', 032, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-03', '19:15', 033, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-03', '19:15', 034, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-03', '19:30', 035, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-03', '20:00', 036, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-03', '20:00', 037, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-03', '20:15', 038, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-03', '20:15', 039, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-03', '20:30', 040, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-03', '20:45', 041, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-03', '20:45', 042, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-03', '21:00', 043, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-03', '21:00', 044, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-03', '21:15', 045, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 04 de mayo
  ('2023-07-04', '19:00', 046, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-04', '19:00', 047, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-04', '19:15', 048, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-04', '19:15', 049, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-04', '19:30', 050, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-04', '20:00', 051, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-04', '20:00', 052, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-04', '20:15', 053, 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-04', '20:15', 054, 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-04', '20:30', 055, 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-04', '20:45', 056, 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-04', '20:45', 057, 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-04', '21:00', 058, 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-04', '21:00', 059, 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-04', '21:15', 060, 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 05 de mayo
  ('2023-07-05', '19:00', 061, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-05', '19:00', 062, 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-07-05', '19:15', 063, 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-07-05', '19:15', 064, 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-07-05', '19:30', 065, 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-07-05', '20:00', 066, 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-07-05', '20:00', 067, 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  
-- Reservas para el 8 de mayo de 2023
('2023-07-08', '19:00', 001, 'Juan Perez', 'P01', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-08', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-08', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-08', '20:00', 004, 'Ana Garcia', 'P04', 'FB', 4, 120.00, 'Observaciones de la reserva'),
('2023-07-08', '20:15', 005, 'Luisa Fernandez', 'P05', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-08', '21:00', 006, 'Carlos Sanchez', 'P06', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-08', '21:15', 007, 'Sofia Martinez', 'P07', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 9 de mayo de 2023
('2023-07-09', '19:00', 008, 'Juan Perez', 'P08', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-09', '19:00', 009, 'Maria Rodriguez', 'P09', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-09', '19:15', 010, 'Pedro Gomez', 'P10', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-09', '20:00', 011, 'Ana Garcia', 'P11', 'FB', 4, 120.00, 'Observaciones de la reserva'),
('2023-07-09', '20:15', 012, 'Luisa Fernandez', 'P12', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-09', '21:00', 013, 'Carlos Sanchez', 'P13', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-09', '21:15', 014, 'Sofia Martinez', 'P14', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 10 de mayo de 2023
('2023-07-10', '19:00', 015, 'Juan Perez', 'P15', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-10', '19:00', 016, 'Maria Rodriguez', 'P16', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-10', '19:30', 017, 'Pedro Gomez', 'P17', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-10', '20:15', 018, 'Luisa Fernandez', 'P18', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-10', '21:00', 019, 'Carlos Sanchez', 'P19', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-10', '21:30', 020, 'Sofia Martinez', 'P20', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 13 de mayo de 2023
('2023-07-13', '19:00', 021, 'Juan Perez', 'P21', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-13', '19:00', 022, 'Maria Rodriguez', 'P22', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-13', '19:30', 023, 'Pedro Gomez', '023', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-13', '20:15', 024, 'Luisa Fernandez', '124', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-13', '21:00', 025, 'Carlos Sanchez', '225', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-13', '21:30', 026, 'Sofia Martinez', '306', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 14 de mayo de 2023
('2023-07-14', '19:00', 027, 'Juan Perez', '307', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-14', '19:00', 028, 'Maria Rodriguez', '308', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-14', '19:30', 029, 'Pedro Gomez', '309', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-14', '20:15', 030, 'Luisa Fernandez', '212', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-14', '21:00', 031, 'Carlos Sanchez', '212', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-14', '21:30', 032, 'Sofia Martinez', '212', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 15 de mayo de 2023
('2023-07-15', '19:00', 033, 'Juan Perez', '212', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-15', '19:00', 034, 'Maria Rodriguez', '212', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-15', '19:30', 035, 'Pedro Gomez', '212', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-15', '20:15', 036, 'Luisa Fernandez', '212', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-15', '21:00', 037, 'Carlos Sanchez', '212', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-15', '21:30', 038, 'Sofia Martinez', '212', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 16 de mayo de 2023
('2023-07-16', '19:00', 039, 'Juan Perez', '212', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-16', '19:00', 040, 'Maria Rodriguez', '101', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-16', '19:30', 041, 'Pedro Gomez', '101', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-16', '20:15', 042, 'Luisa Fernandez', '101', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-16', '21:00', 043, 'Carlos Sanchez', '101', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-16', '21:30', 044, 'Sofia Martinez', '101', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 17 de mayo de 2023
('2023-07-17', '19:00', 045, 'Juan Perez', '101', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-17', '19:00', 046, 'Maria Rodriguez', '101', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-17', '19:30', 047, 'Pedro Gomez', '101', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-17', '20:15', 048, 'Luisa Fernandez', '101', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-17', '21:00', 049, 'Carlos Sanchez', '101', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-17', '21:30', 050, 'Sofia Martinez', '050', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 18 de mayo de 2023
('2023-07-18', '19:00', 051, 'Juan Perez', '101', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-18', '19:00', 052, 'Maria Rodriguez', '102', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-18', '19:30', 053, 'Pedro Gomez', '103', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-18', '20:15', 054, 'Luisa Fernandez', '104', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-18', '21:00', 055, 'Carlos Sanchez', '105', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-18', '21:30', 056, 'Sofia Martinez', '106', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 19 de mayo de 2023
('2023-07-19', '19:00', 057, 'Juan Perez', '107', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-19', '19:00', 058, 'Maria Rodriguez', '108', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-07-19', '19:30', 059, 'Pedro Gomez', '109', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-07-19', '20:15', 060, 'Luisa Fernandez', '110', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-19', '21:00', 061, 'Carlos Sanchez', '111', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-07-19', '21:30', 062, 'Sofia Martinez', '112', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 20 de mayo de 2023
('2023-07-20', '19:00', 063, 'Juan Perez', '113', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-07-20', '19:00', 064, 'Maria Rodriguez', '114', 'BB', 8, 80.00, 'Observaciones de la reserva'),

-- Reservas para el 22 de mayo de 2023
('2023-07-22', '19:00', 001, 'Juan Perez', 'P01', 'SC', 5, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '19:00', 003, 'Pedro Gomez', 'P03', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '19:00', 004, 'Ana Garcia', 'P04', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '19:00', 005, 'Luisa Fernandez', 'P05', 'AI', 10, 250.00, 'Observaciones de la reserva'),
('2023-07-22', '19:15', 006, 'Carlos Sanchez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-22', '19:15', 007, 'Sofia Hernandez', 'P07', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '19:15', 008, 'Jorge Ramirez', 'P08', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '19:15', 009, 'Laura Torres', 'P09', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '19:30', 010, 'Miguel Castro', 'P10', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-22', '19:30', 011, 'Fernanda Diaz', 'P11', 'SC', 3, 60.00, 'Observaciones de la reserva'),
('2023-07-22', '19:30', 012, 'Ricardo Martinez', 'P12', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '19:30', 013, 'Isabel Jimenez', 'P13', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '20:00', 014, 'Diego Vargas', 'P14', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '20:00', 015, 'Valentina Gutierrez', 'P15', 'AI', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '20:00', 016, 'Roberto Flores', 'P16', 'SC', 1, 20.00, 'Observaciones de la reserva'),
('2023-07-22', '20:00', 017, 'Carla Ortiz', 'P17', 'BB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '20:15', 018, 'Hector Aguilar', 'P18', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '20:15', 019, 'Paola Castro', 'P19', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '20:15', 020, 'Santiago Ramirez', 'P20', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-22', '20:15', 021, 'Daniela Torres', 'P21', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-22', '20:30', 022, 'Andres Hernandez', 'P22', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '20:30', 023, 'Camila Perez', '023', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '20:30', 024, 'Felipe Gomez', '124', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '20:30', 025, 'Lucia Garcia', '225', 'AI', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '20:45', 026, 'Gustavo Fernandez', '306', 'SC', 6, 120.00, 'Observaciones de la reserva'),
('2023-07-22', '20:45', 027, 'Natalia Rodriguez', '307', 'BB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '20:45', 028, 'Oscar Torres', '308', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '20:45', 029, 'Mariana Jimenez', '309', 'FB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '21:00', 030, 'Raul Martinez', '212', 'AI', 5, 125.00, 'Observaciones de la reserva'),
('2023-07-22', '21:00', 031, 'Carmen Jimenez', '212', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-22', '21:00', 032, 'Javier Ramirez', '212', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '21:00', 033, 'Lorena Gutierrez', '212', 'HB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '21:15', 034, 'Pablo Flores', '212', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '21:15', 035, 'Gabriela Ortiz', '212', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-22', '21:15', 036, 'Mauricio Aguilar', '212', 'SC', 2, 40.00, 'Observaciones de la reserva'),
('2023-07-22', '21:15', 037, 'Adriana Castro', '212', 'BB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '21:30', 038, 'Hugo Ramirez', '212', 'HB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '21:30', 039, 'Sara Torres', '212', 'FB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-22', '21:30', 040, 'Luis Garcia', '101', 'AI', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-22', '21:30', 041, 'Ana Fernandez', '101', 'SC', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-22', '21:45', 042, 'Jorge Perez', '101', 'BB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-22', '21:45', 043, 'Maria Rodriguez', '101', 'HB', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-22', '21:45', 044, 'Pedro Gomez', '101', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-22', '21:45', 045, 'Ana Garcia', '101', 'AI', 2, 50.00, 'Observaciones de la reserva'),

-- Reservas para el 23 de mayo de 2023
('2023-07-23', '19:00', 046, 'Juan Perez', 'P01', 'SC', 5, 100.00, 'Observaciones de la reserva'),
('2023-07-23', '19:00', 047, 'Maria Rodriguez', 'P02', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '19:00', 048, 'Pedro Gomez', 'P03', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-23', '19:00', 049, 'Ana Garcia', 'P04', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-23', '19:00', 050, 'Luisa Fernandez', 'P05', 'AI', 10, 250.00, 'Observaciones de la reserva'),
('2023-07-23', '19:15', 051, 'Carlos Sanchez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-23', '19:15', 052, 'Sofia Hernandez', 'P07', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '19:15', 053, 'Jorge Ramirez', 'P08', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-23', '19:15', 054, 'Laura Torres', 'P09', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-23', '19:30', 055, 'Miguel Castro', 'P10', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-23', '19:30', 056, 'Fernanda Diaz', 'P11', 'SC', 3, 60.00, 'Observaciones de la reserva'),
('2023-07-23', '19:30', 057, 'Ricardo Martinez', 'P12', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '19:30', 058, 'Isabel Jimenez', 'P13', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-07-23', '20:00', 059, 'Diego Vargas', 'P14', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-07-23', '20:00', 060, 'Valentina Gutierrez', 'P15', 'AI', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '20:00', 061, 'Roberto Flores', 'P16', 'SC', 1, 20.00, 'Observaciones de la reserva'),
('2023-07-23', '20:00', 062, 'Carla Ortiz', 'P17', 'BB', 0, 0.00, 'Observaciones de la reserva'),
('2023-07-23', '20:15', 063, 'Hector Aguilar', 'P18', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-07-23', '20:15', 064, 'Paola Castro', 'P19', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-07-23', '20:15', 065, 'Santiago Ramirez', 'P20', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-07-23', '20:15', 066, 'Daniela Torres', 'P21', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-23', '20:30', 067, 'Andres Hernandez', 'P22', 'BB', 2, 50.00, 'Observaciones de la reserva'),

-- Reservas para el 26 de mayo de 2023
('2023-07-26', '19:00', 001, 'Juan Perez', 'P01', 'SC', 8, 100.00, 'Observaciones de la reserva'),
('2023-07-26', '19:00', 002, 'Maria Rodriguez', 'P02', 'BB', 6, 120.00, 'Observaciones de la reserva'),
('2023-07-26', '19:15', 003, 'Pedro Gomez', 'P03', 'HB', 4, 150.00, 'Observaciones de la reserva'),
('2023-07-26', '19:15', 004, 'Ana Fernandez', 'P04', 'FB', 2, 200.00, 'Observaciones de la reserva'),
('2023-07-26', '19:30', 005, 'Luisa Martinez', 'P05', 'AI', 6, 300.00, 'Observaciones de la reserva'),
('2023-07-26', '19:30', 006, 'Jorge Hernandez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-26', '20:00', 007, 'Carla Perez', 'P07', 'BB', 2, 60.00, 'Observaciones de la reserva'),
('2023-07-26', '20:00', 008, 'Miguel Rodriguez', 'P08', 'HB', 4, 120.00, 'Observaciones de la reserva'),
('2023-07-26', '20:15', 009, 'Sofia Gomez', 'P09', 'FB', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-26', '20:15', 010, 'Pablo Fernandez', 'P10', 'AI', 4, 240.00, 'Observaciones de la reserva'),
('2023-07-26', '20:30', 011, 'Laura Martinez', 'P11', 'SC', 2, 40.00, 'Observaciones de la reserva'),
('2023-07-26', '20:30', 012, 'Carlos Hernandez', 'P12', 'BB', 4, 80.00, 'Observaciones de la reserva'),


-- Reservas para el 27 de mayo de 2023
('2023-07-27', '19:00', 013, 'Ana Perez', 'P13', 'HB', 6, 180.00, 'Observaciones de la reserva'),
('2023-07-27', '19:00', 014, 'Juan Rodriguez', 'P14', 'FB', 4, 160.00, 'Observaciones de la reserva'),
('2023-07-27', '19:15', 015, 'Maria Gomez', 'P15', 'AI', 2, 100.00, 'Observaciones de la reserva'),
('2023-07-27', '19:15', 016, 'Pedro Fernandez', 'P16', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-27', '19:30', 017, 'Ana Martinez', 'P17', 'BB', 6, 120.00, 'Observaciones de la reserva'),
('2023-07-27', '19:30', 018, 'Juan Hernandez', 'P18', 'HB', 4, 150.00, 'Observaciones de la reserva'),
('2023-07-27', '20:00', 019, 'Maria Perez', 'P19', 'FB', 2, 80.00, 'Observaciones de la reserva'),
('2023-07-27', '20:00', 020, 'Pedro Rodriguez', 'P20', 'AI', 4, 200.00, 'Observaciones de la reserva'),
('2023-07-27', '20:15', 021, 'Ana Gomez', 'P21', 'SC', 6, 120.00, 'Observaciones de la reserva'),
('2023-07-27', '20:15', 022, 'Juan Fernandez', 'P22', 'BB', 4, 80.00, 'Observaciones de la reserva'),
('2023-07-27', '20:30', 023, 'Maria Martinez', '023', 'HB', 2, 60.00, 'Observaciones de la reserva'),
('2023-07-27', '20:30', 024, 'Pedro Hernandez', '124', 'FB', 4, 160.00, 'Observaciones de la reserva');

INSERT INTO reservations (fecha, hora, res_number, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations)
VALUES
  ('2023-07-26', '19:00', 1, 'JJ', '212', 'true', 2, 'AI', 2, 0, 'Primera reserva con bonus'),
  ('2023-07-27', '19:00', 1, 'JJ', '212', 'true', 2, 'AI', 2, 0, 'Segunda reserva con bonus');

$$;