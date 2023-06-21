import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { pg } from '../pg';
import {
  RestaurantTheme,
  RestaurantThemePostDTO,
} from '../../src/components/restaurant-themes/restaurant-themes.schema';

describe('RestaurantThemesController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe());
    await app.init();
  });

  afterAll(async () => {
    await pg.query('CALL seed()');
    await app.close();
  });

  describe('/restaurant-themes (POST)', () => {
    it('should return 201 when inserting a valid new restaurant theme', () => {
      const restaurantThemeData: RestaurantThemePostDTO = {
        themeName: 'Restaurante Venezolano',
        description: 'Restaurante de comida venezolana',
        imageUrl: 'https://example.com/image.jpg',
      };

      return request(app.getHttpServer())
        .post('/restaurant-themes')
        .send(restaurantThemeData)
        .expect(201)
        .expect((response) => {
          const createdRestaurantTheme: RestaurantTheme = response.body;
          expect(createdRestaurantTheme.themeName).toEqual(
            'Restaurante Venezolano',
          );
          expect(createdRestaurantTheme.description).toEqual(
            'Restaurante de comida venezolana',
          );
          expect(createdRestaurantTheme.imageUrl).toEqual(
            'https://example.com/image.jpg',
          );
          expect(createdRestaurantTheme.id).toBe(4);
        });
    });

    it('should return 201 when inserting a valid new restaurant theme without imageUrl', () => {
      const restaurantThemeData: RestaurantThemePostDTO = {
        themeName: 'Restaurante Colombiano',
        description: 'Restaurante de comida colombiana',
      };

      return request(app.getHttpServer())
        .post('/restaurant-themes')
        .send(restaurantThemeData)
        .expect(201)
        .expect((response) => {
          const createdRestaurantTheme: RestaurantTheme = response.body;
          expect(createdRestaurantTheme.themeName).toEqual(
            'Restaurante Colombiano',
          );
          expect(createdRestaurantTheme.description).toEqual(
            'Restaurante de comida colombiana',
          );
          expect(createdRestaurantTheme.imageUrl).toEqual(null);
          expect(createdRestaurantTheme.id).toBe(5);
        });
    });

    it('should return 400 when inserting a restaurant theme with empty themeName', () => {
      const restaurantThemeData: RestaurantThemePostDTO = {
        themeName: '',
        description: 'Restaurante de comida italiana',
        imageUrl: 'https://example.com/image.jpg',
      };

      return request(app.getHttpServer())
        .post('/restaurant-themes')
        .send(restaurantThemeData)
        .expect(400)
        .expect((response) => {
          const createdRestaurantTheme = response.body;
          expect(createdRestaurantTheme.statusCode).toEqual(400);
        });
    });

    it('should return 400 when inserting a restaurant theme with empty imageUrl', () => {
      const restaurantThemeData: RestaurantThemePostDTO = {
        themeName: 'test',
        description: 'Restaurante de comida italiana',
        imageUrl: '',
      };

      return request(app.getHttpServer())
        .post('/restaurant-themes')
        .send(restaurantThemeData)
        .expect(400)
        .expect((response) => {
          const createdRestaurantTheme = response.body;
          expect(createdRestaurantTheme.statusCode).toEqual(400);
        });
    });
  });
});
