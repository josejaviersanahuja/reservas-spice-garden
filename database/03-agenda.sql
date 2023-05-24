DROP TABLE IF EXISTS agenda;

CREATE TABLE agenda (
  fecha DATE NOT NULL DEFAULT CURRENT_DATE,
  restaurant_theme_id INTEGER NOT NULL,
  PRIMARY KEY (fecha),
);
