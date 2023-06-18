import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { ReservationsService } from './reservations.service';
import { ReservationPostDTO } from './reservations.schema';
import { ValidateStringDatePipe } from '../../app.pipes';

@Controller('reservations')
export class ReservationsController {
  constructor(private reservationService: ReservationsService) {}

  @Get()
  getReservations(
    @Query('fecha0', ValidateStringDatePipe) fecha0: string,
    @Query('fecha1', ValidateStringDatePipe) fecha1: string,
  ) {
    return this.reservationService.getReservationsBetweenDates(fecha0, fecha1);
  }

  @Get('/:fecha')
  async getReservationsByDate(
    @Param('fecha', ValidateStringDatePipe) fecha: string,
  ) {
    return this.reservationService.getReservationsByDate(fecha);
  }

  @Post()
  postReservation(@Body() dto: ReservationPostDTO) {
    return this.reservationService.createReservation(dto);
  }
}
