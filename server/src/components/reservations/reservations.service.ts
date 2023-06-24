import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, BadRequestException, NotFoundException } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { ReservationsService } from '../../src/components/reservations/reservations.service';
import { ReservationPatchDTO, AggReservation } from '../../src/components/reservations/reservations.schema';

describe('ReservationsController (e2e)', () => {
  let app: INestApplication;
  let reservationsService: ReservationsService;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    reservationsService = moduleFixture.get<ReservationsService>(ReservationsService);

    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/reservations/:id (PATCH)', () => {
    it('should return 200 when updating an existing reservation', async () => {
      const reservationId = 1;
      const reservationPatchData: ReservationPatchDTO = {
        // Provide the necessary data for updating the reservation
      };

      const mockResponse: AggReservation = {} as AggReservation;
      jest
        .spyOn(reservationsService, 'updateReservation')
        .mockResolvedValue(mockResponse);

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .expect(200);

      expect(response.body).toEqual(mockResponse);
    });

    it('should return 400 when updating a reservation in the past', async () => {
      const reservationId = 1;
      const reservationPatchData: ReservationPatchDTO = {
        // Provide the necessary data for updating the reservation
      };

      const mockError = {
        isError: true,
        errorCode: 'P0001',
      };

      jest
        .spyOn(reservationsService, 'updateReservation')
        .mockRejectedValue(new BadRequestException('The reservation you are trying to update is in the past', mockError));

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .expect(400);

      expect(response.body).toEqual({
        statusCode: 400,
        message: 'The reservation you are trying to update is in the past',
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
      });
    });
  });
});
