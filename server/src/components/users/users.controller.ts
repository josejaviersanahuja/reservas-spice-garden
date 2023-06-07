import { Controller, Get, Param } from '@nestjs/common';

@Controller('users')
export class UsersController {
  // constructor() {}

  @Get()
  getAllUsers() {
    return 'endpoint users';
  }

  @Get('/:id')
  getUserById(@Param('id') id: string) {
    return `endpoint user con id ${id}`;
  }
}
