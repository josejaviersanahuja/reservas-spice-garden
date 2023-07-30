import AgendaForm from "@/app/components/AgendaForm";
import { Agenda } from "@/schemas/AgendaSchema";
import { log } from "console";

interface Props {
  params: {
    fecha: string;
  };
}

const getAgendaByDate = async (fecha: string) => {
  return await fetch(process.env.API_URL + `/agenda/${fecha}`, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      apikey: process.env.API_KEY ?? "",
    },
    cache: "no-cache",
  });
};

export default async function Agenda({ params }: Props) {
  const response = await getAgendaByDate(params.fecha);
  const res = await response.json();
  if (typeof res === "object" && "statusCode" in res) {
    throw new Error(res.message + " - statusCode " + res.statusCode);
  }
  const agenda: Agenda = res;
  console.log(agenda);
  return (
    <section>
      <div className="flex min-h-custom-body flex-col items-center justify-between p-16 lg:p-0 md:p-4 sm:p-8">
        <div>
          <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 sm:py-12 lg:max-w-7xl lg:px-8">
            <h2 className="text-2xl font-bold tracking-tight text-gray-900">
              Esta es la agenda con fecha {params.fecha}
            </h2>
            <AgendaForm agenda={agenda} />
          </div>
        </div>
      </div>
    </section>
  );
}
