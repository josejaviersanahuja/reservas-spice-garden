import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { Client } from 'pg';
import {
  AgendaPostDTO,
  PureAgenda,
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
    console.log('db connected');

    await pg.query('CALL seed()');
    await pg.end();
    console.log('db disconnected');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();

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
        restaurant_theme_id: 1,
      };

      return request(app.getHttpServer())
        .post('/agenda')
        .send(agendaData)
        .expect(201)
        .expect((response) => {
          console.log(response.body);

          const createdAgenda: PureAgenda = response.body;
          expect(createdAgenda.restaurant_theme_id).toEqual(1);
        });
    });

    it('should return 400 when inserting a reservation on the past', () => {
      const currentDate = new Date('2020-12-01');
      const agendaData: AgendaPostDTO = {
        fecha: currentDate.toISOString(),
        restaurant_theme_id: 1,
      };

      return request(app.getHttpServer())
        .post('/agenda')
        .send(agendaData)
        .expect(400)
        .expect((response) => {
          console.log(response.body);
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
        restaurant_theme_id: -1,
      };

      return request(app.getHttpServer())
        .post('/agenda')
        .send(agendaData)
        .expect(400)
        .expect((response) => {
          console.log(response.body);
          const createdReservation = response.body;
          expect(createdReservation.message).toEqual(
            'Bad request: No record inserted - Date is in the past',
          );
        });
    });
  });
});
