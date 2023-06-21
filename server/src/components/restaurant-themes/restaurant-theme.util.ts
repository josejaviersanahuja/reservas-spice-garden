import { RestaurantThemePutDTO } from './restaurant-themes.schema';

export const restaurantThenPatchQueryBuilder = (
  id: number,
  dto: RestaurantThemePutDTO,
): string => {
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
  return query;
};
