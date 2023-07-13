import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { ValidateStringDatePipe } from '../../app.pipes';
import { ApiTags } from '@nestjs/swagger';
import { StatisticsService } from './statistics.service';
import { JWT_STRATEGY } from '../../config';
import { AuthGuard } from '@nestjs/passport';

@ApiTags('statistics')
@UseGuards(AuthGuard(JWT_STRATEGY))
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

  @Get('/assistants/:fecha')
  async getAssistants(@Param('fecha', ValidateStringDatePipe) fecha: string) {
    return this.statisticsService.getStatisticsAssistants(fecha);
  }

  @Get()
  async getStatistics(
    @Query('fechaI', ValidateStringDatePipe) fechaI: string,
    @Query('fechaF', ValidateStringDatePipe) fechaF: string,
  ) {
    return this.statisticsService.getStatistics(fechaI, fechaF);
  }
}
