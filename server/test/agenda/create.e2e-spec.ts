import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { Client } from 'pg';
import {
  Agenda,
  AgendaPostDTO,
} from '../../src/components/agenda/agenda.schema';

describe('ReservationsController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const pg = new Client({
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT),
      user: process.env.DB_USER,
      password: process.env.DB_PASS,
      database: process.env.DB_NAME,
    });
    await pg.connect();
    await pg.query('CALL seed()');
    await pg.end();
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe());
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/agenda (POST)', () => {
    it('should return 201 when inserting a valid new agenda', () => {
      const currentDate = new Date('2023-12-01');
      const agendaData: AgendaPostDTO = {
        fecha: currentDate.toISOString(),
        restaurantThemeId: 1,
      };

      return request(app.getHttpServer())
        .post('/agenda')
        .send(agendaData)
        .expect(201)
        .expect((response) => {
          const createdAgenda: Agenda = response.body;
          expect(createdAgenda.themeName).toEqual('Restaurante Mexicano');
        });
    });

    it('should return 400 when inserting a reservation on the past', () => {
      const currentDate = new Date('2020-12-01');
      const agendaData: AgendaPostDTO = {
        fecha: currentDate.toISOString(),
        restaurantThemeId: 1,
      };

      return request(app.getHttpServer())
        .post('/agenda')
        .send(agendaData)
        .expect(400)
        .expect((response) => {
          const createdReservation = response.body;
          expect(createdReservation.message).toEqual(
            'Bad Request 400 Cant create agenda in the past',
          );
        });
    });

    it('should return 400 when inserting a reservation with bad input', () => {
      const currentDate = new Date('2023-12-02');
      const agendaData: AgendaPostDTO = {
        fecha: currentDate.toISOString(),
        restaurantThemeId: -1,
      };

      return request(app.getHttpServer())
        .post('/agenda')
        .send(agendaData)
        .expect(400)
        .expect((response) => {
          const createdReservation = response.body;
          expect(createdReservation.statusCode).toEqual(400);
        });
    });
  });
});
