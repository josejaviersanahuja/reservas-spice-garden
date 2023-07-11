import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { PureUser, UserPatchDTO } from './users.schema';
import { UsersPatchQueryBuilder } from './users.utils';
import { PostgresCrudService } from 'src/app.schema';

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

  async updateUser(id: number, dto: UserPatchDTO): Promise<PureUser> {
    const query = UsersPatchQueryBuilder(id, dto); // fix this and import
    const { rows } = await this.pg.query(query);
    const res: PostgresCrudService<PureUser> = rows[0].result;
    // console.log(res, 'DEBBUGING');

    if (res.isError) {
      if (!res.message) {
        throw new Error(res.stack);
      }
      throw new Error(res.message + ' ' + res.errorCode);
    }
    if (!res.result) {
      throw new NotFoundException('User not found');
    }
    return res.result;
  }
}
