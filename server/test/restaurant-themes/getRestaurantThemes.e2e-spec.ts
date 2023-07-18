import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
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
    await pg.end();
    await app.close();
  });

  describe('/restaurant-themes (GET)', () => {
    it('should return an array of Restaurant Themes', () => {
      return request(app.getHttpServer())
        .get('/restaurant-themes') //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const restaurantThemes: PureRestaurantTheme[] = response.body;
          expect(Array.isArray(restaurantThemes)).toBe(true);
          expect(restaurantThemes.length).toBeGreaterThan(0);
          expect(typeof restaurantThemes[0].theme_name).toBe('string');
          expect(typeof restaurantThemes[0].description).toBe('string');
        });
    });
  });
});
