DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  user_password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  is_deleted BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO users (username, user_password) VALUES ('reception', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('cocina', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('maitre', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
INSERT INTO users (username, user_password) VALUES ('direccion', '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32');
