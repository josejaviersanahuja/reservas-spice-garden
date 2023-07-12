import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { ConfigType } from '@nestjs/config';

import { AuthService } from './auth.service';
import { LocalStrategy } from './auth.local.strategy';
import { UsersModule } from './../users/users.module';
import { AuthController } from './auth.controller';
import config from '../../config';

@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.registerAsync({
      inject: [config.KEY],
      useFactory: (configService: ConfigType<typeof config>) => ({
        global: true,
        secret: configService.jwtSecret,
        signOptions: { expiresIn: '1d' },
      }),
    }),
  ],
  providers: [AuthService, LocalStrategy],
  controllers: [AuthController],
})
export class AuthModule {}
