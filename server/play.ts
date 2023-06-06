import 'dotenv/config';
import { Client } from 'pg';

const pg = new Client({
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT, 10),
  database: process.env.DB_NAME,
});

pg.connect().then(() => {
  console.log('conectados');
  pg.query(
    `INSERT INTO reservations (fecha, hora, res_number, res_name, room, meal_plan, pax_number, cost, observations)
      VALUES
        ('2023-07-27', '21:00', 001, 'Juan Perez', 'P01', 'SC', 2, 50.00, 'Sin observaciones')`,
  ).then((result) => {
    console.log(result);
    pg.end().then(() => {
      console.log('desconectado');
    });
  });
});

/*
SELECT insert_reservation(
        '2023-07-27',
        '19:00',
        1,
        'John Doe',
        '024',
        FALSE,
        0,
        'HB',
        2,
        50.00,
        'No special instructions',
        FALSE
      ) AS new_reservation
*/
