import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../src/app.module';
import { StatsAssistants } from '../../src/components/statistics/statistics.schema';
import { pg } from '../pg';

describe('ReservationsController (e2e)', () => {
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
    await pg.end();
    await app.close();
  });

  describe('/statistics/assistants/:fecha (GET)', () => {
    it('should return status 200 and some pax and res', () => {
      const fecha = '2023-07-01';

      return request(app.getHttpServer())
        .get(`/statistics/assistants/${fecha}`)
        .expect(200)
        .expect((response) => {
          const stats: StatsAssistants = response.body;
          expect(stats.fecha).toBe(fecha);
          expect(stats.no_show_pax).toBe(null);
          expect(stats.num_no_show_res).toBe(0);
          expect(stats.num_standard_res).toBe(15);
          expect(stats.num_standard_pax).toBe(36);
        });
    });
  });

  describe('/statistics/assistants/:fecha (GET) on date without agenda', () => {
    it('should return status 200 and pax = null and res = 0', () => {
      const fecha = '2023-06-01';

      return request(app.getHttpServer())
        .get(`/statistics/assistants/${fecha}`)
        .expect(200)
        .expect((response) => {
          const stats: StatsAssistants = response.body;
          expect(stats.fecha).toBe(fecha);
          expect(stats.no_show_pax).toBe(null);
          expect(stats.num_no_show_res).toBe(0);
          expect(stats.num_standard_res).toBe(0);
          expect(stats.num_standard_pax).toBe(null);
        });
    });
  });

  describe('/statistics/assistants/:fecha (GET) With Wrong Inputs', () => {
    it('should return 400', () => {
      const fecha = '2023-0-01';

      return request(app.getHttpServer())
        .get(`/statistics/assistants/${fecha}`)
        .expect(400)
        .expect((response) => {
          expect(response.body.statusCode).toBe(400);
        });
    });
  });
});
