import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { pg } from '../pg';
import {
  Agenda,
  AgendaPostDTO,
} from '../../src/components/agenda/agenda.schema';

describe('ReservationsController (e2e)', () => {
  let app: INestApplication;
  // let jwt: string;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe());
    await app.init();
    /* const loginPayload = {
      username: 'reception',
      password: '123456',
    };

    const respose = await request(app.getHttpServer())
      .post('/auth/login')
      .send(loginPayload);

    jwt = respose.body.access_token; */
  });

  afterAll(async () => {
    await pg.query('CALL seed()');
    await pg.end();
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
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
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
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
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
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const createdReservation = response.body;
          expect(createdReservation.statusCode).toEqual(400);
        });
    });
  });
});
