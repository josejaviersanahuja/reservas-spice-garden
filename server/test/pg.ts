import { Pool } from 'pg';
const pgPool = new Pool({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  max: 40,
});

// quiero construir una funcion exportable que sea asincrona y ejecute lo siguiente: await pg.query('CALL seed()');
export const pg = {
  query: async (query: string) => {
    pgPool.connect();
    return pgPool.query(query);
  },
};
