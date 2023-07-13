/**
 * @fileoverview JwtAuthGuard class.
 * This file contains the JwtAuthGuard class which is responsible for
 * authenticating the user using the JWT strategy.
 * It was meant to be used as global guard, but it is working better than it should as is blocking the login page.
 * @deprecated
 */

import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Observable } from 'rxjs';

import { AuthGuard } from '@nestjs/passport';
import { JWT_STRATEGY } from 'src/config';

@Injectable()
export class JwtAuthGuard
  extends AuthGuard(JWT_STRATEGY)
  implements CanActivate
{
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    return super.canActivate(context);
  }
}
