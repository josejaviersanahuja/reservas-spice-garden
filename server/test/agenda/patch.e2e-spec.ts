import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { pg } from '../pg';
import { Agenda, AgendaPatchDTO } from 'src/components/agenda/agenda.schema';

describe('AgendaController (e2e)', () => {
  let app: INestApplication;
  // let jwt: string;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(
      new ValidationPipe({
        skipMissingProperties: true,
      }),
    );
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

  describe('/agenda/:fecha (PATCH)', () => {
    it('should return 200 when updating an existing Agenda', async () => {
      const agendaData: AgendaPatchDTO = {
        restaurantThemeId: 2,
        '19:00': 2,
        '19:30': 2,
        '20:00': 2,
        '20:30': 2,
        '21:00': 2,
        '21:30': 2,
        '19:15': 2,
        '19:45': 2,
        '20:15': 2,
        '20:45': 2,
        '21:15': 2,
        '21:45': 2,
      };

      await request(app.getHttpServer()).post('/agenda').send({
        fecha: '2030-12-30',
        restaurantThemeId: 1,
      }); //  .set('Authorization', `Bearer ${jwt}`);

      return request(app.getHttpServer())
        .patch('/agenda/2030-12-30')
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const updatedAgenda: Agenda = response.body;
          expect(updatedAgenda.themeName).toEqual('Restaurante Italiano');
          expect(updatedAgenda['19:00']).toEqual(2);
          expect(updatedAgenda['19:15']).toEqual(2);
          expect(updatedAgenda['19:30']).toEqual(2);
          expect(updatedAgenda['19:45']).toEqual(2);
          expect(updatedAgenda['20:00']).toEqual(2);
          expect(updatedAgenda['20:15']).toEqual(2);
          expect(updatedAgenda['20:30']).toEqual(2);
          expect(updatedAgenda['20:45']).toEqual(2);
          expect(updatedAgenda['21:00']).toEqual(2);
          expect(updatedAgenda['21:15']).toEqual(2);
          expect(updatedAgenda['21:30']).toEqual(2);
          expect(updatedAgenda['21:45']).toEqual(2);
        });
    });

    it('should return 200 when updating an existing agenda with only 1 field t1945', async () => {
      const agendaData: AgendaPatchDTO = {
        '19:45': 2,
      };

      await request(app.getHttpServer()).post('/agenda').send({
        fecha: '2030-12-31',
        restaurantThemeId: 1,
      }); //  .set('Authorization', `Bearer ${jwt}`);

      return request(app.getHttpServer())
        .patch('/agenda/2030-12-31')
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const updatedAgenda: Agenda = response.body;
          expect(updatedAgenda.themeName).toEqual('Restaurante Mexicano');
          expect(updatedAgenda['19:45']).toEqual(2);
        });
    });

    it('should return 400 when updating an agenda with bad data', () => {
      const agendaData: AgendaPatchDTO = {
        restaurantThemeId: 0,
      };

      return request(app.getHttpServer())
        .patch('/agenda/2030-12-31')
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const updatedAgenda = response.body;
          expect(updatedAgenda.statusCode).toEqual(400);
        });
    });

    it('should return 400 when updating an agenda in the past', () => {
      const agendaData: AgendaPatchDTO = {
        restaurantThemeId: 2,
      };

      return request(app.getHttpServer())
        .patch('/agenda/2020-12-31')
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const updatedAgenda = response.body;
          expect(updatedAgenda.statusCode).toEqual(400);
        });
    });

    it('should return 400 when updating a restaurant theme with empty object', () => {
      const agendaData: AgendaPatchDTO = {};

      return request(app.getHttpServer())
        .patch('/agenda/2030-12-31')
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const updatedAgenda = response.body;
          expect(updatedAgenda.statusCode).toEqual(400);
        });
    });

    it('should return 404 when updating a non-existing agenda', () => {
      const agendaData: AgendaPatchDTO = {
        restaurantThemeId: 2,
      };

      return request(app.getHttpServer())
        .patch('/agenda/2031-12-31')
        .send(agendaData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(404)
        .expect((response) => {
          const updatedRestaurantTheme = response.body;
          expect(updatedRestaurantTheme.statusCode).toEqual(404);
        });
    });
  });
});
