import { Agenda } from "@/schemas/AgendaSchema";
import AgendaSmallCard from "./components/AgendaSmallCard";
import { ServerErrorSchema } from "@/schemas/ServerErrorSchema";

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
    <div className="flex min-h-custom-body flex-col items-center justify-between p-16 lg:p-0 md:p-4 sm:p-8">
      <div>
        <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 sm:py-12 lg:max-w-7xl lg:px-8">
          <h2 className="text-2xl font-bold tracking-tight text-gray-900">
            Últimas y Próximas Agendas
          </h2>

          <div className="mt-6 grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3 xl:gap-x-8 xl:grid-cols-4">
            {agendas.reverse().map((agenda) => (
              <AgendaSmallCard key={agenda.fecha} agenda={agenda} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
