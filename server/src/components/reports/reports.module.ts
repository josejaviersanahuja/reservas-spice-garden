import { Module } from '@nestjs/common';

import { ReservationsModule } from './../reservations/reservations.module';
import { StatisticsModule } from '../statistics/statistics.module';
import { ReservationsService } from '../reservations/reservations.service';
import { StatisticsService } from '../statistics/statistics.service';
import { ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';

@Module({
  imports: [ReservationsModule, StatisticsModule],
  providers: [
    ReservationsService,
    StatisticsService,
    {
      provide: 'xl',
      useFactory: async () => {
        const xl = await import('excel4node');
        return xl;
      },
    },
    ReportsService,
  ],
  controllers: [ReportsController],
})
export class ReportsModule {}
