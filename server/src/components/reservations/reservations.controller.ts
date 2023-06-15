import { Controller, Get, Param, Query } from '@nestjs/common';

@Controller('reservations')
export class ReservationsController {
  // constructor() {}

  @Get()
  getReservations(
    @Query('fecha0') fecha0: string,
    @Query('fecha1') fecha1: string,
  ) {
    return `endpoint reservations entre las fechas ${fecha0} y ${fecha1}`;
  }

  @Get('/:fecha')
  getReservationsByDate(@Param('fecha') fecha: string) {
    return `endpoint reservation con fecha ${fecha}`;
  }

  @Get('dummy')
  getDummyReservations() {
    return '';
  }
}
