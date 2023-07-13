import { IsInt, IsJWT, IsString } from 'class-validator';
import { PureUser } from '../users/users.schema';

export class PayloadToken {
  @IsString()
  username: string;
  @IsInt()
  sub: number;
}

export class LoginResponse {
  @IsJWT()
  access_token: string;
  user: PureUser;
}
