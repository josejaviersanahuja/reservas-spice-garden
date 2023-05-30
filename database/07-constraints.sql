
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
FOREIGN KEY (fecha)
REFERENCES agenda(fecha)
ON DELETE CASCADE
ON UPDATE CASCADE;

CREATE INDEX idx_reservations_res_number ON reservations (res_number);
