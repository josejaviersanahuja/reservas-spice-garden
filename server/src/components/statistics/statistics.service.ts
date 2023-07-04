import { Inject, Injectable } from '@nestjs/common';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { StatsByTheme } from './statistics.schema';

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
}
