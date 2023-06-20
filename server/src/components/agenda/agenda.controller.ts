import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { ValidateStringDatePipe } from '../../app.pipes';
import { AgendaService } from './agenda.service';
import { AgendaPostDTO } from './agenda.schema';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('agenda')
@Controller('agenda')
export class AgendaController {
  constructor(private agendaService: AgendaService) {}

  @Get() // @TODO service getAgendas con limit offset y fechas de acuerdo a los meses no se
  async getAgendas() {
    return 'endpoint agenda';
  }

  @Get('/:fecha')
  async getAgendaByDate(@Param('fecha', ValidateStringDatePipe) fecha: string) {
    return await this.agendaService.getAgendaInfo(fecha);
  }

  @Post()
  async postAgenda(@Body() dto: AgendaPostDTO) {
    return await this.agendaService.createAgenda(dto);
  }
}
