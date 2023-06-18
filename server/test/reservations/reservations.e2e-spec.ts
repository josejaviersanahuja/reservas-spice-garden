import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';

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

  describe('/reservations (GET)', () => {
    it('should return reservations between two dates', () => {
      const fecha0 = '2023-06-01';
      const fecha1 = '2023-06-15';

      return request(app.getHttpServer())
        .get(`/reservations?fecha0=${fecha0}&fecha1=${fecha1}`)
        .expect(200)
        .expect((response) => {
          // Aquí puedes verificar la estructura y los datos de la respuesta
          const reservations = response.body.data;
          expect(Array.isArray(reservations)).toBe(true);
          expect(reservations.length).toBe(0);
        });
    });
  });

  describe('/reservations/:fecha (GET)', () => {
    it('should return reservations for a specific date', () => {
      const fecha = '2023-06-15';

      return request(app.getHttpServer())
        .get(`/reservations/${fecha}`)
        .expect(200)
        .expect((response) => {
          // Aquí puedes verificar la estructura y los datos de la respuesta
          const reservations = response.body.data;
          expect(Array.isArray(reservations)).toBe(true);
          expect(reservations.length).toBe(0);
        });
    });
  });

  describe('/reservations (POST)', () => {
    it('should create a new reservation', () => {
      const reservationData = {
        fecha: '2023-08-15',
        hora: '19:30',
        resNumber: 1,
        resName: 'John Doe',
        room: '101',
        isBonus: false,
        bonusQty: 0,
        mealPlan: 'FB',
        paxNumber: 2,
        cost: 100,
        observations: '',
        isNoshow: false,
      };

      return request(app.getHttpServer())
        .post('/reservations')
        .send(reservationData)
        .expect(422)
        .expect((response) => {
          // Aquí puedes verificar la estructura y los datos de la respuesta
          const createdReservation = response.body;
          expect(createdReservation.message).toBeDefined();
          expect(createdReservation.message).toEqual(
            'insert or update on table "reservations" violates foreign key constraint "fk_reservations_agenda"',
          );
          // ...
        });
    });
  });
});
