
-- DROP DATABASE IF EXISTS spice_garden;

-- CREATE DATABASE spice_garden;

-- \c spice_garden;
DROP TABLE IF EXISTS restaurant_themes;

CREATE TABLE restaurant_themes (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_deleted BOOLEAN DEFAULT FALSE
);

INSERT INTO restaurant_themes (name, description, image_url) VALUES
('Restaurante Mexicano', 'Restaurante de comida mexicana', ''),
('Restaurante Italiano', 'Restaurante de comida italiana', ''),
('Restaurante Hindú', 'Restaurante de comida hindú', '');
