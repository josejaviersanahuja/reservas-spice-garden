import { Controller, Get, Param } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('restaurant-themes')
@Controller('restaurant-themes')
export class RestaurantThemesController {
  // constructor() {}

  @Get()
  getRestaurantThemes() {
    return 'endpoint restaurant-themes';
  }

  @Get('/:id')
  getRestaurantThemeById(@Param('id') id: string) {
    return `endpoint restaurant theme con id ${id}`;
  }
}
