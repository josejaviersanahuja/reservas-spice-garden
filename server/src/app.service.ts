import { Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import configEnv from './config';
import Pool from 'pg-pool';
import { Client } from 'pg';

@Injectable()
export class AppService {
  constructor(
    @Inject(configEnv.KEY) private config: ConfigType<typeof configEnv>,
    @Inject('pg') private pg: Pool<Client>,
  ) {}
  async getHello() {
    const dbName = this.config.db.name;
    const result = await this.pg.query(
      `SELECT insert_reservation(
        '2023-07-27',
        '19:00',
        1,
        'John Doe',
        '024',
        FALSE,
        0,
        'HB',
        2,
        50.00,
        'No special instructions',
        FALSE
      ) AS new_reservation`,
    );
    console.log(result.rows[0].new_reservation);

    const result2 = 'Hello World! ' + dbName;
    return result2;
  }
}
