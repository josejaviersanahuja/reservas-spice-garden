import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, NotFoundException } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { PureUser } from '../../src/components/users/users.schema';
import { pg } from '../pg';

describe('Users Controller (e2e)', () => {
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
    await pg.query('CALL seed()');
    await pg.end();
    await app.close();
  });

  describe('/users/:id (GET)', () => {
    it('should return 200 with the user matching the provided id', () => {
      const id = 1;

      return request(app.getHttpServer())
        .get(`/users/${id}`)
        .expect(200)
        .expect((response) => {
          const user: PureUser = response.body;
          expect(user).toBeDefined();
          expect(user.id).toBe(id);
        });
    });

    it('should return 404 when the user with the provided id is not found', () => {
      const id = 100; // Assuming this id does not exist

      return request(app.getHttpServer())
        .get(`/users/${id}`)
        .expect(404)
        .expect((response) => {
          const errorResponse = response.body;
          expect(errorResponse.statusCode).toBe(404);
          expect(errorResponse.message).toBe(`User with id ${id} not found`);
        });
    });

    it('should return 400 when the id parameter is not a number', () => {
      const id = 'abc'; // Not a valid number

      return request(app.getHttpServer())
        .get(`/users/${id}`)
        .expect(400)
        .expect((response) => {
          const errorResponse = response.body;
          expect(errorResponse.statusCode).toBe(400);
        });
    });
  });
});
