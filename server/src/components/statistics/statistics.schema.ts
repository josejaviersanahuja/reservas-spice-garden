import {
  IsDateString,
  IsInt,
  IsNumberString,
  IsString,
  Min,
  ValidateIf,
} from 'class-validator';

export class StatsByTheme {
  @IsString()
  theme_name: string;
  @IsNumberString()
  num_res_theme: string;
  @IsNumberString()
  num_res_total: string;
  @IsNumberString()
  pax_res_theme: string;
  @IsNumberString()
  pax_res_total: string;
  @IsNumberString()
  bonus_res_theme: string;
  @IsNumberString()
  bonus_res_total: string;
  @IsNumberString()
  cash_theme: string;
  @IsNumberString()
  cash_total: string;
}

export class StatsAssistants {
  @IsDateString()
  fecha: string;
  @IsInt()
  @Min(0)
  num_standard_res: number;
  @IsInt()
  @Min(0)
  num_no_show_res: number;
  @IsInt()
  @ValidateIf((object, value) => value !== null)
  num_standard_pax: number | null;
  @IsInt()
  @ValidateIf((object, value) => value !== null)
  no_show_pax: number | null;
}

export class StatsByDate {
  @IsDateString()
  fecha: string;
  @IsString()
  theme_name: string;
  @IsNumberString()
  reserved: string;
  @IsNumberString()
  assistants: string;
  @IsNumberString()
  total_cash: string;
  @IsNumberString()
  total_bonus: string;
}
