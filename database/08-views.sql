
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
