export interface Agenda {
  fecha: string;
  themeName: "Restaurante Mexicano";
  imageUrl: string;
  '19:00': number;
  '19:15': number;
  '19:30': number;
  '19:45': number;
  '20:00': number;
  '20:15': number;
  '20:30': number;
  '20:45': number;
  '21:00': number;
  '21:15': number;
  '21:30': number;
  '21:45': number;
  '22:00': number;
}

export enum TIME_OPTIONS {
  t1900 = "19:00",
  t1915 = "19:15",
  t1930 = "19:30",
  t1945 = "19:45",
  t2000 = "20:00",
  t2015 = "20:15",
  t2030 = "20:30",
  t2045 = "20:45",
  t2100 = "21:00",
  t2115 = "21:15",
  t2130 = "21:30",
  t2145 = "21:45",
  t2200 = "22:00",
}
