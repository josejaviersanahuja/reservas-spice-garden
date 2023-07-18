import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { PureRestaurantTheme } from '../../src/components/restaurant-themes/restaurant-themes.schema';
import { pg } from '../pg';

describe('Restaurant Themes Controller (e2e)', () => {
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

  describe('/restaurant-themes/:id (GET)', () => {
    it('should return an specific Restaurant Theme by id', () => {
      const id = 1;

      return request(app.getHttpServer())
        .get(`/restaurant-themes/${id}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const restaurantTheme: PureRestaurantTheme = response.body;
          expect(restaurantTheme.id).toBe(id);
          expect(restaurantTheme.theme_name).toBe('Restaurante Mexicano');
          expect(restaurantTheme.description).toBe(
            'Restaurante de comida mexicana',
          );
        });
    });
    it('should return statusCode 404 when there is no Restaurant Theme with that id', () => {
      const id = 999;

      return request(app.getHttpServer())
        .get(`/restaurant-themes/${id}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(404)
        .expect((response) => {
          const res = response.body;
          expect(res.statusCode).toBe(404);
        });
    });
  });

  describe('/restaurant-themes/:id (GET) Bad Request', () => {
    it('should return statusCode 400 for a wrong entry', () => {
      const id = 'abc';

      return request(app.getHttpServer())
        .get(`/restaurant-themes/${id}`) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const res = response.body;
          expect(res.statusCode).toBe(400);
        });
    });
  });
});
