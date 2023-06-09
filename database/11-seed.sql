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