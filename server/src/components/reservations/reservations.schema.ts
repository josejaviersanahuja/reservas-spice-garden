import {
  IsBoolean,
  IsDate,
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsPositive,
  IsString,
  Min,
} from 'class-validator';
import { MEAL_PLAN, ROOM_OPTIONS, TIME_OPTIONS } from '../app.schema';

export class Reservation {
  @IsInt()
  @Min(1)
  @IsPositive()
  readonly id: number;
  @IsDate()
  readonly fecha: Date;
  @IsEnum(TIME_OPTIONS)
  readonly hora: TIME_OPTIONS;
  @IsInt()
  @Min(1)
  @IsPositive()
  readonly res_number: number;
  @IsString()
  @IsNotEmpty()
  readonly res_name: string;
  @IsString()
  readonly room: ROOM_OPTIONS;
  @IsBoolean()
  readonly is_bonus: boolean;
  @IsInt()
  @Min(0)
  @IsPositive({})
  readonly bonus_qty: number;
  @IsEnum(MEAL_PLAN)
  readonly meal_plan: MEAL_PLAN;
  @IsInt()
  @Min(1)
  readonly pax_number: number;
  @IsNumber()
  readonly cost: number;
  @IsString()
  readonly observations: string;
  @IsBoolean()
  readonly is_noshow: boolean;
  @IsDate()
  readonly created_at: Date;
  @IsDate()
  readonly updated_at: Date;
  @IsBoolean()
  readonly is_deleted: boolean;
}
