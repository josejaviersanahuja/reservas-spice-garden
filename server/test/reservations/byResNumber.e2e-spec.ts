import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { AggReservation } from '../../src/components/reservations/reservations.schema';
import { pg } from '../pg';
// import { ReservationsService } from '../../src/components/reservations/reservations.service';

describe('ReservationsController (e2e)', () => {
  let app: INestApplication;
  // let reservationsService: ReservationsService;

  beforeAll(async () => {
    await pg.query('CALL seed()');
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    // reservationsService =
    //   moduleFixture.get<ReservationsService>(ReservationsService);
    app.useGlobalPipes(new ValidationPipe());
    await app.init();
  });

  afterAll(async () => {
    await pg.query('CALL seed()');
    await pg.end();
    await app.close();
  });

  describe('/reservations/byResNumber (GET)', () => {
    it('should return 0 ', async () => {
      /*   const mockResponse: {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      } = {} as {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      };
      jest
        .spyOn(reservationsService, 'getReservationsByResNumber')
        .mockResolvedValue(
          reservationsService.getReservationsByResNumber(1000000),
        );
 */
      const response = await request(app.getHttpServer())
        .get(`/reservations/byResNumber/1000000`)
        .expect(200);
      const data: {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      } = response.body;

      // expect(response.body).toEqual(mockResponse);
      expect(data.bonusRes.length).toBe(0);
      expect(data.payableRes.length).toBe(0);
    });

    it('should return 3 payable reservations ', async () => {
      /*       const mockResponse: {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      } = {} as {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      };
      jest
        .spyOn(reservationsService, 'getReservationsByResNumber')
        .mockResolvedValue(reservationsService.getReservationsByResNumber(10));
 */
      const response = await request(app.getHttpServer())
        .get(`/reservations/byResNumber/10`)
        .expect(200);

      const data: {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      } = response.body;

      // expect(response.body).toEqual(mockResponse);
      expect(data.bonusRes.length).toBe(0);
      expect(data.payableRes.length).toBe(4);
    });

    it('should return 2 bonusreservations and 4 payable reservations ', async () => {
      /* const mockResponse: {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      } = {} as {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      };
      jest
        .spyOn(reservationsService, 'getReservationsByResNumber')
        .mockResolvedValue(mockResponse); */

      const response = await request(app.getHttpServer())
        .get(`/reservations/byResNumber/1`)
        .expect(200);
      const data: {
        bonusRes: AggReservation[];
        payableRes: AggReservation[];
      } = response.body;

      // expect(response.body).toEqual(mockResponse);
      expect(data.bonusRes.length).toBe(2);
      expect(data.payableRes.length).toBe(4);
    });
  });

  describe('/reservations/byResNumber (GET)', () => {
    it('should return 400 when path is not a number ', async () => {
      const response = await request(app.getHttpServer())
        .get(`/reservations/byResNumber/1s`)
        .expect(400);

      expect(response.body).toEqual({
        statusCode: 400,
        message: 'Validation failed (numeric string is expected)',
        error: 'Bad Request',
      });
    });
  });
});
