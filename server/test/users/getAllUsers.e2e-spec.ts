import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { PureUser } from '../../src/components/users/users.schema';
import { pg } from '../pg';

describe('Users Controller (e2e)', () => {
  let app: INestApplication;
  let jwt: string;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
    const loginPayload = {
      username: 'reception',
      password: '123456',
    };

    const respose = await request(app.getHttpServer())
      .post('/auth/login')
      .send(loginPayload);

    jwt = respose.body.access_token;
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
        .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const users: PureUser[] = response.body;
          expect(users).toBeInstanceOf(Array);
          expect(users.length).toBe(4);
          users.forEach((user) => {
            expect(user).not.toHaveProperty('user_password');
          });
        });
    });
  });
});
