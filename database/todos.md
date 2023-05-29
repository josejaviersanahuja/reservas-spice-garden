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

