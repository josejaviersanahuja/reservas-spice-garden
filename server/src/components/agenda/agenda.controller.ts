import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';
import {
  ValidateStringDatePipe,
  ValidateStringTimeOptionsPipe,
} from '../../app.pipes';
import { AgendaService } from './agenda.service';
import { AgendaPatchDTO, AgendaPostDTO } from './agenda.schema';
import { ApiTags } from '@nestjs/swagger';
import { ValidateAgendaPatchDTOPipe } from './agenda.pipe';
import { TIME_OPTIONS } from '../../app.schema';

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

  @Get('/:fecha/availability/:hora')
  async getAgendaAvailability(
    @Param('fecha', ValidateStringDatePipe) fecha: string,
    @Param('hora', ValidateStringTimeOptionsPipe) hora: TIME_OPTIONS,
  ) {
    return await this.agendaService.getAgendaAvailability(fecha, hora);
  }

  @Post()
  async postAgenda(@Body() dto: AgendaPostDTO) {
    return await this.agendaService.createAgenda(dto);
  }

  @Patch('/:fecha')
  async patchAgenda(
    @Param('fecha', ValidateStringDatePipe) fecha: string,
    @Body(ValidateAgendaPatchDTOPipe) dto: AgendaPatchDTO,
  ) {
    return await this.agendaService.updateAgenda(fecha, dto);
  }
}
