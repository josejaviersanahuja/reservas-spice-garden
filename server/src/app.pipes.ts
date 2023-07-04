import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { TIME_OPTIONS } from './app.schema';

@Injectable()
export class ValidateStringDatePipe implements PipeTransform {
  transform(value: string) {
    // from http://goo.gl/0ejHHW
    const iso8601 =
      /^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))|W([0-4]\d|5[0-3])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?$/;
    if (!iso8601.test(value)) {
      throw new BadRequestException(`${value} is not a valid Date`);
    }
    return value;
  }
}

@Injectable()
export class ValidateStringTimeOptionsPipe implements PipeTransform {
  transform(value: TIME_OPTIONS) {
    // from http://goo.gl/0ejHHW
    const options = Object.values(TIME_OPTIONS);
    if (!options.includes(value)) {
      throw new BadRequestException(`${value} is not a valid Time Option`);
    }
    return value;
  }
}
