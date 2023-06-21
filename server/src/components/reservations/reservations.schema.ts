import {
  IsBoolean,
  IsDate,
  IsDateString,
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsPositive,
  IsString,
  Min,
} from 'class-validator';
import { MEAL_PLAN, ROOM_OPTIONS, TIME_OPTIONS } from '../../app.schema';
import { ApiProperty } from '@nestjs/swagger';

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

// no se está usando ente schema
/* export class Reservation extends ReservationBase<Date> {
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
*/
// when a reservation comes from a http payload, it comes with string type
export class ReservationPostDTO {
  @ApiProperty({
    description: 'Date of the reservation and cant be in the past',
    example: '2021-01-01',
    type: String,
    format: 'yyyy-mm-dd',
  })
  @IsDateString()
  readonly fecha: string;
  @ApiProperty({
    description: 'Time of the reservation',
    example: '19:00',
    enum: TIME_OPTIONS,
  })
  @IsEnum(TIME_OPTIONS)
  readonly hora: TIME_OPTIONS;
  @ApiProperty({
    description: 'Reservation number',
    example: 65345,
    type: Number,
    minimum: 1,
  })
  @IsInt()
  @Min(1)
  @IsPositive()
  readonly resNumber: number;
  @ApiProperty({
    description: 'Reservation name',
    example: 'John Doe',
    type: String,
  })
  @IsString()
  @IsNotEmpty()
  readonly resName: string;
  @ApiProperty({
    description: 'Room Number',
    example: 'P22',
    enum: ROOM_OPTIONS,
  })
  @IsEnum(ROOM_OPTIONS)
  readonly room: ROOM_OPTIONS;
  @ApiProperty({
    description: 'Is this a reservation included in AI?',
    example: false,
    type: Boolean,
  })
  @IsBoolean()
  readonly isBonus: boolean;
  @ApiProperty({
    description: 'How many dinners has included as part of the AI?',
    example: 2,
    type: Number,
    minimum: 0,
  })
  @IsInt()
  @Min(0)
  readonly bonusQty: number;
  @ApiProperty({
    description: 'Meal Plan',
    example: 'BB',
    enum: MEAL_PLAN,
  })
  @IsEnum(MEAL_PLAN)
  readonly mealPlan: MEAL_PLAN;
  @ApiProperty({
    description: 'How many people are included in this reservation?',
    example: 2,
    type: Number,
    minimum: 1,
  })
  @IsInt()
  @Min(1)
  readonly paxNumber: number;
  @ApiProperty({
    description: 'Cost of the reservation',
    example: 8,
    type: Number,
  })
  @IsNumber()
  readonly cost: number;
  @ApiProperty({
    description: 'Observations',
    example: 'This is a test',
    type: String,
  })
  @IsString()
  readonly observations: string;
  @ApiProperty({
    description: 'Is this a no show reservation?',
    example: false,
    type: Boolean,
  })
  @IsBoolean()
  readonly isNoshow: boolean;
}

export class ReservationPatchDTO {
  @IsDateString()
  @IsOptional()
  readonly fecha?: string;
  @IsEnum(TIME_OPTIONS)
  @IsOptional()
  readonly hora?: TIME_OPTIONS;
  @IsInt()
  @Min(1)
  @IsPositive()
  @IsOptional()
  readonly resNumber?: number;
  @IsString()
  @IsNotEmpty()
  @IsOptional()
  readonly resName?: string;
  @IsEnum(ROOM_OPTIONS)
  @IsOptional()
  readonly room?: ROOM_OPTIONS;
  @IsBoolean()
  @IsOptional()
  readonly isBonus?: boolean;
  @IsInt()
  @Min(0)
  @IsOptional()
  readonly bonusQty?: number;
  @IsEnum(MEAL_PLAN)
  @IsOptional()
  readonly mealPlan?: MEAL_PLAN;
  @IsInt()
  @Min(1)
  @IsOptional()
  readonly paxNumber?: number;
  @IsNumber()
  @IsOptional()
  readonly cost?: number;
  @IsString()
  @IsOptional()
  readonly observations?: string;
  @IsBoolean()
  @IsOptional()
  readonly isNoshow?: boolean;
}

export class AggReservation extends ReservationBase<string> {
  @ApiProperty({
    description: 'Reservation ID',
    example: 1,
    type: Number,
    minimum: 1,
  })
  @IsInt()
  @Min(1)
  @IsPositive()
  readonly id: number;
  @ApiProperty({
    description: 'Date of the reservation and cant be in the past',
    example: '2021-01-01T00:00:00.000Z',
    type: String,
    format: 'yyyy-mm-ddThh:mm:ss.sssZ',
  })
  @IsDateString()
  readonly fecha: string;
  @ApiProperty({
    description: 'Time of the reservation',
    example: '19:00',
    enum: TIME_OPTIONS,
  })
  @IsEnum(TIME_OPTIONS)
  readonly hora: TIME_OPTIONS;
  @ApiProperty({
    description: 'Reservation number',
    example: 65345,
    type: Number,
    minimum: 1,
  })
  @IsInt()
  @Min(1)
  @IsPositive()
  readonly res_number: number;
  @ApiProperty({
    description: 'Reservation name',
    example: 'John Doe',
    type: String,
  })
  @IsString()
  @IsNotEmpty()
  readonly res_name: string;
  @ApiProperty({
    description: 'Room Number',
    example: 'P22',
    enum: ROOM_OPTIONS,
  })
  @IsEnum(ROOM_OPTIONS)
  readonly room: ROOM_OPTIONS;
  @ApiProperty({
    description: 'Is this a reservation included in AI?',
    example: false,
    type: Boolean,
  })
  @IsBoolean()
  readonly is_bonus: boolean;
  @ApiProperty({
    description: 'How many dinners has included as part of the AI?',
    example: 2,
    type: Number,
    minimum: 0,
  })
  @IsInt()
  @Min(0)
  readonly bonus_qty: number;
  @ApiProperty({
    description: 'Meal Plan',
    example: 'BB',
    enum: MEAL_PLAN,
  })
  @IsEnum(MEAL_PLAN)
  readonly meal_plan: MEAL_PLAN;
  @ApiProperty({
    description: 'How many people are included in this reservation?',
    example: 2,
    type: Number,
    minimum: 1,
  })
  @IsInt()
  @Min(1)
  readonly pax_number: number;
  @ApiProperty({
    description: 'Cost of the reservation',
    example: 8,
    type: Number,
  })
  @IsNumber()
  readonly cost: number;
  @ApiProperty({
    description: 'Observations',
    example: 'This is a test',
    type: String,
  })
  @IsString()
  readonly observations: string;
  @ApiProperty({
    description: 'Is this a no show reservation?',
    example: false,
    type: Boolean,
  })
  @IsBoolean()
  readonly is_noshow: boolean;
  @ApiProperty({
    description: 'Date of creation',
    example: '2021-01-01T00:00:00.000Z',
    type: String,
    format: 'yyyy-mm-ddThh:mm:ss.sssZ',
  })
  @IsDateString()
  readonly created_at: string;
  @ApiProperty({
    description: 'Date of last update',
    example: '2021-01-01T00:00:00.000Z',
    type: String,
    format: 'yyyy-mm-ddThh:mm:ss.sssZ',
  })
  @IsDateString()
  readonly updated_at: string;
  @ApiProperty({
    description: 'Is this a cancelled reservation?',
    example: false,
    type: Boolean,
  })
  @IsBoolean()
  readonly is_deleted: boolean;
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
