-- cambia el nombre de la base de datos y añade _test
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO users (username, password) VALUES ('reception', 'Welcome123');
INSERT INTO users (username, password) VALUES ('cocina', 'Cocina123');
INSERT INTO users (username, password) VALUES ('maitre', 'Maitre123');
INSERT INTO users (username, password) VALUES ('direccion', 'Direccion123');
DROP TABLE IF EXISTS restaurant_themes;

CREATE TABLE restaurant_themes (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_deleted BOOLEAN DEFAULT FALSE
);

INSERT INTO restaurant_themes (name, description, image_url) VALUES
('Restaurante Mexicano', 'Restaurante de comida mexicana', ''),
('Restaurante Italiano', 'Restaurante de comida italiana', ''),
('Restaurante Hindú', 'Restaurante de comida hindú', '');

DROP TABLE IF EXISTS agenda;

CREATE TABLE agenda (
  date DATE NOT NULL DEFAULT CURRENT_DATE PRIMARY KEY,
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
  t2145 INTEGER NOT NULL DEFAULT 4
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
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  time TIME_OPTIONS_ENUM NOT NULL,
  res_number VARCHAR(20),
  name VARCHAR(100),
  room ROOM_OPTIONS_ENUM,
  meal_plan MEAL_PLAN_ENUM,
  pax_number INTEGER,
  cost NUMERIC(10,2),
  observations TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_deleted BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (date, time, res_number, name, room)
);

INSERT INTO agenda (date, restaurant_theme_id) VALUES 
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

INSERT INTO reservations (date, time, res_number, name, room, meal_plan, pax_number, cost, observations)
VALUES
  ('2023-05-01', '19:00', 'RES001', 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-01', '19:00', 'RES002', 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-01', '19:15', 'RES003', 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-01', '19:15', 'RES004', 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-01', '19:30', 'RES005', 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-01', '20:00', 'RES006', 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-01', '20:00', 'RES007', 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-01', '20:15', 'RES008', 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-01', '20:15', 'RES009', 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-01', '20:30', 'RES010', 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-01', '20:45', 'RES011', 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-01', '20:45', 'RES012', 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-01', '21:00', 'RES013', 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-01', '21:00', 'RES014', 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-01', '21:15', 'RES015', 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 2023-05-02
  ('2023-05-02', '19:00', 'RES016', 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-02', '19:00', 'RES017', 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-02', '19:15', 'RES018', 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-02', '19:15', 'RES019', 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-02', '19:30', 'RES020', 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-02', '20:00', 'RES021', 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-02', '20:00', 'RES022', 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-02', '20:15', 'RES023', 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-02', '20:15', 'RES024', 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-02', '20:30', 'RES025', 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-02', '20:45', 'RES026', 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-02', '20:45', 'RES027', 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-02', '21:00', 'RES028', 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-02', '21:00', 'RES029', 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-02', '21:15', 'RES030', 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 2023-05-03
  ('2023-05-03', '19:00', 'RES031', 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-03', '19:00', 'RES032', 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-03', '19:15', 'RES033', 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-03', '19:15', 'RES034', 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-03', '19:30', 'RES035', 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-03', '20:00', 'RES036', 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-03', '20:00', 'RES037', 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-03', '20:15', 'RES038', 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-03', '20:15', 'RES039', 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-03', '20:30', 'RES040', 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-03', '20:45', 'RES041', 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-03', '20:45', 'RES042', 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-03', '21:00', 'RES043', 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-03', '21:00', 'RES044', 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-03', '21:15', 'RES045', 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 04 de mayo
  ('2023-05-04', '19:00', 'RES046', 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-04', '19:00', 'RES047', 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-04', '19:15', 'RES048', 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-04', '19:15', 'RES049', 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-04', '19:30', 'RES050', 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-04', '20:00', 'RES051', 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-04', '20:00', 'RES052', 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-04', '20:15', 'RES053', 'Miguel Torres', 'P08', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-04', '20:15', 'RES054', 'Sofia Diaz', 'P09', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-04', '20:30', 'RES055', 'Jorge Ruiz', 'P10', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-04', '20:45', 'RES056', 'Pablo Castro', 'P11', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-04', '20:45', 'RES057', 'Isabel Lopez', 'P12', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-04', '21:00', 'RES058', 'Raul Fernandez', 'P13', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-04', '21:00', 'RES059', 'Carmen Perez', 'P14', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-04', '21:15', 'RES060', 'Antonio Garcia', 'P15', 'AI', 4, 150.00, 'Sin observaciones'),
  -- 05 de mayo
  ('2023-05-05', '19:00', 'RES061', 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-05', '19:00', 'RES062', 'Maria Rodriguez', 'P02', 'BB', 1, 30.00, 'Sin observaciones'),
  ('2023-05-05', '19:15', 'RES063', 'Pedro Gomez', 'P03', 'HB', 3, 90.00, 'Sin observaciones'),
  ('2023-05-05', '19:15', 'RES064', 'Ana Garcia', 'P04', 'FB', 2, 70.00, 'Sin observaciones'),
  ('2023-05-05', '19:30', 'RES065', 'Luisa Fernandez', 'P05', 'AI', 4, 150.00, 'Sin observaciones'),
  ('2023-05-05', '20:00', 'RES066', 'Carlos Sanchez', 'P06', 'SC', 2, 50.00, 'Sin observaciones'),
  ('2023-05-05', '20:00', 'RES067', 'Laura Martinez', 'P07', 'BB', 1, 30.00, 'Sin observaciones'),
  
-- Reservas para el 8 de mayo de 2023
('2023-05-08', '19:00', 'RES001', 'Juan Perez', 'P01', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-08', '19:00', 'RES002', 'Maria Rodriguez', 'P02', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-08', '19:15', 'RES003', 'Pedro Gomez', 'P03', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-08', '20:00', 'RES004', 'Ana Garcia', 'P04', 'FB', 4, 120.00, 'Observaciones de la reserva'),
('2023-05-08', '20:15', 'RES005', 'Luisa Fernandez', 'P05', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-08', '21:00', 'RES006', 'Carlos Sanchez', 'P06', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-08', '21:15', 'RES007', 'Sofia Martinez', 'P07', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 9 de mayo de 2023
('2023-05-09', '19:00', 'RES008', 'Juan Perez', 'P08', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-09', '19:00', 'RES009', 'Maria Rodriguez', 'P09', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-09', '19:15', 'RES010', 'Pedro Gomez', 'P10', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-09', '20:00', 'RES011', 'Ana Garcia', 'P11', 'FB', 4, 120.00, 'Observaciones de la reserva'),
('2023-05-09', '20:15', 'RES012', 'Luisa Fernandez', 'P12', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-09', '21:00', 'RES013', 'Carlos Sanchez', 'P13', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-09', '21:15', 'RES014', 'Sofia Martinez', 'P14', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 10 de mayo de 2023
('2023-05-10', '19:00', 'RES015', 'Juan Perez', 'P15', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-10', '19:00', 'RES016', 'Maria Rodriguez', 'P16', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-10', '19:30', 'RES017', 'Pedro Gomez', 'P17', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-10', '20:15', 'RES018', 'Luisa Fernandez', 'P18', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-10', '21:00', 'RES019', 'Carlos Sanchez', 'P19', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-10', '21:30', 'RES020', 'Sofia Martinez', 'P20', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 13 de mayo de 2023
('2023-05-13', '19:00', 'RES021', 'Juan Perez', 'P21', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-13', '19:00', 'RES022', 'Maria Rodriguez', 'P22', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-13', '19:30', 'RES023', 'Pedro Gomez', '023', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-13', '20:15', 'RES024', 'Luisa Fernandez', '124', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-13', '21:00', 'RES025', 'Carlos Sanchez', '225', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-13', '21:30', 'RES026', 'Sofia Martinez', '306', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 14 de mayo de 2023
('2023-05-14', '19:00', 'RES027', 'Juan Perez', '307', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-14', '19:00', 'RES028', 'Maria Rodriguez', '308', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-14', '19:30', 'RES029', 'Pedro Gomez', '309', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-14', '20:15', 'RES030', 'Luisa Fernandez', '212', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-14', '21:00', 'RES031', 'Carlos Sanchez', '212', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-14', '21:30', 'RES032', 'Sofia Martinez', '212', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 15 de mayo de 2023
('2023-05-15', '19:00', 'RES033', 'Juan Perez', '212', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-15', '19:00', 'RES034', 'Maria Rodriguez', '212', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-15', '19:30', 'RES035', 'Pedro Gomez', '212', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-15', '20:15', 'RES036', 'Luisa Fernandez', '212', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-15', '21:00', 'RES037', 'Carlos Sanchez', '212', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-15', '21:30', 'RES038', 'Sofia Martinez', '212', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 16 de mayo de 2023
('2023-05-16', '19:00', 'RES039', 'Juan Perez', '212', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-16', '19:00', 'RES040', 'Maria Rodriguez', '101', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-16', '19:30', 'RES041', 'Pedro Gomez', '101', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-16', '20:15', 'RES042', 'Luisa Fernandez', '101', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-16', '21:00', 'RES043', 'Carlos Sanchez', '101', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-16', '21:30', 'RES044', 'Sofia Martinez', '101', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 17 de mayo de 2023
('2023-05-17', '19:00', 'RES045', 'Juan Perez', '101', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-17', '19:00', 'RES046', 'Maria Rodriguez', '101', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-17', '19:30', 'RES047', 'Pedro Gomez', '101', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-17', '20:15', 'RES048', 'Luisa Fernandez', '101', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-17', '21:00', 'RES049', 'Carlos Sanchez', '101', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-17', '21:30', 'RES050', 'Sofia Martinez', '050', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 18 de mayo de 2023
('2023-05-18', '19:00', 'RES051', 'Juan Perez', '101', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-18', '19:00', 'RES052', 'Maria Rodriguez', '102', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-18', '19:30', 'RES053', 'Pedro Gomez', '103', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-18', '20:15', 'RES054', 'Luisa Fernandez', '104', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-18', '21:00', 'RES055', 'Carlos Sanchez', '105', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-18', '21:30', 'RES056', 'Sofia Martinez', '106', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 19 de mayo de 2023
('2023-05-19', '19:00', 'RES057', 'Juan Perez', '107', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-19', '19:00', 'RES058', 'Maria Rodriguez', '108', 'BB', 8, 80.00, 'Observaciones de la reserva'),
('2023-05-19', '19:30', 'RES059', 'Pedro Gomez', '109', 'HB', 6, 90.00, 'Observaciones de la reserva'),
('2023-05-19', '20:15', 'RES060', 'Luisa Fernandez', '110', 'AI', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-19', '21:00', 'RES061', 'Carlos Sanchez', '111', 'SC', 6, 60.00, 'Observaciones de la reserva'),
('2023-05-19', '21:30', 'RES062', 'Sofia Martinez', '112', 'BB', 4, 40.00, 'Observaciones de la reserva'),

-- Reservas para el 20 de mayo de 2023
('2023-05-20', '19:00', 'RES063', 'Juan Perez', '113', 'SC', 5, 50.00, 'Observaciones de la reserva'),
('2023-05-20', '19:00', 'RES064', 'Maria Rodriguez', '114', 'BB', 8, 80.00, 'Observaciones de la reserva'),

-- Reservas para el 22 de mayo de 2023
('2023-05-22', '19:00', 'R001', 'Juan Perez', 'P01', 'SC', 5, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '19:00', 'R002', 'Maria Rodriguez', 'P02', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '19:00', 'R003', 'Pedro Gomez', 'P03', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '19:00', 'R004', 'Ana Garcia', 'P04', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '19:00', 'R005', 'Luisa Fernandez', 'P05', 'AI', 10, 250.00, 'Observaciones de la reserva'),
('2023-05-22', '19:15', 'R006', 'Carlos Sanchez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-22', '19:15', 'R007', 'Sofia Hernandez', 'P07', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '19:15', 'R008', 'Jorge Ramirez', 'P08', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '19:15', 'R009', 'Laura Torres', 'P09', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '19:30', 'R010', 'Miguel Castro', 'P10', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-22', '19:30', 'R011', 'Fernanda Diaz', 'P11', 'SC', 3, 60.00, 'Observaciones de la reserva'),
('2023-05-22', '19:30', 'R012', 'Ricardo Martinez', 'P12', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '19:30', 'R013', 'Isabel Jimenez', 'P13', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '20:00', 'R014', 'Diego Vargas', 'P14', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '20:00', 'R015', 'Valentina Gutierrez', 'P15', 'AI', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '20:00', 'R016', 'Roberto Flores', 'P16', 'SC', 1, 20.00, 'Observaciones de la reserva'),
('2023-05-22', '20:00', 'R017', 'Carla Ortiz', 'P17', 'BB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '20:15', 'R018', 'Hector Aguilar', 'P18', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '20:15', 'R019', 'Paola Castro', 'P19', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '20:15', 'R020', 'Santiago Ramirez', 'P20', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-22', '20:15', 'R021', 'Daniela Torres', 'P21', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-22', '20:30', 'R022', 'Andres Hernandez', 'P22', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '20:30', 'R023', 'Camila Perez', '023', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '20:30', 'R024', 'Felipe Gomez', '124', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '20:30', 'R025', 'Lucia Garcia', '225', 'AI', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '20:45', 'R026', 'Gustavo Fernandez', '306', 'SC', 6, 120.00, 'Observaciones de la reserva'),
('2023-05-22', '20:45', 'R027', 'Natalia Rodriguez', '307', 'BB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '20:45', 'R028', 'Oscar Torres', '308', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '20:45', 'R029', 'Mariana Jimenez', '309', 'FB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '21:00', 'R030', 'Raul Martinez', '212', 'AI', 5, 125.00, 'Observaciones de la reserva'),
('2023-05-22', '21:00', 'R031', 'Carmen Jimenez', '212', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-22', '21:00', 'R032', 'Javier Ramirez', '212', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '21:00', 'R033', 'Lorena Gutierrez', '212', 'HB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '21:15', 'R034', 'Pablo Flores', '212', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '21:15', 'R035', 'Gabriela Ortiz', '212', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-22', '21:15', 'R036', 'Mauricio Aguilar', '212', 'SC', 2, 40.00, 'Observaciones de la reserva'),
('2023-05-22', '21:15', 'R037', 'Adriana Castro', '212', 'BB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '21:30', 'R038', 'Hugo Ramirez', '212', 'HB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '21:30', 'R039', 'Sara Torres', '212', 'FB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-22', '21:30', 'R040', 'Luis Garcia', '101', 'AI', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-22', '21:30', 'R041', 'Ana Fernandez', '101', 'SC', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-22', '21:45', 'R042', 'Jorge Perez', '101', 'BB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-22', '21:45', 'R043', 'Maria Rodriguez', '101', 'HB', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-22', '21:45', 'R044', 'Pedro Gomez', '101', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-22', '21:45', 'R045', 'Ana Garcia', '101', 'AI', 2, 50.00, 'Observaciones de la reserva'),

-- Reservas para el 23 de mayo de 2023
('2023-05-23', '19:00', 'R046', 'Juan Perez', 'P01', 'SC', 5, 100.00, 'Observaciones de la reserva'),
('2023-05-23', '19:00', 'R047', 'Maria Rodriguez', 'P02', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '19:00', 'R048', 'Pedro Gomez', 'P03', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-23', '19:00', 'R049', 'Ana Garcia', 'P04', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-23', '19:00', 'R050', 'Luisa Fernandez', 'P05', 'AI', 10, 250.00, 'Observaciones de la reserva'),
('2023-05-23', '19:15', 'R051', 'Carlos Sanchez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-23', '19:15', 'R052', 'Sofia Hernandez', 'P07', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '19:15', 'R053', 'Jorge Ramirez', 'P08', 'HB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-23', '19:15', 'R054', 'Laura Torres', 'P09', 'FB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-23', '19:30', 'R055', 'Miguel Castro', 'P10', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-23', '19:30', 'R056', 'Fernanda Diaz', 'P11', 'SC', 3, 60.00, 'Observaciones de la reserva'),
('2023-05-23', '19:30', 'R057', 'Ricardo Martinez', 'P12', 'BB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '19:30', 'R058', 'Isabel Jimenez', 'P13', 'HB', 1, 25.00, 'Observaciones de la reserva'),
('2023-05-23', '20:00', 'R059', 'Diego Vargas', 'P14', 'FB', 4, 100.00, 'Observaciones de la reserva'),
('2023-05-23', '20:00', 'R060', 'Valentina Gutierrez', 'P15', 'AI', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '20:00', 'R061', 'Roberto Flores', 'P16', 'SC', 1, 20.00, 'Observaciones de la reserva'),
('2023-05-23', '20:00', 'R062', 'Carla Ortiz', 'P17', 'BB', 0, 0.00, 'Observaciones de la reserva'),
('2023-05-23', '20:15', 'R063', 'Hector Aguilar', 'P18', 'HB', 2, 50.00, 'Observaciones de la reserva'),
('2023-05-23', '20:15', 'R064', 'Paola Castro', 'P19', 'FB', 3, 75.00, 'Observaciones de la reserva'),
('2023-05-23', '20:15', 'R065', 'Santiago Ramirez', 'P20', 'AI', 6, 150.00, 'Observaciones de la reserva'),
('2023-05-23', '20:15', 'R066', 'Daniela Torres', 'P21', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-23', '20:30', 'R067', 'Andres Hernandez', 'P22', 'BB', 2, 50.00, 'Observaciones de la reserva'),

-- Reservas para el 26 de mayo de 2023
('2023-05-26', '19:00', 'RES001', 'Juan Perez', 'P01', 'SC', 8, 100.00, 'Observaciones de la reserva'),
('2023-05-26', '19:00', 'RES002', 'Maria Rodriguez', 'P02', 'BB', 6, 120.00, 'Observaciones de la reserva'),
('2023-05-26', '19:15', 'RES003', 'Pedro Gomez', 'P03', 'HB', 4, 150.00, 'Observaciones de la reserva'),
('2023-05-26', '19:15', 'RES004', 'Ana Fernandez', 'P04', 'FB', 2, 200.00, 'Observaciones de la reserva'),
('2023-05-26', '19:30', 'RES005', 'Luisa Martinez', 'P05', 'AI', 6, 300.00, 'Observaciones de la reserva'),
('2023-05-26', '19:30', 'RES006', 'Jorge Hernandez', 'P06', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-26', '20:00', 'RES007', 'Carla Perez', 'P07', 'BB', 2, 60.00, 'Observaciones de la reserva'),
('2023-05-26', '20:00', 'RES008', 'Miguel Rodriguez', 'P08', 'HB', 4, 120.00, 'Observaciones de la reserva'),
('2023-05-26', '20:15', 'RES009', 'Sofia Gomez', 'P09', 'FB', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-26', '20:15', 'RES010', 'Pablo Fernandez', 'P10', 'AI', 4, 240.00, 'Observaciones de la reserva'),
('2023-05-26', '20:30', 'RES011', 'Laura Martinez', 'P11', 'SC', 2, 40.00, 'Observaciones de la reserva'),
('2023-05-26', '20:30', 'RES012', 'Carlos Hernandez', 'P12', 'BB', 4, 80.00, 'Observaciones de la reserva'),


-- Reservas para el 27 de mayo de 2023
('2023-05-27', '19:00', 'RES013', 'Ana Perez', 'P13', 'HB', 6, 180.00, 'Observaciones de la reserva'),
('2023-05-27', '19:00', 'RES014', 'Juan Rodriguez', 'P14', 'FB', 4, 160.00, 'Observaciones de la reserva'),
('2023-05-27', '19:15', 'RES015', 'Maria Gomez', 'P15', 'AI', 2, 100.00, 'Observaciones de la reserva'),
('2023-05-27', '19:15', 'RES016', 'Pedro Fernandez', 'P16', 'SC', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-27', '19:30', 'RES017', 'Ana Martinez', 'P17', 'BB', 6, 120.00, 'Observaciones de la reserva'),
('2023-05-27', '19:30', 'RES018', 'Juan Hernandez', 'P18', 'HB', 4, 150.00, 'Observaciones de la reserva'),
('2023-05-27', '20:00', 'RES019', 'Maria Perez', 'P19', 'FB', 2, 80.00, 'Observaciones de la reserva'),
('2023-05-27', '20:00', 'RES020', 'Pedro Rodriguez', 'P20', 'AI', 4, 200.00, 'Observaciones de la reserva'),
('2023-05-27', '20:15', 'RES021', 'Ana Gomez', 'P21', 'SC', 6, 120.00, 'Observaciones de la reserva'),
('2023-05-27', '20:15', 'RES022', 'Juan Fernandez', 'P22', 'BB', 4, 80.00, 'Observaciones de la reserva'),
('2023-05-27', '20:30', 'RES023', 'Maria Martinez', '023', 'HB', 2, 60.00, 'Observaciones de la reserva'),
('2023-05-27', '20:30', 'RES024', 'Pedro Hernandez', '124', 'FB', 4, 160.00, 'Observaciones de la reserva');

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
FOREIGN KEY (date)
REFERENCES agenda(date)
ON DELETE CASCADE
ON UPDATE CASCADE;
