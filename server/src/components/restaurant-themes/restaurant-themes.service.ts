import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import {
  RestaurantThemePostDTO,
  RestaurantTheme,
  PureRestaurantTheme,
  RestaurantThemePutDTO,
} from './restaurant-themes.schema';
import { Client } from 'pg';
import Pool from 'pg-pool';
import { PostgresCrudService } from '../../app.schema';

@Injectable()
export class RestaurantThemeService {
  constructor(@Inject('pg') private pg: Pool<Client>) {}

  async getAllRestaurantThemes(): Promise<PureRestaurantTheme[]> {
    const { rows } = await this.pg.query(
      `SELECT * FROM restaurant_themes_view`,
    );
    const res: PureRestaurantTheme[] = rows;
    return res;
  }

  async getRestaurantThemeById(id: number): Promise<PureRestaurantTheme> {
    const { rows } = await this.pg.query(
      `SELECT * FROM restaurant_themes_view WHERE id = ${id}`,
    );
    if (rows.length === 0) {
      throw new NotFoundException(`Restaurant Theme with id ${id} not found`);
    }
    const res: PureRestaurantTheme = rows[0];
    return res;
  }

  async createRestaurantTheme(
    dto: RestaurantThemePostDTO,
  ): Promise<RestaurantTheme> {
    let query = `SELECT create_restaurant_theme('${dto.themeName}', '${dto.description}'`;
    if (dto.imageUrl) {
      query += `, '${dto.imageUrl}'`;
    }
    query += `) as result`;
    const { rows } = await this.pg.query(query);
    const res: PostgresCrudService<RestaurantTheme> = rows[0].result;

    if (res.isError) {
      if (!res.message) {
        throw new Error(res.stack);
      }
      throw new Error(res.message + ' ' + res.errorCode);
    }
    return res.result;
  }

  async updateRestaurantTheme(
    id: number,
    dto: RestaurantThemePutDTO,
  ): Promise<RestaurantTheme> {
    let query = `SELECT update_restaurant_theme(${id}`;
    if (dto.themeName) {
      query += `,'${dto.themeName}'`;
    } else {
      query += `,null `;
    }
    if (dto.description) {
      query += `,'${dto.description}'`;
    } else {
      query += `,null`;
    }
    if (dto.imageUrl) {
      query += `, '${dto.imageUrl}'`;
    }
    query += `) as result`;

    const { rows } = await this.pg.query(query);
    const res: PostgresCrudService<RestaurantTheme> = rows[0].result;

    if (res.isError) {
      if (!res.message) {
        throw new Error(res.stack);
      }
      throw new Error(res.message + ' ' + res.errorCode);
    }
    if (!res.result) {
      throw new NotFoundException(`Restaurant Theme with id ${id} not found`);
    }
    return res.result;
  }
}
