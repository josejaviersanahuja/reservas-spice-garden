import {
  BadRequestException,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  Agenda,
  AgendaPatchDTO,
  AgendaPostDTO,
  Availability,
} from './agenda.schema';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { PostgresCrudService, TIME_OPTIONS } from '../../app.schema';
import { AgendaPatchQueryBuilder } from './agenda.util';

@Injectable()
export class AgendaService {
  constructor(@Inject('pg') private pg: Pool<Client>) {}

  async getAgendaInfo(date: string): Promise<Agenda> {
    const { rows } = await this.pg.query(
      `SELECT get_agenda_info('${date}') as result`,
    );
    const res: PostgresCrudService<Agenda> = rows[0].result;
    if (res.isError) {
      const mes = res.message ? res.message : res.stack;
      throw new Error(mes + ' ' + res.errorCode);
    }
    if (!res.result) {
      throw new NotFoundException();
    }
    return res.result;
  }

  async getAgendaAvailability(
    fecha: string,
    hora: TIME_OPTIONS,
  ): Promise<Availability> {
    const { rows } = await this.pg.query(
      `SELECT get_available_seats('${fecha}', '${hora}') as result`,
    );

    const res = rows[0].result;
    if (res === -102) {
      throw new Error('Problem in SUM function in reservations');
    }
    if (res === -101) {
      throw new Error('Problem in SELECT in agenda');
    }
    if (res === -100) {
      throw new NotFoundException(`No agenda found for ${fecha}`);
    }
    return {
      fecha,
      hora,
      availableSeats: res,
    };
  }

  async createAgenda(dto: AgendaPostDTO): Promise<Agenda> {
    const { rows } = await this.pg.query(
      `SELECT create_agenda('${dto.fecha}', ${dto.restaurantThemeId}) as result`,
    );
    const res: PostgresCrudService<Agenda> = rows[0].result;

    if (res.isError) {
      if (!res.message) {
        throw new Error(res.stack);
      }
      if (res.errorCode === 'P0001') {
        throw new BadRequestException(res.message);
      }
      throw new Error(res.message + ' ' + res.errorCode);
    }
    return res.result;
  }

  async updateAgenda(fecha: string, dto: AgendaPatchDTO): Promise<Agenda> {
    const query = AgendaPatchQueryBuilder(fecha, dto);
    const { rows } = await this.pg.query(query);
    const res: PostgresCrudService<Agenda> = rows[0].result;
    if (res.isError) {
      if (res.errorCode === 'P0001') {
        throw new BadRequestException(res.message);
      }
      if (!res.message) {
        throw new Error(res.stack);
      }
      throw new Error(res.message + ' ' + res.errorCode);
    }
    if (!res.result) {
      throw new NotFoundException('Agenda doesnt exist');
    }
    return res.result;
  }

  async getAgendasBetweenDates(fechaI: string, fechaF: string) {
    const { rows } = await this.pg.query(
      `SELECT get_agenda_info_between_dates('${fechaI}', '${fechaF}') as result`,
    );
    const res: PostgresCrudService<Agenda[]> = rows[0].result;
    if (res.isError) {
      if (!res.message) {
        throw new Error(res.stack);
      }
      throw new Error(res.message + ' ' + res.errorCode);
    }
    if (!res.result) {
      return [];
    }
    return res.result;
  }
}
