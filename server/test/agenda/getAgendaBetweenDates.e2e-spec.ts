import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { Agenda } from '../../src/components/agenda/agenda.schema';
import { pg } from '../pg';

describe('Agenda Controller (e2e)', () => {
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

  describe('/agenda?fechaI=&fechaF= (GET)', () => {
    it('should return 200 an Agenda[] with length of 20', () => {
      const fechaI = '2023-07-01';
      const fechaF = '2023-07-31';

      return request(app.getHttpServer())
        .get(`/agenda?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const agendas: Agenda[] = response.body;
          expect(agendas.length).toBe(20);
          expect(agendas[0].fecha).toBe('2023-07-01');
        });
    });
    it('should return 200 an Agenda[] with length of 0', () => {
      const fechaI = '2023-06-01';
      const fechaF = '2023-07-01';

      return request(app.getHttpServer())
        .get(`/agenda?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const agendas: Agenda[] = response.body;
          expect(agendas.length).toBe(0);
        });
    });
    it('should return 200 an Agenda[] with length of 1', () => {
      const fechaI = '2023-07-27';
      const fechaF = '2023-07-31';

      return request(app.getHttpServer())
        .get(`/agenda?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const agendas: Agenda[] = response.body;
          expect(agendas.length).toBe(1);
          expect(agendas[0].fecha).toBe('2023-07-27');
        });
    });
  });
  describe('/agenda?fechaI=&fechaF= (GET) WRING INPUTS', () => {
    it('should return 400', () => {
      const fechaI = '2023-0-01';
      const fechaF = '2023-07-31';

      return request(app.getHttpServer())
        .get(`/agenda?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          expect(response.body.statusCode).toBe(400);
        });
    });
    it('should return 400', () => {
      const fechaI = '2023-07-01';
      const fechaF = '2023-0-31';

      return request(app.getHttpServer())
        .get(`/agenda?fechaI=${fechaI}&fechaF=${fechaF}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          expect(response.body.statusCode).toBe(400);
        });
    });
  });
});
