
-- FUNCTIONS TRIGGERS

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_reservation_bonus() 
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_bonus = TRUE THEN
    NEW.meal_plan = 'AI';
    NEW.cost = 0;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGERS

CREATE TRIGGER update_reservation_bonus_trigger
BEFORE UPDATE ON reservations
FOR EACH ROW
WHEN (OLD.is_bonus <> NEW.is_bonus AND NEW.is_bonus = TRUE)
EXECUTE FUNCTION update_reservation_bonus();

CREATE OR REPLACE TRIGGER trigger_updated_at_agenda
BEFORE UPDATE ON agenda
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE OR REPLACE TRIGGER trigger_updated_at_reservations
BEFORE UPDATE ON reservations
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at();

CREATE OR REPLACE TRIGGER trigger_updated_at_users
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE OR REPLACE TRIGGER trigger_updated_at_restaurant_themes
BEFORE UPDATE ON restaurant_themes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
