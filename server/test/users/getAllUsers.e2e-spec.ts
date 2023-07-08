import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
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

  describe('/users (GET)', () => {
    it('should return 200 with an array of users', () => {
      return request(app.getHttpServer())
        .get('/users')
        .expect(200)
        .expect((response) => {
          const users: PureUser[] = response.body;
          expect(users).toBeInstanceOf(Array);
          expect(users.length).toBe(4);
        });
    });
  });
});
