import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { UserPatchDTO } from './users.schema';

@Injectable()
export class ValidateUserPatchDTOPipe implements PipeTransform {
  transform(value: UserPatchDTO) {
    if (
      !value.username && !value.user_password
    ) {
      throw new BadRequestException(`At least one field must be provided`);
    }
    return value;
  }
}
