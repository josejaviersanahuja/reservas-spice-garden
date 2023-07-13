import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import {
  ReservationPatchDTO,
  AggReservation,
} from '../../src/components/reservations/reservations.schema';
import { pg } from '../pg';

describe('ReservationsController (e2e)', () => {
  let app: INestApplication;
  let jwt: string;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();

    app.useGlobalPipes(new ValidationPipe());
    await app.init();
    const loginPayload = {
      username: 'reception',
      password: '123456',
    };

    const respose = await request(app.getHttpServer())
      .post('/auth/login')
      .send(loginPayload);

    jwt = respose.body.access_token;
  });

  afterAll(async () => {
    await pg.query('CALL seed()');
    await pg.end();
    await app.close();
  });

  describe('/reservations/:id (PATCH)', () => {
    it('should return 200 when updating an existing reservation', async () => {
      const reservationId = 220;
      const reservationPatchData: ReservationPatchDTO = {
        cost: 200,
      };

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .set('Authorization', `Bearer ${jwt}`)
        .expect(200);

      const data: AggReservation = response.body;

      expect(data.cost).toBe(200);
    });

    it('should return 400 when updating a reservation in the past', async () => {
      const reservationId = 1;
      const reservationPatchData: ReservationPatchDTO = {
        cost: 200,
      };

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .set('Authorization', `Bearer ${jwt}`)
        .expect(400);

      expect(response.body).toEqual({
        statusCode: 400,
        message: 'The reservation you are trying to update is in the past',
        error: 'Bad Request',
      });
    });

    it('should return 404 when updating a non-existing reservation', async () => {
      const reservationId = 1000000;
      const reservationPatchData: ReservationPatchDTO = {
        cost: 200,
      };

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .set('Authorization', `Bearer ${jwt}`)
        .expect(404);

      expect(response.body).toEqual({
        statusCode: 404,
        message: 'Not found: No record updated',
        error: 'Not Found',
      });
    });
  });
});
