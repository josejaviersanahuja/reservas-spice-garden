import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { RestaurantThemeService } from './restaurant-themes.service';
import {
  RestaurantThemePostDTO,
  RestaurantThemePutDTO,
} from './restaurant-themes.schema';
import { ValidateRestaurantThemesPutDTOPipe } from './restaurant-themes.pipe';

@ApiTags('restaurant-themes')
@Controller('restaurant-themes')
export class RestaurantThemesController {
  constructor(private rtService: RestaurantThemeService) {}

  @Get()
  async getRestaurantThemes() {
    return await this.rtService.getAllRestaurantThemes();
  }

  @Get('/:id')
  async getRestaurantThemeById(@Param('id', ParseIntPipe) id: number) {
    return await this.rtService.getRestaurantThemeById(id);
  }

  @Post()
  async createRestaurantTheme(@Body() dto: RestaurantThemePostDTO) {
    return await this.rtService.createRestaurantTheme(dto);
  }

  @Patch('/:id')
  async updateRestaurantTheme(
    @Param('id', ParseIntPipe) id: number,
    @Body(ValidateRestaurantThemesPutDTOPipe) dto: RestaurantThemePutDTO,
  ) {
    return await this.rtService.updateRestaurantTheme(id, dto);
  }
}
