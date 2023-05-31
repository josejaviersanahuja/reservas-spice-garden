# Documentación del Backend

A continuación se detallan los endpoints disponibles en el backend junto con su descripción, métodos, rutas y otros detalles relevantes.

## Crear una nueva reserva

- Método: POST
- Ruta: `/reservations`
- Descripción: Crea una nueva reserva en el restaurante.
- Parámetros de entrada: Datos de la reserva (fecha, hora, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations).
- Respuesta: Código de estado y detalles de la reserva creada.
- SuccessCode: 201
- DB Function: 
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

## Obtener las reservas del spice garden hechas por el numero de reserva del hotel

- Método: GET
- Ruta: `/reservations/{res_number}`
- Descripción: Obtiene todas las reservas del restaurante hechas bajo la misma reserva del hotel.
- Parámetros de entrada: Número de reserva (res_number).
- Respuesta: Array de reservas hechas, potencialmente por el mismo cliente.
- SuccessCode: 200
- DB Function: 
```json
{
    "with_bonus": "SELECT * FROM get_bonus_reservations(res_number)",
    "payable": "SELECT * FROM get_payable_reservations(res_number)"
}
```

## Obtener las reservas del spice garden por fechas

- Método: GET
- Ruta: `/reservations`
- QueryParams: `?fechaI={fecha_i}&fechaF={fecha_f}`
- Descripción: Obtiene todas las reservas del restaurante hechas en las fechas que se especifican en el query parameter.
- Parámetros de entrada: `fecha_i` (DATE), `fecha_f` (DATE | undefined).
- Respuesta: Array de reservas hechas, potencialmente por el mismo cliente.
- SuccessCode: 200
- DB Function:
```sql
SELECT * FROM get_reservations_between_dates(fecha_i, fecha_f)
SELECT * FROM get_reservations_between_dates(fecha_i)
-- puede recibir un solo parámetro para traer las fechas de un solo día.
```

## Editar una reserva

- Método: PUT
- Ruta: `/reservations/{id}`
- Descripción: Edita una reserva existente.
- Parámetros de entrada: ID de reserva (id).
- Respuesta: Código de estado y nuevos datos.
- SuccessCode: 202
- DB Function
```sql
SELECT * FROM update_reservation(15, NULL, NULL, NULL, NULL, NULL, TRUE);
-- id, fecha, hora, res_number, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations, is_noshow
```

## Eliminar una reserva

- Método: DELETE
- Ruta: `/reservations/{id}`
- Descripción: Elimina una reserva existente.
- Parámetros de entrada: Número de reserva (id).
- Respuesta: Código de estado y mensaje de confirmación.
- StatusCode: 202, "deleted"
- DB Function:
```sql
SELECT delete_reservation(226); -- 1,0,-1
```

## Obtener disponibilidad de asientos

- Método: GET
- Ruta: `/availability`
- Descripción: Obtiene la disponibilidad de asientos para una fecha y hora específicas.
- Parámetros de entrada: Fecha (fecha) y hora (hora).
- Respuesta: Código de estado y número de asientos disponibles.
- StatusCode: 200
- DB Function:
```sql
SELECT get_available_seats('2023-05-27','19:30');
```

## Obtener estadísticas mensuales

- Método: GET
- Ruta: `/statistics`
- Descripción: Obtiene las estadísticas mensuales de reservas del restaurante.
- Parámetros de entrada: Ninguno.
- Respuesta: Código de estado y detalles de las estadísticas mensuales.
- StatusCode: 200
- DB Function:
```sql
SELECT get_statistics(fecha_i,fecha_f);
```

## Obtener porcentaje de reservas por tema

- Método: GET
- Ruta: `/statistics/bythemes`
- Descripción: Obtiene el porcentaje de reservas por tema de restaurante.
- Parámetros de entrada: Ninguno.
- Respuesta: Código de estado y detalles del porcentaje de reservas por tema.
- StatusCode: 200
- DB Function:
```sql
SELECT public.get_percentage_per_theme(<fecha_i date>, <fecha_f date>);
```

## Obtener una agenda específica

- Método: GET
- Ruta: `/agendas/{fecha}`
- Descripción: Retorna la agenda de esa fecha.
- Respuesta exitosa (código 200).
- StatusCode: 200
- DB Function:
```sql
SELECT get_agenda_info('2023-05-27');
```

## Crear una nueva agenda

- Método: POST
- Ruta: `/agendas`
- Descripción: Crea una nueva agenda.
- Cuerpo de la solicitud: JSON con la fecha y el ID del tema del restaurante.
- Respuesta exitosa (código 201).
- StatusCode: 201
- DB Function:
```sql
SELECT create_agenda('2023-05-30', 3);
```

## Actualizar una agenda existente

- Método: PATCH
- Ruta: `/agendas/{fecha}`
- Descripción: Actualiza los detalles de una agenda existente.
- Cuerpo de la solicitud: JSON con los nuevos valores de la agenda.
- Respuesta exitosa (código 202).
- StatusCode: 202
- DB Function:
```sql
SELECT update_agenda('2023-05-30', NULL, NULL, NULL, 5);
-- esto va a modificar el valor de capacidad de t1930
-- a partir del segundo campo todos son opcionales.
-- fecha, restaurant_theme_id, t1900, ... ,t2145
```
- req.body:
```json
{
  "restaurant_theme_id": 3,
  "t1900": 12,
  "t1915": 10,
  ...
}
``` 

## Eliminar una agenda

- Método: DELETE
- Ruta: `/agendas/{fecha}`
- Descripción: Elimina una agenda existente.
- Respuesta exitosa (código 202).
- StatusCode: 202
- DB Function:
```sql
SELECT delete_agenda('2023-05-27');
```

## Obtener todos los temas de restaurantes

- Método: GET
- Ruta: `/restaurant_themes`
- Descripción: Retorna todos los temas de restaurantes disponibles.
- Respuesta exitosa (código 200): JSON con la lista de temas de restaurantes.
- StatusCode: 200
- DB Function:
```sql
SELECT * FROM restaurant_themes_view;
```
## Crear un nuevo tema de restaurante

- Método: POST
- Ruta: `/restaurant_themes`
- Descripción: Retorna el nuevo tema creado
- Respuesta exitosa (código 201): JSON con el nuevo tema.
- StatusCode: 201
- DB Function:
```sql
SELECT create_restaurant_theme('colombiano', 'bandeja paisa');
-- tercer campo opcional image url
```

## Editar un tema de restaurante

- Método: PATCH
- Ruta: `/restaurant_themes`
- Descripción: Retorna el nuevo tema creado
- Respuesta exitosa (código 202): JSON con el nuevo tema.
- StatusCode: 202
- DB Function:
```sql
SELECT update_restaurant_theme(5, 'borrar y no usar');
-- 2do, 3er y 4to campos opcionales, pasar NULL si no existen
```

## Eliminar un tema de restaurante

- Método: DELETE
- Ruta: `/restaurant_themes`
- Descripción: Retorna el nuevo tema creado
- Respuesta exitosa (código 202): JSON con el nuevo tema.
- StatusCode: 202
- DB Function:
```sql
SELECT delete_restaurant_theme(5);
```
