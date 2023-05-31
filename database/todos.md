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
successCode: 200
```json
{
    "with_bonus": "SELECT * FROM get_bonus_reservations(res_number)",
    "payable": "SELECT * FROM get_payable_reservations(res_number)"
}
```
Obtener las reservas del spice garden by dates
Método: GET
Ruta: /reservations
QueryParams= ?fechaI={fecha_i}&fechaF={fecha_f}
Descripción: Obtiene Todas las reservas del restaurant hechas en las fechas que trae el query param.
Parámetros de entrada: fecha_i DATE, fecha_F DATE | undefined
Respuesta: Array de reservas hechas, potencialmente por el mismo cliente.
successCode: 200
```sql
SELECT * FROM get_reservations_between_dates(fecha_i, fecha_f)
SELECT * FROM get_reservations_between_dates(fecha_i)
-- puede recibir un solo parámetro para traer las fechas de un solo día.
```

Editar una reserva
Método: PUT
Ruta: /reservations/{id}
Descripción: Edita una reserva existente.
Parámetros de entrada: id de reserva (id).
Respuesta: Código de estado y nuevos datos.
successCode: 202


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
successCode: 200

```sql
SELECT get_available_seats('2023-05-27','19:30');
```

Método: GET
Ruta: /statistics
Descripción: Obtiene las estadísticas mensuales de reservas del restaurante.
Parámetros de entrada: Ninguno.
Respuesta: Código de estado y detalles de las estadísticas mensuales.
Obtener porcentaje de reservas por tema
successCode:200
```sql
SELECT get_statistics(fecha_i,fecha_f);
```

Método: GET
Ruta: /statistics/bythemes
Descripción: Obtiene el porcentaje de reservas por tema de restaurante.
Parámetros de entrada: Ninguno.
Respuesta: Código de estado y detalles del porcentaje de reservas por tema.
successCode:200
```sql
SELECT public.get_percentage_per_theme(
	<fecha_i date>, 
	<fecha_f date>
);
```

Obtener una agenda específica:
Método: GET
Ruta: /agendas/{fecha}
Descripción: Retorna la agenda de esa fecha.
Respuesta exitosa (código 200):

```sql
SELECT get_agenda_info('2023-05-27');
```

Crear una nueva agenda:
Método: POST
Ruta: /agendas
Descripción: Crea una nueva agenda.
Cuerpo de la solicitud:
```sql
SELECT create_agenda('2023-05-30', 3);
```
```json
{
  "fecha": "2023-05-30",
  "restaurant_theme_id": 2,
}
```
Respuesta exitosa (código 201):
```json
{
  "fecha": "2023-05-30",
  "restaurant_theme_id": 2,
  "t1900": 8,
  "t1915": 6,
  ...
}
```

Actualizar una agenda existente:
Método: PUT o PATCH (seguramente PATCH)
Ruta: /agendas/{fecha}
Descripción: Actualiza los detalles de una agenda existente.
Cuerpo de la solicitud:
```json
{
  "restaurant_theme_id": 3,
  "t1900": 12,
  "t1915": 10,
  ...
}
```
```sql
SELECT update_agenda('2023-05-30', 1);
SELECT update_agenda('2023-05-30', NULL, NULL, NULL, 5); -- esto va a modificar el valor de capacidad de t1930
```
Respuesta exitosa (código 200):
```json
{
  "fecha": "2023-05-29",
  "restaurant_theme_id": 3,
  "t1900": 12,
  "t1915": 10,
  ...
}
```

Eliminar una agenda:
Método: DELETE
Ruta: /agendas/{fecha}
Descripción: Elimina una agenda existente.
Respuesta exitosa (código 204)

```sql
SELECT delete_agenda('2023-05-27');
```

Endpoints para la entidad "restaurant_themes":
Obtener todos los temas de restaurantes:
Método: GET
Ruta: /restaurant_themes
Descripción: Retorna todos los temas de restaurantes disponibles.
Respuesta exitosa (código 200):

```sql
SELECT * FROM restaurant_themes_view;
```
