import {
  BadRequestException,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Agenda, AgendaPatchDTO, AgendaPostDTO } from './agenda.schema';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { PostgresCrudService } from '../../app.schema';
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
}
