import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { Agenda } from '../../src/components/agenda/agenda.schema';
import { pg } from '../pg';

describe('Agenda Controller (e2e)', () => {
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

  describe('/agenda/:fecha (GET)', () => {
    it('should return statusCode 404 when there is no agenda on that date ', () => {
      const fecha = '2023-06-15';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}`)
        .set('Authorization', `Bearer ${jwt}`)
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
        .set('Authorization', `Bearer ${jwt}`)
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
      const fecha = '2023-1-12';

      return request(app.getHttpServer())
        .get(`/agenda/${fecha}`)
        .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const res = response.body;
          expect(res.statusCode).toBe(400);
        });
    });
  });
});
