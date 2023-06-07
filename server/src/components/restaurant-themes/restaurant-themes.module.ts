import { Module } from '@nestjs/common';
import { RestaurantThemesController } from './restaurant-themes.controller';

@Module({
  controllers: [RestaurantThemesController],
})
export class RestaurantThemesModule {}
