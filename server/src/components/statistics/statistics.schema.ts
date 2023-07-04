import { IsNumberString, IsString } from 'class-validator';

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
