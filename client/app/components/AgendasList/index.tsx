import { Agenda } from "@/schemas/AgendaSchema";
import AgendaSmallCard from "../AgendaSmallCard";

interface Props {
  agendas: Agenda[];
  title: string;
}

export default function AgendasList({ agendas, title }: Props) {
  return (
    <div className="flex min-h-custom-body flex-col items-center justify-between p-16 lg:p-0 md:p-4 sm:p-8">
      <div>
        <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 sm:py-12 lg:max-w-7xl lg:px-8">
          <h2 className="text-2xl font-bold tracking-tight text-gray-900">
            {title}
          </h2>

          <div className="mt-6 grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3 xl:gap-x-8 xl:grid-cols-4">
            {agendas.map((agenda) => (
              <AgendaSmallCard key={agenda.fecha} agenda={agenda} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
