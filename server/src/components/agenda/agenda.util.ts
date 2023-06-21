import { AgendaPatchDTO } from '../agenda/agenda.schema';

export const AgendaPatchQueryBuilder = (fecha: string, dto: AgendaPatchDTO) => {
  let query = `SELECT update_agenda('${fecha}'`;
  if (dto.restaurantThemeId) {
    query += `, ${dto.restaurantThemeId}`;
  } else {
    query += `, null`;
  }
  if (dto['19:00']) {
    query += `, ${dto['19:00']}`;
  } else {
    query += `, null`;
  }
  if (dto['19:15']) {
    query += `, ${dto['19:15']}`;
  } else {
    query += `, null`;
  }
  if (dto['19:30']) {
    query += `, ${dto['19:30']}`;
  } else {
    query += `, null`;
  }
  if (dto['19:45']) {
    query += `, ${dto['19:45']}`;
  } else {
    query += `, null`;
  }
  if (dto['20:00']) {
    query += `, ${dto['20:00']}`;
  } else {
    query += `, null`;
  }
  if (dto['20:15']) {
    query += `, ${dto['20:15']}`;
  } else {
    query += `, null`;
  }
  if (dto['20:30']) {
    query += `, ${dto['20:30']}`;
  } else {
    query += `, null`;
  }
  if (dto['20:45']) {
    query += `, ${dto['20:45']}`;
  } else {
    query += `, null`;
  }
  if (dto['21:00']) {
    query += `, ${dto['21:00']}`;
  } else {
    query += `, null`;
  }
  if (dto['21:15']) {
    query += `, ${dto['21:15']}`;
  } else {
    query += `, null`;
  }
  if (dto['21:30']) {
    query += `, ${dto['21:30']}`;
  } else {
    query += `, null`;
  }
  if (dto['21:45']) {
    query += `, ${dto['21:45']}`;
  }
  query += `) as result`;
  return query;
};
