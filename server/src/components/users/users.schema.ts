import {
  IsBoolean,
  IsDate,
  IsDateString,
  IsInt,
  IsNotEmpty,
  IsString,
  Min,
} from 'class-validator';

export class PureUser {
  @IsInt()
  @Min(1)
  id: number;
  @IsString()
  @IsNotEmpty()
  username: string;
  @IsString()
  @IsNotEmpty()
  user_password: string;
  @IsDate()
  created_at: Date;
  @IsDate()
  updated_at: Date;
  @IsBoolean()
  is_deleted: boolean;
}

export class User {
  @IsInt()
  @Min(1)
  id: number;
  @IsString()
  @IsNotEmpty()
  username: string;
  @IsString()
  @IsNotEmpty()
  user_password: string;
  @IsDateString()
  created_at: string;
  @IsDateString()
  updated_at: string;
  @IsBoolean()
  is_deleted: boolean;
}

export class UserPatchDTO {
  @IsString()
  @IsNotEmpty()
  username?: string;

  @IsString()
  @IsNotEmpty()
  user_password?: string;
}
