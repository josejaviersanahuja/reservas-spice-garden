import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { PureUser } from './users.schema';

@Injectable()
export class UsersService {
  constructor(@Inject('pg') private pg: Pool<Client>) {}
  async getAllUsers() {
    const query = `SELECT * FROM users`;
    const { rows } = await this.pg.query(query);
    return rows as PureUser[];
  }

  async getUserById(id: number) {
    const query = `SELECT * FROM users WHERE id = ${id}`;
    const { rows } = await this.pg.query(query);

    if (rows.length === 0) {
      throw new NotFoundException(`User with id ${id} not found`);
    }
    return rows[0] as PureUser;
  }
}
