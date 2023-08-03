import AgendaForm from "@/app/components/AgendaForm";
import { Agenda } from "@/schemas/AgendaSchema";
import { RestaurantTheme } from "@/schemas/RestaurantThemes";
import { notFound } from "next/navigation";

const emptyCustomAgenda: Agenda = {
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

const emptyAgendaVerano: Agenda = {
  fecha: "",
  "19:00": 0,
  "19:15": 0,
  "19:30": 0,
  "19:45": 6,
  "20:00": 8,
  "20:15": 6,
  "20:30": 6,
  "20:45": 8,
  "21:00": 8,
  "21:15": 8,
  "21:30": 6,
  "21:45": 6,
  "22:00": 2,
  imageUrl: "",
  themeName: "",
};

const emptyAgendaNormal: Agenda = {
  fecha: "",
  "19:00": 10,
  "19:15": 8,
  "19:30": 6,
  "19:45": 0,
  "20:00": 4,
  "20:15": 6,
  "20:30": 4,
  "20:45": 10,
  "21:00": 4,
  "21:15": 4,
  "21:30": 6,
  "21:45": 2,
  "22:00": 0,
  imageUrl: "",
  themeName: "",
};

const CHOOSE_AGENDA: { [key: string]: Agenda } = {
  custom: emptyCustomAgenda,
  verano: emptyAgendaVerano,
  normal: emptyAgendaNormal,
};

const getAllThemes = async (agendaType: string) => {
  if (!["custom", "verano", "normal"].includes(agendaType)) {
    console.log("QUE VEMO S¿¿S AQUI", agendaType);
    notFound();
  }

  return await fetch(process.env.API_URL + `/restaurant-themes`, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      apikey: process.env.API_KEY ?? "",
    },
    cache: "no-cache",
  });
};

interface Props {
  params: {
    type: "custom" | "verano" | "normal";
  };
}

export default async function CreateAgenda({ params }: Props) {
  const themes = await getAllThemes(params.type);
  const themesRes = await themes.json();
  if (typeof themesRes === "object" && "statusCode" in themesRes) {
    throw new Error(
      themesRes.message + " - statusCode " + themesRes.statusCode,
    );
  }
  if (!["custom", "verano", "normal"].includes(params.type)) {
    throw new Error("Page Not Found" + " - statusCode " + "404");
  }
  const agenda: Agenda = CHOOSE_AGENDA[params.type];
  const allThemes: RestaurantTheme[] = themesRes;
  console.log("AQUI QUE VEREMOS", params);

  return (
    <>
      <div>
        <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 sm:py-12 lg:max-w-7xl lg:px-8">
          <h2 className="text-2xl font-bold tracking-tight text-gray-900">
            Nueva Agenda
          </h2>
          <AgendaForm agenda={agenda} allThemes={allThemes} isNewAgenda />
        </div>
      </div>
    </>
  );
}
