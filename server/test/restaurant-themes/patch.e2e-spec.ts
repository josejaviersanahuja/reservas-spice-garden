import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { pg } from '../pg';
import {
  RestaurantTheme,
  RestaurantThemePutDTO,
} from '../../src/components/restaurant-themes/restaurant-themes.schema';

describe('RestaurantThemesController (e2e)', () => {
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

  describe('/restaurant-themes/:id (PATCH)', () => {
    it('should return 200 when updating an existing restaurant theme', () => {
      const restaurantThemeData: RestaurantThemePutDTO = {
        themeName: 'Restaurante Italiano',
        description: 'Restaurante de comida italiana',
        imageUrl: 'https://example.com/image.jpg',
      };

      return request(app.getHttpServer())
        .patch('/restaurant-themes/1')
        .send(restaurantThemeData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const updatedRestaurantTheme: RestaurantTheme = response.body;
          expect(updatedRestaurantTheme.themeName).toEqual(
            'Restaurante Italiano',
          );
          expect(updatedRestaurantTheme.description).toEqual(
            'Restaurante de comida italiana',
          );
          expect(updatedRestaurantTheme.imageUrl).toEqual(
            'https://example.com/image.jpg',
          );
          expect(updatedRestaurantTheme.id).toBe(1);
        });
    });

    it('should return 200 when updating an existing restaurant theme with only themeName', () => {
      const restaurantThemeData: RestaurantThemePutDTO = {
        themeName: 'Restaurante Italiano',
      };

      return request(app.getHttpServer())
        .patch('/restaurant-themes/1')
        .send(restaurantThemeData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const updatedRestaurantTheme: RestaurantTheme = response.body;
          expect(updatedRestaurantTheme.themeName).toEqual(
            'Restaurante Italiano',
          );
          expect(updatedRestaurantTheme.description).toEqual(
            'Restaurante de comida italiana',
          );
          expect(updatedRestaurantTheme.imageUrl).toEqual(
            'https://example.com/image.jpg',
          );
          expect(updatedRestaurantTheme.id).toBe(1);
        });
    });

    it('should return 200 when updating an existing restaurant theme with only description', () => {
      const restaurantThemeData: RestaurantThemePutDTO = {
        description: 'Restaurante Italiano',
      };

      return request(app.getHttpServer())
        .patch('/restaurant-themes/1')
        .send(restaurantThemeData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const updatedRestaurantTheme: RestaurantTheme = response.body;
          expect(updatedRestaurantTheme.themeName).toEqual(
            'Restaurante Italiano',
          );
          expect(updatedRestaurantTheme.description).toEqual(
            'Restaurante Italiano',
          );
          expect(updatedRestaurantTheme.imageUrl).toEqual(
            'https://example.com/image.jpg',
          );
          expect(updatedRestaurantTheme.id).toBe(1);
        });
    });

    it('should return 200 when updating an existing restaurant theme with only imageUrl', () => {
      const restaurantThemeData: RestaurantThemePutDTO = {
        imageUrl: 'http://Italiano.it',
      };

      return request(app.getHttpServer())
        .patch('/restaurant-themes/1')
        .send(restaurantThemeData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const updatedRestaurantTheme: RestaurantTheme = response.body;
          expect(updatedRestaurantTheme.themeName).toEqual(
            'Restaurante Italiano',
          );
          expect(updatedRestaurantTheme.description).toEqual(
            'Restaurante Italiano',
          );
          expect(updatedRestaurantTheme.imageUrl).toEqual('http://Italiano.it');
          expect(updatedRestaurantTheme.id).toBe(1);
        });
    });

    it('should return 400 when updating a restaurant theme with empty themeName', () => {
      const restaurantThemeData: RestaurantThemePutDTO = {
        themeName: '',
        description: 'Restaurante de comida italiana',
        imageUrl: 'https://example.com/image.jpg',
      };

      return request(app.getHttpServer())
        .patch('/restaurant-themes/1')
        .send(restaurantThemeData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const updatedRestaurantTheme = response.body;
          expect(updatedRestaurantTheme.statusCode).toEqual(400);
        });
    });

    it('should return 400 when updating a restaurant theme with empty imageUrl', () => {
      const restaurantThemeData: RestaurantThemePutDTO = {
        themeName: 'test',
        description: 'Restaurante de comida italiana',
        imageUrl: '',
      };

      return request(app.getHttpServer())
        .patch('/restaurant-themes/1')
        .send(restaurantThemeData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const updatedRestaurantTheme = response.body;
          expect(updatedRestaurantTheme.statusCode).toEqual(400);
        });
    });

    it('should return 400 when updating a restaurant theme with empty object', () => {
      const restaurantThemeData: RestaurantThemePutDTO = {};

      return request(app.getHttpServer())
        .patch('/restaurant-themes/1')
        .send(restaurantThemeData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const updatedRestaurantTheme = response.body;
          expect(updatedRestaurantTheme.statusCode).toEqual(400);
        });
    });

    it('should return 404 when updating a non-existing restaurant theme', () => {
      const restaurantThemeData: RestaurantThemePutDTO = {
        themeName: 'Restaurante Italiano',
        description: 'Restaurante de comida italiana',
        imageUrl: 'https://example.com/image.jpg',
      };

      return request(app.getHttpServer())
        .patch('/restaurant-themes/100')
        .send(restaurantThemeData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(404)
        .expect((response) => {
          const updatedRestaurantTheme = response.body;
          expect(updatedRestaurantTheme.statusCode).toEqual(404);
        });
    });
  });
});
