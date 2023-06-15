import { Injectable } from '@nestjs/common';
import { RESERVATIONS } from './reservations.dummy';

@Injectable()
export class ReservationsService {
  private reservations = RESERVATIONS;

  getReservations() {
    return this.reservations;
  }
}
