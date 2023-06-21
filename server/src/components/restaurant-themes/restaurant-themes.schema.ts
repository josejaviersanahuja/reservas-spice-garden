import { PartialType } from '@nestjs/swagger';
import {
  IsBoolean,
  IsDate,
  IsDateString,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUrl,
  Min,
} from 'class-validator';

export class PureRestaurantTheme {
  @IsInt()
  @Min(1)
  readonly id: number;
  @IsString()
  @IsNotEmpty()
  readonly theme_name: string;
  @IsString()
  readonly description: string;
  @IsOptional()
  @IsUrl()
  readonly image_url: string | null;
  @IsDate()
  readonly created_at: Date;
  @IsDate()
  readonly updated_at: Date;
  @IsBoolean()
  readonly is_deleted: boolean;
}

export class RestaurantTheme {
  @IsInt()
  @Min(1)
  readonly id: number;
  @IsString()
  @IsNotEmpty()
  readonly themeName: string;
  @IsString()
  readonly description: string;
  @IsOptional()
  @IsUrl()
  readonly imageUrl: string | null;
  @IsDateString()
  readonly createdAt: string;
  @IsDateString()
  readonly updatedAt: string;
  @IsBoolean()
  readonly isDeleted: boolean;
}

export class RestaurantThemePostDTO {
  @IsString()
  @IsNotEmpty()
  readonly themeName: string;
  @IsString()
  readonly description: string;
  @IsOptional()
  @IsUrl()
  readonly imageUrl?: string | undefined;
}

export class RestaurantThemePutDTO extends PartialType(
  RestaurantThemePostDTO,
) {}
