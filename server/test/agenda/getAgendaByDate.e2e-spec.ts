import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { Agenda } from 'src/components/agenda/agenda.schema';

describe('Agenda Controller (e2e)', () => {
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

  describe('/agenda/:fecha (GET)', () => {
    it('should return statusCode 404 when there is no agenda on that date ', () => {
      const fecha = '2023-06-15';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}`)
        .expect(404)
        .expect((response) => {
          const reservation = response.body;
          expect(reservation.statusCode).toBe(404);
        });
    });
    it('should return an Agenda for a specific date', () => {
      const fecha = '2023-07-01';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}`)
        .expect(200)
        .expect((response) => {
          const agenda: Agenda = response.body;
          expect(typeof agenda.fecha).toBe('string');
          expect(agenda.fecha.substring(0, 10)).toBe('2023-07-01');
          expect(agenda.themeName).toBe('Restaurante Mexicano');
        });
    });
  });

  describe('/agenda/:fecha (GET) Bad Request', () => {
    it('should return statusCode 400 for a wrong entry', () => {
      const fecha = '2023-01';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}`)
        .expect(400)
        .expect((response) => {
          const res = response.body;
          expect(res.statusCode).toBe(400);
        });
    });
  });
});
