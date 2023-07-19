import { Agenda } from "@/schemas/AgendaSchema";
import { log } from "console";

interface Props {
  params: {
    fecha: string;
  };
}

const getAgendaByDate = async (fecha: string) => {
  return await fetch(
    process.env.API_URL + `/agenda/${fecha}`,
    {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        apikey: process.env.API_KEY ?? "",
      },
      cache: "no-cache",
    },
  );
};

export default async function Agenda({ params }: Props) {
  const response = await getAgendaByDate(params.fecha);
  const res = await response.json();
  if (typeof res === "object" && "statusCode" in res) {
    throw new Error(res.message + " - statusCode " + res.statusCode);
  }
  const agenda: Agenda = res;
  console.log(agenda);
  return <section>Esta es la agenda con fecha {params.fecha}</section>;
}
