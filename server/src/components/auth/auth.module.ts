import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';

import { AuthService } from './auth.service';
// import { LocalStrategy } from './strategies/local.strategy';
// import { UsersModule } from './../users/users.module';

@Module({
  // imports: [UsersModule, PassportModule],
  imports: [PassportModule],
  // providers: [AuthService, LocalStrategy],
  providers: [AuthService],
})
export class AuthModule {}
