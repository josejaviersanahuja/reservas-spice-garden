# Documentación del Backend

A continuación se detallan los endpoints disponibles en el backend junto con su descripción, métodos, rutas y otros detalles relevantes.

## Crear una nueva reserva

- Método: POST
- Ruta: `/reservations`
- Descripción: Crea una nueva reserva en el restaurante.
- Parámetros de entrada: Datos de la reserva (fecha, hora, res_name, room, is_bonus, bonus_qty, meal_plan, pax_number, cost, observations).
- Respuesta: Código de estado y detalles de la reserva creada.
- SuccessCode: 201

## Obtener las reservas del spice garden hechas por el numero de reserva del hotel

- Método: GET
- Ruta: `/reservations/{res_number}`
- Descripción: Obtiene todas las reservas del restaurante hechas bajo la misma reserva del hotel.
- Parámetros de entrada: Número de reserva (res_number).
- Respuesta: Array de reservas hechas, potencialmente por el mismo cliente.
- SuccessCode: 200

## Obtener las reservas del spice garden por fechas

- Método: GET
- Ruta: `/reservations`
- QueryParams: `?fechaI={fecha_i}&fechaF={fecha_f}`
- Descripción: Obtiene todas las reservas del restaurante hechas en las fechas que se especifican en el query parameter.
- Parámetros de entrada: `fecha_i` (DATE), `fecha_f` (DATE | undefined).
- Respuesta: Array de reservas hechas, potencialmente por el mismo cliente.
- SuccessCode: 200

## Editar una reserva

- Método: PUT
- Ruta: `/reservations/{id}`
- Descripción: Edita una reserva existente.
- Parámetros de entrada: ID de reserva (id).
- Respuesta: Código de estado y nuevos datos.
- SuccessCode: 202

## Eliminar una reserva

- Método: DELETE
- Ruta: `/reservations/{id}`
- Descripción: Elimina una reserva existente.
- Parámetros de entrada: Número de reserva (id).
- Respuesta: Código de estado y mensaje de confirmación.
- StatusCode: 202, "deleted"

## Obtener disponibilidad de asientos

- Método: GET
- Ruta: `/availability`
- Descripción: Obtiene la disponibilidad de asientos para una fecha y hora específicas.
- Parámetros de entrada: Fecha (fecha) y hora (hora).
- Respuesta: Código de estado y número de asientos disponibles.

## Obtener estadísticas mensuales

- Método: GET
- Ruta: `/statistics`
- Descripción: Obtiene las estadísticas mensuales de reservas del restaurante.
- Parámetros de entrada: Ninguno.
- Respuesta: Código de estado y detalles de las estadísticas mensuales.

## Obtener porcentaje de reservas por tema

- Método: GET
- Ruta: `/statistics/bythemes`
- Descripción: Obtiene el porcentaje de reservas por tema de restaurante.
- Parámetros de entrada: Ninguno.
- Respuesta: Código de estado y detalles del porcentaje de reservas por tema.

## Obtener una agenda específica

- Método: GET
- Ruta: `/agendas/{fecha}`
- Descripción: Retorna la agenda de esa fecha.
- Respuesta exitosa (código 200).

## Crear una nueva agenda

- Método: POST
- Ruta: `/agendas`
- Descripción: Crea una nueva agenda.
- Cuerpo de la solicitud: JSON con la fecha y el ID del tema del restaurante.
- Respuesta exitosa (código 201).

## Actualizar una agenda existente

- Método: PUT o PATCH
- Ruta: `/agendas/{fecha}`
- Descripción: Actualiza los detalles de una agenda existente.
- Cuerpo de la solicitud: JSON con los nuevos valores de la agenda.
- Respuesta exitosa (código 200).

## Eliminar una agenda

- Método: DELETE
- Ruta: `/agendas/{fecha}`
- Descripción: Elimina una agenda existente.
- Respuesta exitosa (código 204).

## Endpoints para la entidad "restaurant_themes"

### Obtener todos los temas de restaurantes

- Método: GET
- Ruta: `/restaurant_themes`
- Descripción: Retorna todos los temas de restaurantes disponibles.
- Respuesta exitosa (código 200): JSON con la lista de temas de restaurantes.

### Obtener todos los temas posibles

- Método: GET
- Ruta: `/themes`
