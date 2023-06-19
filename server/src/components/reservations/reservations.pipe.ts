import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { MEAL_PLAN, TIME_OPTIONS } from '../../../src/app.schema';
import { ReservationPostDTO } from './reservations.schema';

@Injectable()
export class ValidateTimeOptionsEnumPipe implements PipeTransform {
  transform(value: ReservationPostDTO) {
    // from http://goo.gl/0ejHHW
    const allTO = Object.values(TIME_OPTIONS);
    const allMP = Object.values(MEAL_PLAN);
    if (!allTO.includes(value.hora) || !allMP.includes(value.mealPlan)) {
      throw new BadRequestException(
        `${value.mealPlan} or ${value.hora} is not a valid data`,
      );
    }
    return value;
  }
}
