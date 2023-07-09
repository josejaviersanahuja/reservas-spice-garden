import { UserPatchDTO } from './users.schema';

export const UsersPatchQueryBuilder = (dto: UserPatchDTO): string => {
  const { id, username, user_password } = dto;
  let query = `SELECT update_user(${id}`;
  if (username) {
    query += `, '${username}'`;
  } else {
    query += `, null`;
  }
  if (userPassword) {
    query += `, '${userPassword}'`;
  } else {
    query += `, null`;
  }
  query += `) as result`;
  return query;
};
