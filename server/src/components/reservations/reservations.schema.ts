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
import { MEAL_PLAN, ROOM_OPTIONS, TIME_OPTIONS } from '../../app.schema';

// helper class to refer differences between the two schemas
// when a reservation comes alone from db, it comes with Date type
// when a reservation comes from an aggregated query, it comes with string type
abstract class ReservationBase<T> {
  readonly id: number;
  readonly fecha: T;
  readonly hora: TIME_OPTIONS;
  readonly resNumber: number;
  readonly resName: string;
  readonly room: ROOM_OPTIONS;
  readonly isBonus: boolean;
  readonly bonusQty: number;
  readonly mealPlan: MEAL_PLAN;
  readonly paxNumber: number;
  readonly cost: number;
  readonly observations: string;
  readonly isNoshow: boolean;
  readonly createdAt: T;
  readonly updatedAt: T;
  readonly isDeleted: boolean;
}

export class Reservation extends ReservationBase<Date> {
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

// when a reservation comes from a http payload, it comes with string type
export class ReservationPostDTO {
  @IsDateString()
  readonly fecha: string;
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

class AggReservation extends ReservationBase<string> {
  @IsInt()
  @Min(1)
  @IsPositive()
  readonly id: number;
  @IsDateString()
  readonly fecha: string;
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
  @IsDateString()
  readonly createdAt: string;
  @IsDateString()
  readonly updatedAt: string;
  @IsBoolean()
  readonly isDeleted: boolean;
}
export class AggregatedReservations {
  @IsDate()
  fecha: Date;
  standard_reservations: AggReservation[] | null;
  no_show_reservations: AggReservation[] | null;
  cancelled_reservations: AggReservation[] | null;
  @IsString()
  theme_name: string;
}
