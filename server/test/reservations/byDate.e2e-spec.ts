import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { AggregatedReservations } from 'src/components/reservations/reservations.schema';

describe('ReservationsController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/reservations/:fecha (GET)', () => {
    it('should return 0 ', () => {
      const fecha = '2023-06-15';

      return request(app.getHttpServer())
        .get(`/reservations/${fecha}`)
        .expect(200)
        .expect((response) => {
          const numAgendas = response.body.numAgendas;
          const reservations: AggregatedReservations[] = response.body.data;
          let countRes = 0;
          reservations.forEach((res) => {
            countRes += Array.isArray(res.standard_reservations)
              ? res.standard_reservations.length
              : 0;
            countRes += Array.isArray(res.no_show_reservations)
              ? res.no_show_reservations.length
              : 0;
            countRes += Array.isArray(res.cancelled_reservations)
              ? res.cancelled_reservations.length
              : 0;
          });
          expect(Array.isArray(reservations)).toBe(true);
          expect(numAgendas).toBe(0);
          expect(reservations.length).toBe(0);
          expect(countRes).toBe(0);
        });
    });
  });
  describe('/reservations/:fecha (GET)', () => {
    it('should return reservations for a specific date', () => {
      const fecha = '2023-07-01';

      return request(app.getHttpServer())
        .get(`/reservations/${fecha}`)
        .expect(200)
        .expect((response) => {
          const numAgendas = response.body.numAgendas;
          const reservations: AggregatedReservations[] = response.body.data;
          let countRes = 0;
          reservations.forEach((res) => {
            countRes += Array.isArray(res.standard_reservations)
              ? res.standard_reservations.length
              : 0;
            countRes += Array.isArray(res.no_show_reservations)
              ? res.no_show_reservations.length
              : 0;
            countRes += Array.isArray(res.cancelled_reservations)
              ? res.cancelled_reservations.length
              : 0;
          });
          expect(Array.isArray(reservations)).toBe(true);
          expect(numAgendas).toBe(1);
          expect(reservations.length).toBe(1);
          expect(countRes).toBe(15);
        });
    });
  });
});
