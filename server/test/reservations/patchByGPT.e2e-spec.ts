import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
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

      jest
        .spyOn(reservationsService, 'updateReservation')
        .mockImplementation(async () => ({} as AggReservation));

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .expect(200);

      const updatedReservation: AggReservation = response.body;
      // Make assertions on the updated reservation object
    });

    it('should return 404 when updating a non-existing reservation', async () => {
      const reservationId = 100;
      const reservationPatchData: ReservationPatchDTO = {
        // Provide the necessary data for updating the reservation
      };

      jest
        .spyOn(reservationsService, 'updateReservation')
        .mockImplementation(async () => null);

      const response = await request(app.getHttpServer())
        .patch(`/reservations/${reservationId}`)
        .send(reservationPatchData)
        .expect(404);

      // Make assertions on the response body or status code
    });
  });
});
