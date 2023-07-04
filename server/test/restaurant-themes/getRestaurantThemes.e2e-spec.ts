import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { PureRestaurantTheme } from '../../src/components/restaurant-themes/restaurant-themes.schema';
import { pg } from '../pg';

describe('Restaurant Themes Controller (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await pg.end();
    await app.close();
  });

  describe('/restaurant-themes (GET)', () => {
    it('should return an array of Restaurant Themes', () => {
      return request(app.getHttpServer())
        .get('/restaurant-themes')
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
