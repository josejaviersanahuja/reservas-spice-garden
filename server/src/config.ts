import { registerAs } from '@nestjs/config';

type ENVIROMENT_NAME = '.env' | '.prod.env' | '.stag.env';

function chooseEnvFile(): ENVIROMENT_NAME {
  switch (process.env.NODE_ENV) {
    case 'prod':
      return '.prod.env';
    case 'stag':
      return '.stag.env';
    default:
      return '.env';
  }
}

export const ENVIROMENT_FILE = chooseEnvFile();

export default registerAs('config', () => {
  return {
    db: {
      name: process.env.DB_NAME,
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT, 10),
      pass: process.env.DB_PASS,
      user: process.env.DB_USER,
    },
    apiKey: process.env.API_KEY,
  };
});
/*
const pg = new Pool({
      user: process.env.DB_USER,
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      password: process.env.DB_PASS,
      port: parseInt(process.env.DB_PORT, 10),
    });
    await pg.connect();
*/
