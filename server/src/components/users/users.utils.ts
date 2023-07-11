import { UserPatchDTO } from './users.schema';

export const UsersPatchQueryBuilder = (
  id: number,
  dto: UserPatchDTO,
): string => {
  const { username, user_password } = dto;
  let query = `SELECT update_user(${id}`;
  if (username) {
    query += `, '${username}'`;
  } else {
    query += `, null`;
  }
  if (user_password) {
    query += `, '${user_password}'`;
  } else {
    query += `, null`;
  }
  query += `) as result`;
  return query;
};
