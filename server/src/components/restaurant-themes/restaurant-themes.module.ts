import { Module } from '@nestjs/common';
import { RestaurantThemesController } from './restaurant-themes.controller';
import { RestaurantThemeService } from './restaurant-themes.service';

@Module({
  controllers: [RestaurantThemesController],
  providers: [RestaurantThemeService],
})
export class RestaurantThemesModule {}
