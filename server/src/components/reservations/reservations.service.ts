import {
  BadRequestException,
  Inject,
  Injectable,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import {
  AggReservation,
  AggregatedReservations,
  ReservationPatchDTO,
  ReservationPostDTO,
  SuggestedReservation,
} from './reservations.schema';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { PostgresCrudService } from '../../app.schema';
import { reservationPatchBuildQuery } from './reservations.util';

@Injectable()
export class ReservationsService {
  constructor(@Inject('pg') private pg: Pool<Client>) {}

  async getReservationsBetweenDates(
    dateI: string,
    dateF: string,
  ): Promise<{
    numAgendas: number;
    data: AggregatedReservations[];
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

  async getReservationsByResNumber(resNumber: number): Promise<{
    bonusRes: AggReservation[];
    payableRes: AggReservation[];
  }> {
    const { rows: bonusRows } = await this.pg.query(
      `SELECT * FROM get_bonus_reservations(${resNumber})`,
    );

    const bonusRes = bonusRows;

    const { rows: payableRows } = await this.pg.query(
      `SELECT * FROM get_payable_reservations(${resNumber})`,
    );
    const payableRes = payableRows;
    return {
      bonusRes,
      payableRes,
    };
  }

  async getSuggestionByResNumber(
    resNumber: number,
  ): Promise<SuggestedReservation> {
    const { rows } = await this.pg.query(
      `SELECT get_reservation_suggestion(${resNumber}) as result`,
    );
    const response: PostgresCrudService<SuggestedReservation> = rows[0].result;
    if (response.isError) {
      throw new Error(response.message + response.errorCode);
    }
    if (!response.isError && !response.result) {
      throw new NotFoundException(response.message);
    }
    return response.result;
  }

  async createReservation(dto: ReservationPostDTO): Promise<AggReservation> {
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
        '${fecha}',
        '${hora}',
        ${resNumber},
        '${resName}',
        '${room}',
        ${isBonus},
        '${bonusQty}',
        '${mealPlan}',
        '${paxNumber}',
        '${cost}',
        '${observations}',
        ${isNoshow}
      ) as result`,
    );
    const response: PostgresCrudService<AggReservation> = rows[0].result;

    if (response.isError) {
      throw new UnprocessableEntityException(response.message);
    }
    if (!response.isError && !response.result) {
      throw new BadRequestException(response.message);
    }
    return response.result;
  }

  async updateReservation(
    id: number,
    dto: ReservationPatchDTO,
  ): Promise<AggReservation> {
    const query = reservationPatchBuildQuery(id, dto);
    const { rows } = await this.pg.query(query);
    const response: PostgresCrudService<AggReservation> = rows[0].result;
    if (response.isError) {
      if (response.errorCode === 'P0001') {
        throw new BadRequestException(
          'The reservation you are trying to update is in the past',
        );
      }
      if (response.isError && !response.message) {
        throw new Error(response.stack);
      }
      throw new Error(response.message + response.errorCode);
    }
    if (!response.isError && !response.result) {
      throw new NotFoundException(response.message);
    }
    return response.result;
  }
}
