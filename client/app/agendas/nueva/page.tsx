import AgendaForm from "@/app/components/AgendaForm";
import { Agenda } from "@/schemas/AgendaSchema";
import { RestaurantTheme } from "@/schemas/RestaurantThemes";

interface Props {
  params: {
    fecha: string;
  };
}

const emptyAgenda: Agenda = {
  fecha: "",
  "19:00": 0,
  "19:15": 0,
  "19:30": 0,
  "19:45": 0,
  "20:00": 0,
  "20:15": 0,
  "20:30": 0,
  "20:45": 0,
  "21:00": 0,
  "21:15": 0,
  "21:30": 0,
  "21:45": 0,
  "22:00": 0,
  imageUrl: "",
  themeName: "",
};

const getAllThemes = async () => {
  return await fetch(process.env.API_URL + `/restaurant-themes`, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      apikey: process.env.API_KEY ?? "",
    },
    cache: "no-cache",
  });
};

export default async function NuevaAgenda({ params }: Props) {
  const themes = await getAllThemes();
  const themesRes = await themes.json();
  if (typeof themesRes === "object" && "statusCode" in themesRes) {
    throw new Error(
      themesRes.message + " - statusCode " + themesRes.statusCode,
    );
  }
  const agenda: Agenda = emptyAgenda;
  const allThemes: RestaurantTheme[] = themesRes;

  return (
    <section>
      <div className="flex min-h-custom-body flex-col items-center justify-between p-16 lg:p-0 md:p-4 sm:p-8">
        <div>
          <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 sm:py-12 lg:max-w-7xl lg:px-8">
            <h2 className="text-2xl font-bold tracking-tight text-gray-900">
              Nueva Agenda
            </h2>
            <AgendaForm agenda={agenda} allThemes={allThemes} isNewAgenda />
          </div>
        </div>
      </div>
    </section>
  );
}
