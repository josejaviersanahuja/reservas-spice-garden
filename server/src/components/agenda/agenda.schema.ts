// import { ApiProperty } from '@nestjs/swagger';
import {
  IsBoolean,
  IsDate,
  IsDateString,
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';
import { TIME_OPTIONS } from '../../app.schema';

export class PureAgenda {
  @IsDate()
  readonly fecha: Date;
  @IsInt()
  @Min(1)
  readonly restaurant_theme_id: number;
  @IsInt()
  @Min(0)
  readonly t1900: number;
  @IsInt()
  @Min(0)
  readonly t1915: number;
  @IsInt()
  @Min(0)
  readonly t1930: number;
  @IsInt()
  @Min(0)
  readonly t1945: number;
  @IsInt()
  @Min(0)
  readonly t2000: number;
  @IsInt()
  @Min(0)
  readonly t2015: number;
  @IsInt()
  @Min(0)
  readonly t2030: number;
  @IsInt()
  @Min(0)
  readonly t2045: number;
  @IsInt()
  @Min(0)
  readonly t2100: number;
  @IsInt()
  @Min(0)
  readonly t2115: number;
  @IsInt()
  @Min(0)
  readonly t2130: number;
  @IsInt()
  @Min(0)
  readonly t2145: number;
  @IsInt()
  @Min(0)
  readonly t2200: number;
  @IsDate()
  readonly created_at: Date;
  @IsDate()
  readonly updated_at: Date;
  @IsBoolean()
  readonly is_deleted: boolean;
}

export class Agenda {
  @IsDateString()
  readonly fecha: string;
  @IsString()
  @IsNotEmpty()
  readonly themeName: string;
  @IsString()
  readonly imageUrl: string;
  @IsInt()
  @Min(0)
  readonly '19:00': number;
  @IsInt()
  @Min(0)
  readonly '19:15': number;
  @IsInt()
  @Min(0)
  readonly '19:30': number;
  @IsInt()
  @Min(0)
  readonly '19:45': number;
  @IsInt()
  @Min(0)
  readonly '20:00': number;
  @IsInt()
  @Min(0)
  readonly '20:15': number;
  @IsInt()
  @Min(0)
  readonly '20:30': number;
  @IsInt()
  @Min(0)
  readonly '20:45': number;
  @IsInt()
  @Min(0)
  readonly '21:00': number;
  @IsInt()
  @Min(0)
  readonly '21:15': number;
  @IsInt()
  @Min(0)
  readonly '21:30': number;
  @IsInt()
  @Min(0)
  readonly '21:45': number;
  @IsInt()
  @Min(0)
  readonly '22:00': number;
}

export class AgendaPostDTO {
  /* @ApiProperty({
    type: String,
    format: 'yyyy-mm-dd',
    example: '2021-01-01',
    description: 'Date cant be in the past',
  }) */
  @IsDateString()
  readonly fecha: string;
  /* @ApiProperty({
    type: Number,
    example: 2,
    minimum: 1,
  }) */
  @IsInt()
  @Min(1)
  readonly restaurantThemeId: number;
}

export class AgendaPatchDTO {
  @IsOptional()
  @IsInt()
  @Min(1)
  readonly restaurantThemeId?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '19:00'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '19:15'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '19:30'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '19:45'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '20:00'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '20:15'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '20:30'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '20:45'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '21:00'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '21:15'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '21:30'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '21:45'?: number | undefined;
  @IsOptional()
  @IsInt()
  @Min(0)
  readonly '22:00'?: number | undefined;
}

export class Availability {
  @IsDateString()
  fecha: string;
  @IsEnum(TIME_OPTIONS)
  hora: TIME_OPTIONS;
  @IsInt()
  availableSeats: number;
}
