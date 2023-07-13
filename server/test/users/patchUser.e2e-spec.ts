import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import * as bcrypt from 'bcrypt';
import { AppModule } from '../../src/app.module';
import { pg } from '../pg';
import {
  PureUser,
  UserPatchDTO,
} from '../../src/components/users/users.schema';

describe('AgendaController (e2e)', () => {
  let app: INestApplication;
  let jwt: string;

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

  afterEach(async () => {
    await pg.query('CALL seed()');
  });

  describe('/user/:id (PATCH)', () => {
    it('should return 200 when updating an existing User', async () => {
      const userData: UserPatchDTO = {
        username: 'newUsername',
      };

      const resBeforeUpdate = await request(app.getHttpServer()).get(
        '/users/2',
      );

      return request(app.getHttpServer())
        .patch('/users/2')
        .send(userData)
        .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect((response) => {
          const updatedUser: PureUser = response.body;
          expect(resBeforeUpdate.body.username).not.toEqual(
            updatedUser.username,
          );
          expect(updatedUser.username).toEqual('newUsername');
          expect(updatedUser).not.toHaveProperty('user_password');
        });
    });

    it('should return 200 when updating an existing agenda with only 1 field t1945', async () => {
      const userData: UserPatchDTO = {
        user_password: 'newPassword',
      };

      const { rows } = await pg.query('SELECT * FROM users WHERE id = 2');
      const userBefore: PureUser = rows[0];

      return request(app.getHttpServer())
        .patch('/users/2')
        .send(userData)
        .set('Authorization', `Bearer ${jwt}`)
        .expect(200)
        .expect(async () => {
          const { rows } = await pg.query('SELECT * FROM users WHERE id = 2');
          const userAfter: PureUser = rows[0];
          const isMatchAfter = await bcrypt.compare(
            'newPassword',
            userAfter.user_password,
          );
          const isMatchBefore = await bcrypt.compare(
            'newPassword',
            userBefore.user_password,
          );
          expect(isMatchAfter).toEqual(true);
          expect(isMatchBefore).toEqual(false);
        });
    });

    it('should return 400 when updating an agenda with bad data', () => {
      const userData: UserPatchDTO = {};

      return request(app.getHttpServer())
        .patch('/users/2')
        .send(userData)
        .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const updatedUser = response.body;
          expect(updatedUser.statusCode).toEqual(400);
        });
    });

    it('should return 404 when updating a non-existing agenda', () => {
      const userData: UserPatchDTO = {
        username: 'newUsername',
      };

      return request(app.getHttpServer())
        .patch('/users/666')
        .send(userData)
        .set('Authorization', `Bearer ${jwt}`)
        .expect(404)
        .expect((response) => {
          const updatedRestaurantTheme = response.body;
          expect(updatedRestaurantTheme.statusCode).toEqual(404);
        });
    });
  });
});
