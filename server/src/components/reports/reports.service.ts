import { Inject, Injectable } from '@nestjs/common';
import { ReservationsService } from '../reservations/reservations.service';
import { StatisticsService } from '../statistics/statistics.service';

import Excel4Node from '../../excel4node/excel4node.d';
import {
  generateStatisticsExcel,
  generateTodayReservationsExcel,
} from './reports.utils';
import { StatsByDate, StatsByTheme } from '../statistics/statistics.schema';

@Injectable()
export class ReportsService {
  constructor(
    private reservationsService: ReservationsService,
    private statisticsService: StatisticsService,
    @Inject('xl') private xl: typeof Excel4Node,
  ) {}
  async todayReservations() {
    const today = new Date();

    const { data } = await this.reservationsService.getReservationsByDate(
      today.toISOString(),
    );
    return await generateTodayReservationsExcel(new this.xl.Workbook(), data);
  }

  async createStatisticsExcel(fechaI: string, fechaF: string) {
    const statsByDate: StatsByDate[] =
      await this.statisticsService.getStatistics(fechaI, fechaF);
    const statsByTheme: StatsByTheme[] =
      await this.statisticsService.getStatisticsByTheme(fechaI, fechaF);

    const wb = new this.xl.Workbook();
    if (statsByDate.length === 0) {
      return await wb.writeToBuffer();
    }

    return await generateStatisticsExcel(wb, statsByDate, statsByTheme);
  }
}
