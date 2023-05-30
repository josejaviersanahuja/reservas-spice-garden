@TODO functions views and more



INSERT
Método: POST
Ruta: /reservations
Descripción: Crea una nueva reserva en el restaurante.
Parámetros de entrada: Datos de la reserva (fecha, hora, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations).
Respuesta: Código de estado y detalles de la reserva creada.
SuccessCode: 201

```sql
SELECT * FROM insert_reservation(
  '2023-05-27',
  '19:00',
  1,
  'John Doe',
  '024',
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
```json
{
    "with_bonus": "SELECT * FROM get_bonus_reservations(res_number)",
    "payable": "SELECT * FROM get_payable_reservations(res_number)"
}
```

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
Ruta: /reservations/{id}
Descripción: Elimina una reserva existente.
Parámetros de entrada: Número de reserva (id).
Respuesta: Código de estado y mensaje de confirmación.
statusCode: 202, "deleted"
```sql
SELECT delete_reservation(226); -- 1,0,-1
```

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
