import { Controller, Get, Query } from '@nestjs/common';
import { ValidateStringDatePipe } from '../../app.pipes';
import { ApiTags } from '@nestjs/swagger';
import { StatisticsService } from './statistics.service';

@ApiTags('statistics')
@Controller('statistics')
export class StatisticsController {
  constructor(private statisticsService: StatisticsService) {}

  @Get('/byTheme') // @TODO service getAgendas con limit offset y fechas de acuerdo a los meses no se
  async getAgendas(
    @Query('fechaI', ValidateStringDatePipe) fechaI: string,
    @Query('fechaF', ValidateStringDatePipe) fechaF: string,
  ) {
    return this.statisticsService.getStatisticsByTheme(fechaI, fechaF);
  }
}
