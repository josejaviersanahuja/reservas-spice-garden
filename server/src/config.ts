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
      port: process.env.DB_PORT,
      pass: process.env.DB_PASS,
    },
  };
});
