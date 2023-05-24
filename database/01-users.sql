DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO users (username, password) VALUES ('reception', 'Welcome123');
INSERT INTO users (username, password) VALUES ('cocina', 'Cocina123');
INSERT INTO users (username, password) VALUES ('maitre', 'Maitre123');
INSERT INTO users (username, password) VALUES ('direccion', 'Direccion123');
