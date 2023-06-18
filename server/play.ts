import 'dotenv/config';
import { Client } from 'pg';
import { PureAgenda } from 'src/components/agenda/agenda.schema';
import { PostgresCrudService } from 'src/app.schema';

const pg = new Client({
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT, 10),
  database: process.env.DB_NAME,
});

pg.connect().then(() => {
  console.log('conectados');
  pg.query(`SELECT get_agenda_info('2023-07-27') as result`).then((result) => {
    const res: PostgresCrudService<PureAgenda> = result.rows[0].result;
    console.log(res);
    pg.end().then(() => {
      console.log('desconectado');
    });
  });
});
