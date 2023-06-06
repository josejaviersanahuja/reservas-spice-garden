import { Module, Global } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import * as Pool from 'pg-pool';

import config from 'src/config';

@Global()
@Module({
  providers: [
    {
      provide: 'pg',
      useFactory: async (configService: ConfigType<typeof config>) => {
        const pg = new Pool({
          user: configService.db.user,
          host: configService.db.host,
          database: configService.db.name,
          password: configService.db.pass,
          port: configService.db.port,
        });
        await pg.connect();
        return pg;
      },
      inject: [config.KEY],
    },
  ],
  exports: ['pg'],
})
export class DatabaseModule {}
