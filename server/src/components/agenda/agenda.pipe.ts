import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { AgendaPatchDTO } from './agenda.schema';

@Injectable()
export class ValidateAgendaPatchDTOPipe implements PipeTransform {
  transform(value: AgendaPatchDTO) {
    // from http://goo.gl/0ejHHW
    if (
      !value.restaurantThemeId &&
      !value['19:00'] &&
      !value['19:15'] &&
      !value['19:30'] &&
      !value['19:45'] &&
      !value['20:00'] &&
      !value['20:15'] &&
      !value['20:30'] &&
      !value['20:45'] &&
      !value['21:00'] &&
      !value['21:15'] &&
      !value['21:30'] &&
      !value['21:45'] &&
      !value['22:00']
    ) {
      throw new BadRequestException(`At least one field must be provided`);
    }
    return value;
  }
}
