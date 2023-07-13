import { Inject, Injectable } from '@nestjs/common';
import { Client } from 'pg';
import Pool from 'pg-pool';
import {
  StatsAssistants,
  StatsByDate,
  StatsByTheme,
} from './statistics.schema';
import { PostgresCrudService } from 'src/app.schema';

@Injectable()
export class StatisticsService {
  constructor(@Inject('pg') private pg: Pool<Client>) {}

  async getStatisticsByTheme(
    fechaI: string,
    fechaF: string,
  ): Promise<StatsByTheme[]> {
    const query = `SELECT * FROM get_percentage_per_theme('${fechaI}', '${fechaF}')`;
    const { rows } = await this.pg.query(query);

    return rows;
  }

  async getStatisticsAssistants(fecha: string) {
    const query = `SELECT * FROM get_assistants('${fecha}') as result`;
    const { rows } = await this.pg.query(query);
    const result: PostgresCrudService<StatsAssistants> = rows[0].result;

    if (result.isError) {
      if (result.message) {
        throw new Error(result.message + ' ' + result.errorCode);
      } else {
        throw new Error(result.stack);
      }
    }
    if (!result.result) {
      throw new Error('No result');
    }
    return result.result;
  }

  async getStatistics(fechaI: string, fechaF: string) {
    const query = `SELECT * FROM get_statistics('${fechaI}', '${fechaF}')`;
    const { rows } = await this.pg.query(query);
    return rows as StatsByDate[];
  }
}
