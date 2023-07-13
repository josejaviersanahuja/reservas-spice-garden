import { Inject, Injectable } from '@nestjs/common';
import { Client } from 'pg';
import Pool from 'pg-pool';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { PureUser } from '../users/users.schema';
import { LoginResponse, PayloadToken } from './auth.schema';

@Injectable()
export class AuthService {
  constructor(
    @Inject('pg') private pg: Pool<Client>,
    private jwtService: JwtService,
  ) {}

  async validateUser(
    username: string,
    password: string,
  ): Promise<PureUser | null> {
    const { rows } = await this.pg.query(
      `SELECT * FROM users WHERE username = '${username}' LIMIT 1`,
    );
    if (rows.length === 0) {
      return null;
    }
    const user = rows[0] as PureUser;
    const isValid = await bcrypt.compare(password, user.user_password);
    if (!isValid) {
      return null;
    }
    return user;
  }

  async login(user: PureUser): Promise<LoginResponse> {
    const payload: PayloadToken = { username: user.username, sub: user.id };
    return {
      access_token: await this.jwtService.signAsync(payload),
      user,
    };
  }
}
