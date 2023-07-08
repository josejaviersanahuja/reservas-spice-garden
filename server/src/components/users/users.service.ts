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

  async updateUser(id: number, dto: UserUpdateDTO): Promise<User> {
  const query = UserUpdateQueryBuilder(id, dto);
  const { rows } = await this.pg.query(query);
  const res: PostgresCrudService<User> = rows[0].result;
  if (res.isError) {
    if (!res.result) {
      throw new NotFoundException('User not found');
    }
    if (!res.message) {
      throw new Error(res.stack);
    }
    throw new Error(res.message + ' ' + res.errorCode);
  }
  return res.result;
}

}
