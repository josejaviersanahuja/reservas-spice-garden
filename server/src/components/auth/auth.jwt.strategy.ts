import { Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { JwtService } from '@nestjs/jwt';
import { ConfigType } from '@nestjs/config';

import config, { JWT_STRATEGY } from '../../config';
import { PayloadToken } from './auth.schema';
import { UsersService } from '../users/users.service';
import { PureUser } from '../users/users.schema';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, JWT_STRATEGY) {
  constructor(
    private userService: UsersService,
    private jwtService: JwtService,
    @Inject(config.KEY) configService: ConfigType<typeof config>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.jwtSecret,
    });
  }

  async validate(payload: PayloadToken): Promise<PureUser> {
    try {
      const user = await this.userService.getUserById(payload.sub);
      delete user.user_password;
      return user;
    } catch (error) {
      throw new UnauthorizedException(
        error.message ?? 'Bearer Token not valid',
      );
    }
  }
}
