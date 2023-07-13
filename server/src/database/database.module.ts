import { Module, Global } from '@nestjs/common';
import { ConfigModule, ConfigType } from '@nestjs/config';
import * as Pool from 'pg-pool';
import config, { ENVIROMENT_FILE } from '../config';
import { JwtModule } from '@nestjs/jwt';

@Global()
@Module({
  imports: [
    ConfigModule.forRoot({
      envFilePath: ENVIROMENT_FILE,
      load: [config],
      isGlobal: true,
    }),
    JwtModule.registerAsync({
      inject: [config.KEY],
      useFactory: (configService: ConfigType<typeof config>) => ({
        global: true,
        secret: configService.jwtSecret,
        signOptions: { expiresIn: '1d' },
      }),
    }),
  ],
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
    {
      provide: 'jwt',
      useFactory: async (configService: ConfigType<typeof config>) => {
        return {
          global: true,
          secret: configService.jwtSecret,
          signOptions: { expiresIn: '1d' },
        };
      },
      inject: [config.KEY],
    },
  ],
  exports: ['pg'],
})
export class DatabaseModule {}
