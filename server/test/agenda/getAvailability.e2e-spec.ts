import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { Availability } from '../../src/components/agenda/agenda.schema';
import { pg } from '../pg';

describe('Agenda Controller (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe());
    await app.init();
  });

  afterAll(async () => {
    await pg.query('CALL seed()');
    await pg.end();
    await app.close();
  });

  describe('/agenda/:fecha/availability/:hora (GET)', () => {
    it('should return statusCode 404 when there is no agenda on that date ', () => {
      const fecha = '2023-06-15';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}/availability/19:00`)
        .expect(404)
        .expect((response) => {
          const reservation = response.body;
          expect(reservation.statusCode).toBe(404);
        });
    });
    it('should return 200 for a specific date', () => {
      const fecha = '2023-07-01';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}/availability/19:30`)
        .expect(200)
        .expect((response) => {
          const res: Availability = response.body;
          expect(typeof res.fecha).toBe('string');
          expect(res.fecha.substring(0, 10)).toBe('2023-07-01');
          expect(res.hora).toBe('19:30');
          expect(typeof res.availableSeats).toBe('number');
          expect(res.availableSeats).toBe(2);
        });
    });
  });

  describe('/agenda/:fecha/availability/:hora (GET) Bad Request', () => {
    it('should return statusCode 400 for a wrong entry', () => {
      const fecha = '2023-1-12';
      const hora = '19:30';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}/availability/${hora}`)
        .expect(400)
        .expect((response) => {
          const res = response.body;
          expect(res.statusCode).toBe(400);
        });
    });

    it('should return statusCode 400 for a wrong entry', () => {
      const fecha = '2023-01-12';
      const hora = '10:00';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}/availability/${hora}`)
        .expect(400)
        .expect((response) => {
          const res = response.body;
          expect(res.statusCode).toBe(400);
        });
    });
  });
});
