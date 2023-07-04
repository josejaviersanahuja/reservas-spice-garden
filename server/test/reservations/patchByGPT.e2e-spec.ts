import { Test, TestingModule } from '@nestjs/testing';
import {
  INestApplication,
  BadRequestException,
  NotFoundException,
  ValidationPipe,
} from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { ReservationsService } from '../../src/components/reservations/reservations.service';
import {
  ReservationPatchDTO,
  AggReservation,
} from '../../src/components/reservations/reservations.schema';
import { pg } from '../pg';

describe('ReservationsController (e2e)', () => {
  let app: INestApplication;
  let reservationsService: ReservationsService;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    reservationsService =
      moduleFixture.get<ReservationsService>(ReservationsService);
    app.useGlobalPipes(new ValidationPipe());
    await app.init();
  });

  afterAll(async () => {
    await pg.query('CALL seed()');
    await pg.end();
    await app.close();
  });

  describe('/reservations/:id (PATCH)', () => {
    it('should return 200 when updating an existing reservation', async () => {
      const reservationId = 1;
      const reservationPatchData: ReservationPatchDTO = {
        // Provide the necessary data for updating the reservation
        cost: 200,
      };

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .expect(200);

      const data: AggReservation = response.body;

      expect(data.cost).toBe(200);
      // expect(response.body).toEqual(mockResponse); // @TODO Update this assertion
    });

    it('should return 400 when updating a reservation in the past', async () => {
      const reservationId = 1;
      const reservationPatchData: ReservationPatchDTO = {
        // Provide the necessary data for updating the reservation
      };

      jest
        .spyOn(reservationsService, 'updateReservation')
        .mockRejectedValue(
          new BadRequestException(
            'The reservation you are trying to update is in the past',
          ),
        );

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .expect(400);

      expect(response.body).toEqual({
        statusCode: 400,
        message: 'The reservation you are trying to update is in the past',
        error: 'Bad Request',
      });
    });

    it('should return 404 when updating a non-existing reservation', async () => {
      const reservationId = 100;
      const reservationPatchData: ReservationPatchDTO = {
        // Provide the necessary data for updating the reservation
      };

      jest
        .spyOn(reservationsService, 'updateReservation')
        .mockRejectedValue(new NotFoundException('Reservation not found'));

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .expect(404);

      expect(response.body).toEqual({
        statusCode: 404,
        message: 'Reservation not found',
        error: 'Not Found',
      });
    });
  });
});
