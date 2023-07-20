import { Agenda } from "@/schemas/AgendaSchema";
import AgendasList from "../components/AgendasList";

interface Props {
  searchParams:  { [key: string]: string | string[] | undefined };
}

async function loadAgendasByQueryParams(props: {
  fechaI: string;
  fechaF: string;
}) {
  console.log(props, "Debugging props");
  return await fetch(
    `http://localhost:3001/agenda?fechaI=${props.fechaI}&fechaF=${props.fechaF}`,
    {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        apikey: process.env.API_KEY ?? "",
      },
      cache: "no-cache",
    },
  );
}

export default async function Agendas({ searchParams }: Props) {
  let fechaI = searchParams.fechaI as string ?? "";
  let fechaF = searchParams.fechaF as string ?? "";
  if (!searchParams.fechaI && !searchParams.fechaF) {
    const thisMonth = new Date();
    thisMonth.setDate(1);
    fechaI = thisMonth.toISOString().substring(0, 10);
    thisMonth.setMonth(thisMonth.getMonth() + 1);
    fechaF = thisMonth.toISOString().substring(0, 10);
  }

  const response = await loadAgendasByQueryParams({
    fechaI,
    fechaF,
  });
  const res = await response.json();
  if (typeof res === "object" && "statusCode" in res) {
    throw new Error(res.message + " - statusCode " + res.statusCode);
  }
  const agendas: Agenda[] = res;

  const fechaFLimit = new Date(fechaF);
  fechaFLimit.setDate(fechaFLimit.getDate() - 1);

  if (agendas.length === 0) {
    return (
      <section>
        No hay agendas para mostrar del {fechaI} al {fechaFLimit.toISOString().substring(0, 10)}
      </section>
    );
  }
  return (
    <section>
      <AgendasList agendas={agendas} title={`Agendas del ${fechaI} al ${fechaFLimit.toISOString().substring(0,10)}`} />
    </section>
  );
}
