import { ReservationPatchDTO } from './reservations.schema';

export const reservationPatchBuildQuery = (
  id: number,
  dto: ReservationPatchDTO,
): string => {
  let query = `SELECT update_reservation(${id}`;
  if (dto.fecha) {
    query += `, '${dto.fecha}'`;
  } else {
    query += `, NULL`;
  }
  if (dto.hora) {
    query += `, '${dto.hora}'`;
  } else {
    query += `, NULL`;
  }
  if (dto.resNumber) {
    query += `, ${dto.resNumber}`;
  } else {
    query += `, NULL`;
  }
  if (dto.resName) {
    query += `, '${dto.resName}'`;
  } else {
    query += `, NULL`;
  }
  if (dto.room) {
    query += `, '${dto.room}'`;
  } else {
    query += `, NULL`;
  }
  if (dto.isBonus) {
    query += `, ${dto.isBonus}`;
  } else {
    query += `, NULL`;
  }
  if (dto.bonusQty) {
    query += `, ${dto.bonusQty}`;
  } else {
    query += `, NULL`;
  }
  if (dto.mealPlan) {
    query += `, '${dto.mealPlan}'`;
  } else {
    query += `, NULL`;
  }
  if (dto.paxNumber) {
    query += `, ${dto.paxNumber}`;
  } else {
    query += `, NULL`;
  }
  if (dto.cost) {
    query += `, ${dto.cost}`;
  } else {
    query += `, NULL`;
  }
  if (dto.observations) {
    query += `, '${dto.observations}'`;
  } else {
    query += `, NULL`;
  }
  if (dto.isNoshow) {
    query += `, ${dto.isNoshow}`;
  }
  query += `) as result`;
  return query;
};
