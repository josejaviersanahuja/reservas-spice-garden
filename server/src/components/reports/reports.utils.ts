import Excel4Node from '../../excel4node/excel4node.d';
import { AggregatedReservations } from '../reservations/reservations.schema';
import { StatsByDate, StatsByTheme } from '../statistics/statistics.schema';

/**
 *
 * @param wb
 * @param fileName
 * @returns
 * @deprecated Use the wb.writeToBuffer() method instead
 */
export function saveExcel(
  wb: Excel4Node.Workbook,
  fileName: string,
): Promise<boolean> {
  // escribimos el archivo
  return new Promise<boolean>((resolve, reject) => {
    wb.write(`${fileName}.xlsx`, (err: Error, stats: { size: number }) => {
      if (err) {
        reject(err);
      } else {
        if (stats.size > 4000000) {
          reject('El archivo es demasiado grande');
        }
        resolve(true);
      }
    });
  });
}

export async function generateTodayReservationsExcel(
  wb: Excel4Node.Workbook,
  data: AggregatedReservations[],
) {
  const style = wb.createStyle({
    font: {
      color: '#000000',
      size: 12,
    },
    numberFormat: '$#,##0.00; ($#,##0.00); -',
  });
  const styleBold = wb.createStyle({
    font: {
      color: '#000000',
      size: 14,
      bold: true,
    },
    numberFormat: '$#,##0.00; ($#,##0.00); -',
  });
  // return empty excel if there are no reservations
  if (data.length === 0 || data[0].standard_reservations.length === 0) {
    return await wb.writeToBuffer();
  }
  // write headers
  const bigObject = data[0];
  const ws = wb.addWorksheet(`${bigObject.fecha} ${bigObject.theme_name}`);
  const headers = Object.keys(bigObject.standard_reservations[0]);
  Object.keys(headers).forEach((key, index) => {
    ws.cell(1, index + 1)
      .string(key)
      .style(styleBold);
  });
  // write data
  bigObject.standard_reservations.forEach((reservation, indexF) => {
    Object.values(reservation).forEach((value, indexC) => {
      ws.cell(indexF + 2, indexC + 1)
        .string(value)
        .style(style);
    });
  });
  return await wb.writeToBuffer();
}

export async function generateStatisticsExcel(
  wb: Excel4Node.Workbook,
  statsByDate: StatsByDate[],
  statsByTheme: StatsByTheme[],
) {
  const ws1 = wb.addWorksheet('ByDate');
  const ws2 = wb.addWorksheet('ByTheme');

  const style = wb.createStyle({
    font: {
      color: '#000000',
      size: 12,
    },
    numberFormat: '$#,##0.00; ($#,##0.00); -',
  });
  const styleBold = wb.createStyle({
    font: {
      color: '#000000',
      size: 14,
      bold: true,
    },
    numberFormat: '$#,##0.00; ($#,##0.00); -',
  });

  // write headers
  const headers1 = Object.keys(statsByDate[0]);
  Object.keys(headers1).forEach((key, index) => {
    ws1
      .cell(1, index + 1)
      .string(key)
      .style(styleBold);
  });
  const headers2 = [
    'theme_name',
    '% reservas',
    'total reservas',
    '% pax',
    'total pax',
    '% con AI',
    'total AI',
    '% Cash',
    'total Cash',
  ];
  Object.keys(headers2).forEach((key, index) => {
    ws2
      .cell(1, index + 1)
      .string(key)
      .style(styleBold);
  });

  // write data ws1
  statsByDate.forEach((stat, indexF) => {
    Object.values(stat).forEach((value, indexC) => {
      ws1
        .cell(indexF + 2, indexC + 1)
        .string(value)
        .style(style);
    });
  });

  // write data ws2
  statsByTheme.forEach((stat, indexF) => {
    const porcentageReservas = Boolean(Number(stat.num_res_total))
      ? (Number(stat.num_res_theme) / Number(stat.num_res_total)) * 100
      : 0;
    const porcentagePax = Boolean(Number(stat.pax_res_total))
      ? (Number(stat.pax_res_theme) / Number(stat.pax_res_total)) * 100
      : 0;
    const porcentageAI = Boolean(Number(stat.bonus_res_total))
      ? (Number(stat.bonus_res_theme) / Number(stat.bonus_res_total)) * 100
      : 0;
    const porcentageCash = Boolean(Number(stat.cash_total))
      ? (Number(stat.cash_theme) * 100) / Number(stat.cash_total)
      : 0;
    const values = [
      stat.theme_name,
      porcentageReservas,
      stat.num_res_theme,
      porcentagePax,
      stat.pax_res_theme,
      porcentageAI,
      stat.bonus_res_theme,
      porcentageCash,
      stat.cash_theme,
    ];
    Object.values(values).forEach((value, indexC) => {
      ws2
        .cell(indexF + 2, indexC + 1)
        .string(value.toString())
        .style(style);
    });
  });

  return await wb.writeToBuffer();
}
