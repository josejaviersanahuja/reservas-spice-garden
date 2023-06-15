import { IsBoolean, IsDate, IsEnum, IsNumber, IsString } from 'class-validator';
import { MEAL_PLAN, ROOM_OPTIONS, TIME_OPTIONS } from '../app.schema';

export class Reservation {
  @IsNumber()
  readonly id: number;
  @IsDate()
  readonly fecha: Date;
  @IsEnum(TIME_OPTIONS)
  readonly hora: TIME_OPTIONS;
  @IsNumber()
  readonly res_number: number;
  @IsString()
  readonly res_name: string;
  @IsString()
  readonly room: ROOM_OPTIONS;
  @IsBoolean()
  readonly is_bonus: boolean;
  @IsNumber()
  readonly bonus_qty: number;
  @IsEnum(MEAL_PLAN)
  readonly meal_plan: MEAL_PLAN;
  @IsNumber()
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
