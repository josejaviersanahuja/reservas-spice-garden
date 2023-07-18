import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { StatsByDate } from '../../src/components/statistics/statistics.schema';
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

  describe('/statistics?fechaI=&fechaF= (GET)', () => {
    it('should return status 200 and 20 objects', () => {
      const fechaI = '2023-07-01';
      const fechaF = '2023-07-31';

      return request(app.getHttpServer())
        .get(`/statistics?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const stats: StatsByDate[] = response.body;
          expect(stats.length).toBe(20);
          const money = stats.reduce(
            (acc, curr) => acc + Number(curr.total_cash),
            0,
          );
          expect(money).not.toBe(NaN);
          expect(money).toBe(18450);
        });
    });
  });
  describe('/statistics?fechaI=&fechaF= (GET) defining limits inclusions', () => {
    it('should return status 200 and 0 objects', () => {
      const fechaI = '2023-06-30'; // no agenda
      const fechaF = '2023-07-01'; // agenda but not included

      return request(app.getHttpServer())
        .get(`/statistics?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const stats: StatsByDate[] = response.body;
          expect(stats.length).toBe(0);
          const money = stats.reduce(
            (acc, curr) => acc + Number(curr.total_cash),
            0,
          );
          expect(money).not.toBe(NaN);
          expect(money).toBe(0);
        });
    });
    it('should return status 200 and 1 object', () => {
      const fechaI = '2023-07-27'; // agenda included
      const fechaF = '2023-07-31'; // no more agendas after 2023-07-27

      return request(app.getHttpServer())
        .get(`/statistics?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const stats: StatsByDate[] = response.body;
          expect(stats.length).toBe(1);
          const money = stats.reduce(
            (acc, curr) => acc + Number(curr.total_cash),
            0,
          );
          expect(money).not.toBe(NaN);
          expect(money).toBe(1490);
        });
    });
  });
  describe('/statistics?fechaI=&fechaF= (GET) WRONG INPUTS', () => {
    it('should return status 400', () => {
      const fechaI = '2023-0-01';
      const fechaF = '2023-07-31';

      return request(app.getHttpServer())
        .get(`/statistics?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          expect(response.body.statusCode).toBe(400);
        });
    });
    it('should return status 400', () => {
      const fechaI = '2023-01-01';
      const fechaF = '2023-0-31';

      return request(app.getHttpServer())
        .get(`/statistics?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          expect(response.body.statusCode).toBe(400);
        });
    });
  });
});
