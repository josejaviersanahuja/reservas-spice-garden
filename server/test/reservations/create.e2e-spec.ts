import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { pg } from '../pg';
import {
  AggReservation,
  ReservationPostDTO,
} from '../../src/components/reservations/reservations.schema';
import { MEAL_PLAN, ROOM_OPTIONS, TIME_OPTIONS } from '../../src/app.schema';
import { AgendaPostDTO } from '../../src/components/agenda/agenda.schema';

describe('ReservationsController (e2e)', () => {
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

  // This test will add an attempt to insert a reservation on a non existing agenda
  // It will increment the autoincremental id of the table reservations
  // id 225 will be lost forever
  describe('/reservations (POST)', () => {
    it('should return 422 when inserting a reservation when there is no agenda ', () => {
      const currentDate = new Date('2023-07-30');
      const reservationData: ReservationPostDTO = {
        fecha: currentDate.toISOString(),
        hora: TIME_OPTIONS.t1900,
        resNumber: 1,
        resName: 'John Doe',
        room: '101' as ROOM_OPTIONS,
        isBonus: false,
        bonusQty: 0,
        mealPlan: MEAL_PLAN.FB,
        paxNumber: 2,
        cost: 100,
        observations: '',
        isNoshow: false,
      };

      return request(app.getHttpServer())
        .post('/reservations')
        .send(reservationData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(422)
        .expect((response) => {
          const createdReservation = response.body;
          expect(createdReservation.message).toEqual(
            'insert or update on table "reservations" violates foreign key constraint "fk_reservations_agenda"',
          );
        });
    });

    it('should return 400 when inserting a reservation on the past', () => {
      const reservationData: ReservationPostDTO = {
        fecha: '1900-01-01',
        hora: TIME_OPTIONS.t1900,
        resNumber: 1,
        resName: 'John Doe',
        room: '101' as ROOM_OPTIONS,
        isBonus: false,
        bonusQty: 0,
        mealPlan: MEAL_PLAN.FB,
        paxNumber: 2,
        cost: 100,
        observations: '',
        isNoshow: false,
      };

      return request(app.getHttpServer())
        .post('/reservations')
        .send(reservationData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(400)
        .expect((response) => {
          const createdReservation = response.body;
          expect(createdReservation.message).toEqual(
            'Bad request: No record inserted - Date is in the past',
          );
        });
    });

    // considering id 225 is lost forever, the id for this one will be 226
    it('should return 201 when inserting a valid reservation on a valid agenda', async () => {
      const currentDate = new Date();
      currentDate.setFullYear(currentDate.getFullYear() + 1);
      const agenda: AgendaPostDTO = {
        fecha: currentDate.toISOString(),
        restaurantThemeId: 1,
      };
      const reservationData = {
        fecha: currentDate.toISOString(),
        hora: '19:30',
        resNumber: 1,
        resName: 'John Doe',
        room: '101',
        isBonus: false,
        bonusQty: 0,
        mealPlan: 'FB',
        paxNumber: 2,
        cost: 100,
        observations: '',
        isNoshow: false,
      };
      await request(app.getHttpServer())
        .post('/agenda')
        .send(agenda) //  .set('Authorization', `Bearer ${jwt}`);

      return request(app.getHttpServer())
        .post('/reservations')
        .send(reservationData) //  .set('Authorization', `Bearer ${jwt}`)
        .expect(201)
        .expect((response) => {
          const createdReservation: AggReservation = response.body;
          expect(createdReservation.id).toEqual(226);
        });
    });
  });
});
