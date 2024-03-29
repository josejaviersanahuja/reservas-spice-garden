import { Controller, Get, Param, Res } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { ReportsService } from './reports.service';
import { ValidateStringDatePipe } from '../../app.pipes';

@ApiTags('reports')
@Controller('reports')
export class ReportsController {
  constructor(private reportsService: ReportsService) {}

  @Get('today')
  async todaysReservationsReport(@Res() res: Response) {
    const buffer: Buffer = await this.reportsService.todayReservations();
    res.setHeader('Content-Type', 'application/vnd.openxmlformats');
    res.setHeader(
      'Content-Disposition',
      'attachment; filename=todayReservations.xlsx',
    );

    res.status(200).send(buffer);
  }

  @Get('statistics')
  async statisticsReport(
    @Param('fechaI', ValidateStringDatePipe) fechaI: string,
    @Param('fechaF', ValidateStringDatePipe) fechaF: string,
    @Res() res: Response,
  ) {
    const buffer: Buffer = await this.reportsService.createStatisticsExcel(
      fechaI,
      fechaF,
    );
    res.setHeader('Content-Type', 'application/vnd.openxmlformats');
    res.setHeader(
      'Content-Disposition',
      `attachment; filename=statistics-${fechaI.substring(
        0,
        10,
      )}-${fechaF.substring(0, 10)}.xlsx`,
    );
    res.status(200).send(buffer);
  }
}
