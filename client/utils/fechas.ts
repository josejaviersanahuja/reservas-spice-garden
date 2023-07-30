export const isPastDate = (fechaString: string) => {
  const today = new Date();
  const thisFecha = new Date(fechaString);
  return today > thisFecha;
};
