import { Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import configEnv from './config';
// import Pool from 'pg-pool';
// import { Client } from 'pg';

@Injectable()
export class AppService {
  constructor(
    @Inject(configEnv.KEY) private config: ConfigType<typeof configEnv>, // @Inject('pg') private pg: Pool<Client>,
  ) {}
  getHello() {
    const dbName = this.config.db.name;
    return 'Hello World! ' + dbName;
  }
}
