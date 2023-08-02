import { Agenda, TIME_OPTIONS } from "@/schemas/AgendaSchema";
import AgendaHoraInput from "./AgendaHoraInput";
import { isPastDate } from "@/utils/fechas";
import { RestaurantTheme } from "@/schemas/RestaurantThemes";
import { InformationCircleIcon } from "@heroicons/react/24/outline";

interface Props {
  agenda: Agenda;
  allThemes: RestaurantTheme[];
  isNewAgenda?: boolean;
}

export default function AgendaForm({
  agenda,
  allThemes,
  isNewAgenda = false,
}: Props) {
  const isInThePast = isPastDate(agenda.fecha);
  const selectDefault = allThemes.find(
    (theme) => theme.theme_name === agenda.themeName,
  );
  return (
    <form>
      <div className="space-y-12">
        <div className="border-b border-gray-900/10 pb-4">
          <h2 className="text-base font-semibold leading-7 text-gray-900">
            {agenda.themeName}
          </h2>
        </div>
        {isNewAgenda && (
          <div className="sm:col-span-2">
            <label
              htmlFor="fecha"
              className="block text-sm font-medium leading-6 text-gray-900"
            >
              Fecha
            </label>
            <div className="mt-2">
              <input
                type="date"
                name="fecha"
                id="fecha"
                className="block w-72 rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                min={new Date().toISOString().split("T")[0]}
              />
            </div>
          </div>
        )}
        <div className="sm:col-span-2">
          <label
            htmlFor="theme"
            className="block text-sm font-medium leading-6 text-gray-900"
          >
            Tema
          </label>
          <div className="mt-2">
            <select
              name={"theme"}
              id={"theme"}
              disabled={isInThePast}
              className="block w-72 rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
              defaultValue={selectDefault?.id ?? 0}
            >
              <option value={0}>Selecciona un tema</option>
              {allThemes.map((theme) => (
                <option key={theme.id} value={theme.id}>
                  {theme.theme_name}
                </option>
              ))}
            </select>
          </div>
        </div>
        <div className="border-b border-gray-900/10 pb-12">
          <div className="mt-10 grid grid-cols-3 gap-x-6 gap-y-8 sm:grid-cols-12">
            <AgendaHoraInput
              hora={TIME_OPTIONS.t1900}
              isDisable={isInThePast}
              defaultValue={agenda["19:00"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t1915}
              isDisable={isInThePast}
              defaultValue={agenda["19:15"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t1930}
              isDisable={isInThePast}
              defaultValue={agenda["19:30"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t1945}
              isDisable={isInThePast}
              defaultValue={agenda["19:45"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2000}
              isDisable={isInThePast}
              defaultValue={agenda["20:00"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2015}
              isDisable={isInThePast}
              defaultValue={agenda["20:15"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2030}
              isDisable={isInThePast}
              defaultValue={agenda["20:30"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2045}
              isDisable={isInThePast}
              defaultValue={agenda["20:45"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2100}
              isDisable={isInThePast}
              defaultValue={agenda["21:00"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2115}
              isDisable={isInThePast}
              defaultValue={agenda["21:15"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2130}
              isDisable={isInThePast}
              defaultValue={agenda["21:30"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2145}
              isDisable={isInThePast}
              defaultValue={agenda["21:45"]}
            />
            <AgendaHoraInput
              hora={TIME_OPTIONS.t2200}
              isDisable={isInThePast}
              defaultValue={agenda["22:00"] ?? 0}
            />
          </div>
        </div>
      </div>
      <div className="mt-6 flex items-center justify-end gap-x-6">
        {isInThePast && (
          <p className="flex items-center text-red-500">
            <InformationCircleIcon className="w-8 inline" /> No se puede
            modificar una agenda del pasado
          </p>
        )}
        <button
          type="button"
          className="text-sm font-semibold leading-6 text-gray-900"
        >
          Cancel
        </button>
        <button
          type="submit"
          disabled={isInThePast}
          className="rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          Save
        </button>
      </div>
    </form>
  );
}
