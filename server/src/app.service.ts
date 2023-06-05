import { Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import configEnv from './config';

@Injectable()
export class AppService {
  constructor(
    @Inject(configEnv.KEY) private config: ConfigType<typeof configEnv>,
  ) {}
  getHello(): string {
    const dbName = this.config.db.name;
    return 'Hello World! ' + dbName;
  }
}
