import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { ReservationsService } from './reservations.service';
import { AggReservation, ReservationPostDTO } from './reservations.schema';
import { ValidateStringDatePipe } from '../../app.pipes';
import {
  ApiOkResponse,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { MEAL_PLAN, ROOM_OPTIONS, TIME_OPTIONS } from '../../../src/app.schema';

@ApiTags('reservations')
@Controller('reservations')
export class ReservationsController {
  constructor(private reservationService: ReservationsService) {}

  @ApiOperation({ summary: 'Get reservations between dates' })
  @ApiOkResponse({
    schema: {
      type: 'object',
      properties: {
        numAgendas: { type: 'number' },
        data: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              fecha: {
                type: 'string',
                format: 'yyyy-mm-ddThh:mm:ss.sssZ',
                example: '2021-01-01T00:00:00.000Z',
              },
              standard_reservations: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'number' },
                    fecha: {
                      type: 'string',
                      format: 'yyyy-mm-dd',
                      example: '2021-01-01',
                    },
                    hora: {
                      type: 'string',
                      enum: Object.values(TIME_OPTIONS),
                    },
                    res_number: { type: 'number' },
                    res_name: { type: 'string' },
                    room: {
                      type: 'string',
                      enum: Object.values(ROOM_OPTIONS),
                    },
                    is_bonus: { type: 'boolean' },
                    bonus_qty: { type: 'number' },
                    meal_plan: {
                      type: 'string',
                      enum: Object.values(MEAL_PLAN),
                    },
                    pax_number: { type: 'number' },
                    cost: { type: 'number' },
                    observations: { type: 'string' },
                    is_noshow: { type: 'boolean' },
                    created_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    updated_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    is_deleted: { type: 'boolean' },
                  },
                },
              },
              no_show_reservations: {
                type: 'array',
                default: null,
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'number' },
                    fecha: {
                      type: 'string',
                      format: 'yyyy-mm-dd',
                      example: '2021-01-01',
                    },
                    hora: {
                      type: 'string',
                      enum: Object.values(TIME_OPTIONS),
                    },
                    res_number: { type: 'number' },
                    res_name: { type: 'string' },
                    room: {
                      type: 'string',
                      enum: Object.values(ROOM_OPTIONS),
                    },
                    is_bonus: { type: 'boolean' },
                    bonus_qty: { type: 'number' },
                    meal_plan: {
                      type: 'string',
                      enum: Object.values(MEAL_PLAN),
                    },
                    pax_number: { type: 'number' },
                    cost: { type: 'number' },
                    observations: { type: 'string' },
                    is_noshow: { type: 'boolean' },
                    created_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    updated_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    is_deleted: { type: 'boolean' },
                  },
                },
              },
              cancelled_reservations: {
                type: 'array',
                default: null,
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'number' },
                    fecha: {
                      type: 'string',
                      format: 'yyyy-mm-dd',
                      example: '2021-01-01',
                    },
                    hora: {
                      type: 'string',
                      enum: Object.values(TIME_OPTIONS),
                    },
                    res_number: { type: 'number' },
                    res_name: { type: 'string' },
                    room: {
                      type: 'string',
                      enum: Object.values(ROOM_OPTIONS),
                    },
                    is_bonus: { type: 'boolean' },
                    bonus_qty: { type: 'number' },
                    meal_plan: {
                      type: 'string',
                      enum: Object.values(MEAL_PLAN),
                    },
                    pax_number: { type: 'number' },
                    cost: { type: 'number' },
                    observations: { type: 'string' },
                    is_noshow: { type: 'boolean' },
                    created_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    updated_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    is_deleted: { type: 'boolean' },
                  },
                },
              },
              theme_name: { type: 'string' },
            },
          },
        },
      },
    },
  })
  @Get()
  getReservations(
    @Query('fecha0', ValidateStringDatePipe) fecha0: string,
    @Query('fecha1', ValidateStringDatePipe) fecha1: string,
  ) {
    return this.reservationService.getReservationsBetweenDates(fecha0, fecha1);
  }

  @ApiOperation({ summary: 'Get reservations by date' })
  @Get('/:fecha')
  @ApiOkResponse({
    schema: {
      type: 'object',
      properties: {
        numAgendas: { type: 'number', default: 1 },
        data: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              fecha: {
                type: 'string',
                format: 'yyyy-mm-ddThh:mm:ss.sssZ',
                example: '2021-01-01T00:00:00.000Z',
              },
              standard_reservations: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'number' },
                    fecha: {
                      type: 'string',
                      format: 'yyyy-mm-dd',
                      example: '2021-01-01',
                    },
                    hora: {
                      type: 'string',
                      enum: Object.values(TIME_OPTIONS),
                    },
                    res_number: { type: 'number' },
                    res_name: { type: 'string' },
                    room: {
                      type: 'string',
                      enum: Object.values(ROOM_OPTIONS),
                    },
                    is_bonus: { type: 'boolean' },
                    bonus_qty: { type: 'number' },
                    meal_plan: {
                      type: 'string',
                      enum: Object.values(MEAL_PLAN),
                    },
                    pax_number: { type: 'number' },
                    cost: { type: 'number' },
                    observations: { type: 'string' },
                    is_noshow: { type: 'boolean' },
                    created_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    updated_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    is_deleted: { type: 'boolean' },
                  },
                },
              },
              no_show_reservations: {
                type: 'array',
                default: null,
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'number' },
                    fecha: {
                      type: 'string',
                      format: 'yyyy-mm-dd',
                      example: '2021-01-01',
                    },
                    hora: {
                      type: 'string',
                      enum: Object.values(TIME_OPTIONS),
                    },
                    res_number: { type: 'number' },
                    res_name: { type: 'string' },
                    room: {
                      type: 'string',
                      enum: Object.values(ROOM_OPTIONS),
                    },
                    is_bonus: { type: 'boolean' },
                    bonus_qty: { type: 'number' },
                    meal_plan: {
                      type: 'string',
                      enum: Object.values(MEAL_PLAN),
                    },
                    pax_number: { type: 'number' },
                    cost: { type: 'number' },
                    observations: { type: 'string' },
                    is_noshow: { type: 'boolean' },
                    created_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    updated_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    is_deleted: { type: 'boolean' },
                  },
                },
              },
              cancelled_reservations: {
                type: 'array',
                default: null,
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'number' },
                    fecha: {
                      type: 'string',
                      format: 'yyyy-mm-dd',
                      example: '2021-01-01',
                    },
                    hora: {
                      type: 'string',
                      enum: Object.values(TIME_OPTIONS),
                    },
                    res_number: { type: 'number' },
                    res_name: { type: 'string' },
                    room: {
                      type: 'string',
                      enum: Object.values(ROOM_OPTIONS),
                    },
                    is_bonus: { type: 'boolean' },
                    bonus_qty: { type: 'number' },
                    meal_plan: {
                      type: 'string',
                      enum: Object.values(MEAL_PLAN),
                    },
                    pax_number: { type: 'number' },
                    cost: { type: 'number' },
                    observations: { type: 'string' },
                    is_noshow: { type: 'boolean' },
                    created_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    updated_at: {
                      type: 'string',
                      example: '2021-01-01T00:00:00.000Z',
                    },
                    is_deleted: { type: 'boolean' },
                  },
                },
              },
              theme_name: { type: 'string' },
            },
          },
        },
      },
    },
  })
  async getReservationsByDate(
    @Param('fecha', ValidateStringDatePipe) fecha: string,
  ) {
    return this.reservationService.getReservationsByDate(fecha);
  }

  @ApiOperation({ summary: 'Create reservation' })
  @ApiResponse({
    status: 201,
    schema: {
      type: 'object',
      properties: {
        id: { type: 'number' },
        fecha: { type: 'string', format: 'yyyy-mm-dd', example: '2021-01-01' },
        hora: { type: 'string', enum: Object.values(TIME_OPTIONS) },
        res_number: { type: 'number' },
        res_name: { type: 'string' },
        room: { type: 'string', enum: Object.values(ROOM_OPTIONS) },
        is_bonus: { type: 'boolean' },
        bonus_qty: { type: 'number' },
        meal_plan: { type: 'string', enum: Object.values(MEAL_PLAN) },
        pax_number: { type: 'number' },
        cost: { type: 'number' },
        observations: { type: 'string' },
        is_noshow: { type: 'boolean' },
        created_at: { type: 'string', example: '2021-01-01T00:00:00.000Z' },
        updated_at: { type: 'string', example: '2021-01-01T00:00:00.000Z' },
        is_deleted: { type: 'boolean' },
      },
    },
  })
  @Post()
  postReservation(@Body() dto: ReservationPostDTO): Promise<AggReservation> {
    return this.reservationService.createReservation(dto);
  }
}
