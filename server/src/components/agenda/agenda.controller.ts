import { Controller, Get, Param } from '@nestjs/common';

@Controller('agenda')
export class AgendaController {
  // constructor() {}

  @Get()
  getAgendas() {
    return 'endpoint agenda';
  }

  @Get('/:fecha')
  getAgendaByDate(@Param('fecha') fecha: string) {
    return `endpoint agenda con fecha ${fecha}`;
  }
}
