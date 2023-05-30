@TODO functions views and more

También parece estar mal planteada, parametros de entrada fecha_i, fecha_f
```sql
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
```

CREATE INDEX idx_reservations_res_number ON reservations (res_number);

INSERT
Método: POST
Ruta: /reservations
Descripción: Crea una nueva reserva en el restaurante.
Parámetros de entrada: Datos de la reserva (fecha, hora, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations).
Respuesta: Código de estado y detalles de la reserva creada.
SuccessCode: 201

```sql
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
```

Obtener las reservas del spice garden hechas por el numero de rserva del hotel
Método: GET
Ruta: /reservations/{res_number}
Descripción: Obtiene Todas las reservas del restaurant hechas bajo la misma reserva del hotel.
Parámetros de entrada: Número de reserva (res_number).
Respuesta: Array de reservas hechas, potencialmente por el mismo cliente.
```sql
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
```
{
    with_bonus: SELECT * FROM get_bonus_reservations(res_number),
    payable: SELECT * FROM get_payable_reservations(res_number)
}

Editar una reserva
Método: PUT
Ruta: /reservations/{id}
Descripción: Edita una reserva existente.
Parámetros de entrada: id de reserva (id).
Respuesta: Código de estado y nuevos datos.

```sql
CREATE OR REPLACE FUNCTION update_reservation(
  _id INTEGER,
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
  updated_reservation reservations;
BEGIN
  UPDATE reservations
  SET
    fecha = _fecha,
    hora = _hora,
    res_number = _res_number,
    res_name = _res_name,
    room = _room,
    is_bonus = _is_bonus,
    bonus_qty = _bonus_qty,
    meal_plan = _meal_plan,
    pax_number = _pax_number,
    cost = _cost,
    observations = _observations,
    is_noshow = _is_noshow
  WHERE id = _id
  RETURNING * INTO updated_reservation;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'El update falló en la base de datos.';
  END IF;

  RETURN updated_reservation;
END;
$$ LANGUAGE plpgsql;
```

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
