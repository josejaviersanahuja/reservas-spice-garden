import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { StatsByTheme } from '../../src/components/statistics/statistics.schema';
import { pg } from '../pg';

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

  describe('/statistics/byTheme?fechaI=&fechaF= (GET)', () => {
    it('should return status 200 and array of 3 objects ', () => {
      const fechaI = '2023-07-01';
      const fechaF = '2023-07-31';

      return request(app.getHttpServer())
        .get(`/statistics/byTheme?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const stats: StatsByTheme[] = response.body;
          expect(Array.isArray(stats)).toBe(true);
          expect(stats.length).toBe(3);
        });
    });
  });

  describe('/statistics/byTheme?fechaI=&fechaF= (GET)', () => {
    it('should return array of length 0 when fechaF < fechaI', () => {
      const fechaI = '2023-07-01';
      const fechaF = '2023-06-30';

      return request(app.getHttpServer())
        .get(`/statistics/byTheme?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const stats: StatsByTheme[] = response.body;
          expect(Array.isArray(stats)).toBe(true);
          expect(stats.length).toBe(0);
        });
    });
  });

  describe('/statistics/byTheme?fechaI=&fechaF= (GET) WRONG INPUTS', () => {
    it('should return 400 when fechaI is wrong', () => {
      const fechaI = '2023-7-01';
      const fechaF = '2023-06-31';

      return request(app.getHttpServer())
        .get(`/statistics/byTheme?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          expect(response.body.statusCode).toBe(400);
        });
    });
    it('should return 400 when fechaF is wrong', () => {
      const fechaI = '2023-07-01';
      const fechaF = '2023-6-31';

      return request(app.getHttpServer())
        .get(`/statistics/byTheme?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          expect(response.body.statusCode).toBe(400);
        });
    });
    it('should return 400 when there is no fechaF', () => {
      const fechaI = '2023-07-01';
      const fechaF = '';

      return request(app.getHttpServer())
        .get(`/statistics/byTheme?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          expect(response.body.statusCode).toBe(400);
        });
    });
  });
});
