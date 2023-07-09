import { Controller, Get, Param, ParseIntPipe, Patch } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { UsersService } from './users.service';

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private userService: UsersService) {}

  @Get()
  getAllUsers() {
    return this.userService.getAllUsers();
  }

  @Get('/:id')
  getUserById(@Param('id', ParseIntPipe) id: number) {
    return this.userService.getUserById(id);
  }

  @Patch('/:id')
  updateUser(
    @Param('id', ParseIntPipe) id: number,
    @Body(ValidateAgendaPatchDTOPipe) dto: UserPatchDTO, // create and fix import here for pipe
  ) {
    return this.userService.getUserById(id);
  }
}
