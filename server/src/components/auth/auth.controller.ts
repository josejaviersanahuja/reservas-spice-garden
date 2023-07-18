import { Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { Request } from 'express';
import { AuthService } from './auth.service';
import { JWT_STRATEGY, LOCAL_STRATEGY } from '../../config';
import { PureUser } from '../users/users.schema';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  @UseGuards(AuthGuard(LOCAL_STRATEGY))
  login(@Req() req: Request) {
    const user: PureUser = req.user as PureUser;

    return this.authService.login(user);
  }

  @Get('login')
  @UseGuards(AuthGuard(JWT_STRATEGY))
  loginWithToken(@Req() req: Request) {
    const user: PureUser = req.user as PureUser;
    return user;
  }
}
