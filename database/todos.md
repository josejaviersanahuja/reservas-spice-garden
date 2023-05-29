@TODO functions views and more

CREATE OR REPLACE FUNCTION get_assistants(fecha_in DATE)
RETURNS TABLE (reserved INT, assistants INT) AS $$
DECLARE
    total_reserved INT;
    total_assistants INT;
BEGIN
    SELECT COUNT(*) INTO total_reserved
    FROM reservations
    WHERE fecha = fecha_in AND is_deleted = FALSE;

    SELECT COUNT(*) INTO total_assistants
    FROM reservations
    WHERE fecha = fecha_in AND is_noshow = FALSE AND is_deleted = FALSE;

    RETURN QUERY SELECT total_reserved, total_assistants;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM obtener_asistencia('2023-05-29');

-- trigers

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_updated_at
AFTER UPDATE ON tu_tabla
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

En el código anterior, reemplaza tu_tabla por el nombre de la tabla en la que deseas actualizar el campo updated_at. El trigger se ejecutará antes de una operación de actualización (BEFORE UPDATE) en cada fila (FOR EACH ROW) y llamará a la función update_updated_at(). Dentro de la función, asignamos el valor actual de la fecha y hora (NOW()) al campo updated_at de la fila actual (NEW). Finalmente, devolvemos NEW para que la actualización se realice correctamente.

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

SELECT
  agenda.fecha,
  ARRAY_AGG(standard_reservations.*) AS standard_reservations,
  ARRAY_AGG(no_show_reservations.*) AS no_show_reservations,
  ARRAY_AGG(cancelled_reservations.*) AS cancelled_reservations,
  restaurant_themes.theme_name AS theme_name -- quizás podamos usarlo así?
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
GROUP BY
  agenda.fecha;

CREATE OR REPLACE FUNCTION get_monthly_statistics()
RETURNS TABLE (fecha DATE, theme_name VARCHAR(255), reserved INT, assistants INT, total_cash NUMERIC(10, 2), total_bonus INT) AS $$
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
            COUNT(*) FILTER (WHERE is_bonus = TRUE) AS total_bonus
        FROM
            standard_reservations
        WHERE
            fecha = a.fecha
    ) s ON true
    LEFT JOIN LATERAL (
        SELECT
            COUNT(*) AS total_bonus
        FROM
            no_show_reservations
        WHERE
            fecha = a.fecha AND is_bonus = TRUE
    ) n ON true;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_percentage_per_theme()
RETURNS TABLE (theme_name VARCHAR(255), percentage FLOAT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.theme_name,
        (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER() AS percentage
    FROM
        standard_reservations s
    JOIN
        agenda a ON s.fecha = a.fecha
    JOIN
        restaurant_themes r ON a.restaurant_theme_id = r.id
    WHERE
        s.is_deleted = FALSE AND a.is_deleted = FALSE AND a.is_noshow = FALSE
    GROUP BY
        r.theme_name;

END;
$$ LANGUAGE plpgsql;

CREATE INDEX idx_reservations_res_number ON reservations (res_number);

UPSERT
Método: POST
Ruta: /reservations
Descripción: Crea una nueva reserva en el restaurante.
Parámetros de entrada: Datos de la reserva (fecha, hora, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations).
Respuesta: Código de estado y detalles de la reserva creada.
SuccessCode: 201

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
SELECT insert_reservation(
  '2023-05-30',
  '12:00',
  1,
  'John Doe',
  'S',
  FALSE,
  0,
  NULL,
  2,
  50.00,
  'No special instructions',
  FALSE
) AS new_reservation;

Obtener las reservas del spice garden hechas por el numero de rserva del hotel
Método: GET
Ruta: /reservations/{res_number}
Descripción: Obtiene Todas las reservas del restaurant hechas bajo la misma reserva del hotel.
Parámetros de entrada: Número de reserva (res_number).
Respuesta: Array de reservas hechas, potencialmente por el mismo cliente.
CREATE OR REPLACE FUNCTION get_payable_reservations(reservation_number INTEGER)
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
    AND reservations.is_bonus = FALSE 
    AND reservations.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql;

{
    with_bonus: SELECT * FROM get_bonus_reservations(res_number),
    payable: SELECT * FROM get_payable_reservations(res_number)
}

Eliminar una reserva
Método: DELETE
Ruta: /reservations/{res_number}
Descripción: Elimina una reserva existente.
Parámetros de entrada: Número de reserva (res_number).
Respuesta: Código de estado y mensaje de confirmación.
Obtener disponibilidad de asientos

Método: GET
Ruta: /availability
Descripción: Obtiene la disponibilidad de asientos para una fecha y hora específicas.
Parámetros de entrada: Fecha (fecha) y hora (hora).
Respuesta: Código de estado y número de asientos disponibles.
Obtener estadísticas mensuales

Método: GET
Ruta: /statistics/monthly
Descripción: Obtiene las estadísticas mensuales de reservas del restaurante.
Parámetros de entrada: Ninguno.
Respuesta: Código de estado y detalles de las estadísticas mensuales.
Obtener porcentaje de reservas por tema

Método: GET
Ruta: /statistics/themes
Descripción: Obtiene el porcentaje de reservas por tema de restaurante.
Parámetros de entrada: Ninguno.
Respuesta: Código de estado y detalles del porcentaje de reservas por tema.

Obtener todas las agendas:

Método: GET
Ruta: /agendas
Descripción: Retorna todas las agendas disponibles.
Respuesta exitosa (código 200):

Obtener una agenda específica:

Método: GET
Ruta: /agendas/{fecha}
Descripción: Retorna los detalles de una agenda específica.
Respuesta exitosa (código 200):

Crear una nueva agenda:

Método: POST
Ruta: /agendas
Descripción: Crea una nueva agenda.
Cuerpo de la solicitud:
json
Copy code
{
  "fecha": "2023-05-30",
  "restaurant_theme_id": 2,
  "t1900": 8,
  "t1915": 6,
  ...
}
Respuesta exitosa (código 201):
json
Copy code
{
  "fecha": "2023-05-30",
  "restaurant_theme_id": 2,
  "t1900": 8,
  "t1915": 6,
  ...
}

Actualizar una agenda existente:

Método: PUT
Ruta: /agendas/{fecha}
Descripción: Actualiza los detalles de una agenda existente.
Cuerpo de la solicitud:
json
Copy code
{
  "restaurant_theme_id": 3,
  "t1900": 12,
  "t1915": 10,
  ...
}
Respuesta exitosa (código 200):
json
Copy code
{
  "fecha": "2023-05-29",
  "restaurant_theme_id": 3,
  "t1900": 12,
  "t1915": 10,
  ...
}
Eliminar una agenda:

Método: DELETE
Ruta: /agendas/{fecha}
Descripción: Elimina una agenda existente.
Respuesta exitosa (código 204)
Endpoints para la entidad "restaurant_themes":
Obtener todos los temas de restaurantes:

Método: GET
Ruta: /restaurant_themes
Descripción: Retorna todos los temas de restaurantes disponibles.
Respuesta exitosa (código 200):
json
Copy code
{
  "restaurant_themes": [
    {
      "id": 1,
      "theme_name": "Restaurante Mexicano",
      "description": "Restaurante de comida mexicana",
      "image_url": ""
    },
    ...
  ]
}
Obtener un tema de restaurante específico:

Método: GET
Ruta
