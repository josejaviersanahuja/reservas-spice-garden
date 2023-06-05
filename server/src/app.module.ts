import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { AppController } from './app.controller';
import { AppService } from './app.service';
import configFile, { ENVIROMENT_FILE } from './config';
import { validate } from './env.validations';

@Module({
  imports: [
    ConfigModule.forRoot({
      envFilePath: ENVIROMENT_FILE,
      load: [configFile],
      isGlobal: true,
      validate,
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
