import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { Agenda, AgendaPostDTO, PureAgenda } from './agenda.schema';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { PostgresCrudService } from '../../app.schema';

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

  async createAgenda(dto: AgendaPostDTO): Promise<PureAgenda> {
    const { rows } = await this.pg.query(
      `SELECT create_agenda('${dto.fecha}', ${dto.restaurant_theme_id}) as result`,
    );
    const res: PostgresCrudService<PureAgenda> = rows[0].result;
    if (res.isError) {
      if (!res.message) {
        throw new Error(res.stack);
      }
      throw new Error(res.message + ' ' + res.errorCode);
    }
    return res.result;
  }
}
