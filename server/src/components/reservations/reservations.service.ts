import {
  BadRequestException,
  Inject,
  Injectable,
  UnprocessableEntityException,
} from '@nestjs/common';
import {
  AggregatedReservations,
  Reservation,
  ReservationPostDTO,
} from './reservations.schema';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { PostgresCrudService } from '../app.schema';

@Injectable()
export class ReservationsService {
  constructor(@Inject('pg') private pg: Pool<Client>) {}

  async getReservationsBetweenDates(
    dateI: string,
    dateF: string,
  ): Promise<{
    numAgendas: number;
    data: Reservation[];
  }> {
    const { rowCount, rows } = await this.pg.query(
      `SELECT * FROM get_reservations_between_dates('${dateI}','${dateF}')`,
    );

    return {
      numAgendas: rowCount,
      data: rows,
    };
  }

  async getReservationsByDate(date: string): Promise<{
    numAgendas: number;
    data: AggregatedReservations[];
  }> {
    const { rowCount, rows } = await this.pg.query(
      `SELECT * FROM get_reservations_between_dates('${date}')`,
    );

    return {
      numAgendas: rowCount,
      data: rows,
    };
  }

  async createReservation(dto: ReservationPostDTO): Promise<Reservation> {
    const {
      fecha,
      hora,
      resNumber,
      resName,
      room,
      isBonus,
      bonusQty,
      mealPlan,
      paxNumber,
      cost,
      observations,
      isNoshow,
    } = dto;
    const { rows } = await this.pg.query(
      `SELECT insert_reservation(
        '${fecha}','${hora}',${resNumber},'${resName}','${room}',${isBonus}, '${bonusQty}', '${mealPlan}', '${paxNumber}', '${cost}', '${observations}', ${isNoshow}
      ) as result`,
    );
    const response: PostgresCrudService<Reservation> = rows[0].result;

    if (response.isError) {
      throw new UnprocessableEntityException(response.message);
    }
    if (!response.isError && !response.result) {
      throw new BadRequestException(response.message);
    }
    return response.result;
  }
}
