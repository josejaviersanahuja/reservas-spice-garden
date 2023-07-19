import { Agenda } from "@/schemas/AgendaSchema";
import AgendaSmallCard from "./components/AgendaSmallCard";
import { ServerErrorSchema } from "@/schemas/ServerErrorSchema";
import AgendasList from "./components/AgendasList";

const loadAgendasForThisMonth = () => {
  // get the starting and the end date of the current month
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - 10);
  const endDate = new Date();
  endDate.setDate(endDate.getDate() + 10);
  const fechaI = startDate.toISOString().substring(0, 10);
  const fechaF = endDate.toISOString().substring(0, 10);
  // fetch(`${config.apiUrl}//agenda?fechaI=2023-07-02&fechaF=2023-07-31`)
  return fetch(
    process.env.API_URL + `/agenda?fechaI=${fechaI}&fechaF=${fechaF}`,
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

export default async function Home() {
  const response = await loadAgendasForThisMonth();
  const agendas: Agenda[] = await response.json();

  if (!Array.isArray(agendas)) {
    let message = "Error al cargar las agendas - ";
    const error = agendas as ServerErrorSchema;
    if (error.message) {
      message += error.message;
    }
    if (error.statusCode) {
      message += " - statusCode " + error.statusCode;
    }
    throw new Error(message);
  }

  return (
    <AgendasList
      agendas={agendas.reverse()}
      title="Últimas y Próximas Agendas"
    />
  );
}
