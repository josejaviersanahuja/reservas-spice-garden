import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { AppController } from './app.controller';
import { AppService } from './app.service';
import configFile, { ENVIROMENT_FILE } from './config';
import { validate } from './env.validations';
import { DatabaseModule } from './database/database.module';
import { UsersModule } from './components/users/users.module';
import { RestaurantThemesModule } from './components/restaurant-themes/restaurant-themes.module';
import { AgendaModule } from './components/agenda/agenda.module';
import { ReservationsModule } from './components/reservations/reservations.module';
import { StatisticsModule } from './components/statistics/statistics.module';
import { AuthModule } from './components/auth/auth.module';
import { ReportsModule } from './components/reports/reports.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      envFilePath: ENVIROMENT_FILE,
      load: [configFile],
      isGlobal: true,
      validate,
    }),
    DatabaseModule,
    UsersModule,
    RestaurantThemesModule,
    AgendaModule,
    ReservationsModule,
    StatisticsModule,
    AuthModule,
    ReportsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
