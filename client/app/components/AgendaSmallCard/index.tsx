import { Agenda } from "@/schemas/AgendaSchema";
import Link from "next/link";

interface Props {
  agenda: Agenda;
}

export default function AgendaSmallCard({ agenda }: Props) {
  const OPTIONS: { [key: string]: string } = {
    "Restaurante Mexicano": "bg-yellow-500",
    "Restaurante Italiano": "bg-green-500",
    "Restaurante Hindú": "bg-blue-500",
  };
  const bgColorByRest = (themeName: string) => {
    const bgColor = OPTIONS[themeName] ?? "bg-gray-500";
    return (
      "flex flex-col items-center justify-center text-center p-2 " + bgColor
    );
  };

  const fecha = new Date();
  const linedPastDays = (fechaString: string) => {
    const thisFecha = new Date(fechaString);
    let className = "text-sm text-gray-700";
    if (thisFecha < fecha) {
      className += " line-through";
    }
    return className;
  };
  return (
    <>
      <div
        key={agenda.fecha}
        className="group relative  border border-solid border-gray-800"
      >
        <div className="m-2 flex justify-between">
          <div className="min-h-full mr-2">
            <h3 className={linedPastDays(agenda.fecha)}>
              <Link href={`/agendas/${agenda.fecha}`}>
                <span aria-hidden="true" className="absolute inset-0" />
                {agenda.fecha}
              </Link>
            </h3>
            <p className="mt-1 text-sm text-gray-500">{agenda.themeName}</p>
          </div>
          <div className={bgColorByRest(agenda.themeName)}>
            <p className="text-sm font-medium text-gray-900">
              {agenda.themeName.split(" ")[0]}
            </p>
            <p className="text-sm font-medium text-gray-900">
              {agenda.themeName.split(" ")[1]}
            </p>
          </div>
        </div>
      </div>
    </>
  );
}
