import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { RestaurantThemePutDTO } from './restaurant-themes.schema';

@Injectable()
export class ValidateRestaurantThemesPutDTOPipe implements PipeTransform {
  transform(value: RestaurantThemePutDTO) {
    // from http://goo.gl/0ejHHW
    if (!value.themeName && !value.description && !value.imageUrl) {
      throw new BadRequestException(
        `At least one field must be provided: themeName, description or imageUrl`,
      );
    }
    return value;
  }
}
