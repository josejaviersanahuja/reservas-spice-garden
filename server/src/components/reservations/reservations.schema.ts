import {
  IsBoolean,
  IsDate,
  IsDateString,
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
  readonly resNumber: number;
  @IsString()
  @IsNotEmpty()
  readonly resName: string;
  @IsString()
  readonly room: ROOM_OPTIONS;
  @IsBoolean()
  readonly isBonus: boolean;
  @IsInt()
  @Min(0)
  readonly bonusQty: number;
  @IsEnum(MEAL_PLAN)
  readonly mealPlan: MEAL_PLAN;
  @IsInt()
  @Min(1)
  readonly paxNumber: number;
  @IsNumber()
  readonly cost: number;
  @IsString()
  readonly observations: string;
  @IsBoolean()
  readonly isNoshow: boolean;
  @IsDate()
  readonly createdAt: Date;
  @IsDate()
  readonly updatedAt: Date;
  @IsBoolean()
  readonly isDeleted: boolean;
}

export class ReservationPostDTO {
  @IsDateString()
  readonly fecha: Date;
  @IsEnum(TIME_OPTIONS)
  readonly hora: TIME_OPTIONS;
  @IsInt()
  @Min(1)
  @IsPositive()
  readonly resNumber: number;
  @IsString()
  @IsNotEmpty()
  readonly resName: string;
  @IsString()
  readonly room: ROOM_OPTIONS;
  @IsBoolean()
  readonly isBonus: boolean;
  @IsInt()
  @Min(0)
  readonly bonusQty: number;
  @IsEnum(MEAL_PLAN)
  readonly mealPlan: MEAL_PLAN;
  @IsInt()
  @Min(1)
  readonly paxNumber: number;
  @IsNumber()
  readonly cost: number;
  @IsString()
  readonly observations: string;
  @IsBoolean()
  readonly isNoshow: boolean;
}
