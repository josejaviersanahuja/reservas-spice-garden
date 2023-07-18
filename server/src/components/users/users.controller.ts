import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Patch,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import * as bcrypt from 'bcrypt';
import { UsersService } from './users.service';
import { ValidateUserPatchDTOPipe } from './users.pipe';
import { PureUser, UserPatchDTO } from './users.schema';

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private userService: UsersService) {}

  @Get()
  async getAllUsers() {
    const allUsers: PureUser[] = await this.userService.getAllUsers();
    allUsers.forEach((user) => delete user.user_password);
    return allUsers;
  }

  @Get('/:id')
  async getUserById(@Param('id', ParseIntPipe) id: number) {
    const user: PureUser = await this.userService.getUserById(id);
    delete user.user_password;
    return user;
  }

  @Patch('/:id')
  async updateUser(
    @Param('id', ParseIntPipe) id: number,
    @Body(ValidateUserPatchDTOPipe) dto: UserPatchDTO,
  ) {
    if (dto.user_password) {
      dto.user_password = await bcrypt.hash(dto.user_password, 10);
    }
    const user: PureUser = await this.userService.updateUser(id, dto);
    delete user.user_password;
    return user;
  }
}
