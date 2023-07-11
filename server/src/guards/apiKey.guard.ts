import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Observable } from 'rxjs';

import { Request } from 'express';

@Injectable()
export class ApiKeyGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest<Request>();

    const authHeader = request.header('apikey');
    const isApiKeyOk = authHeader === process.env.API_KEY;
    if (!isApiKeyOk) {
      throw new UnauthorizedException('Invalid API Key');
    }
    return isApiKeyOk;
  }
}
