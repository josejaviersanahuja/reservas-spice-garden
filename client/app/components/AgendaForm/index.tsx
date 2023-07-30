import { Agenda, TIME_OPTIONS } from "@/schemas/AgendaSchema";
import AgendaHoraInput from "./AgendaHoraInput";
import { isPastDate } from "@/utils/fechas";

interface Props {
  agenda: Agenda;
}

export default function AgendaForm({ agenda }: Props) {
  const isInThePast = isPastDate(agenda.fecha);
  return (
    <form>
      <div className="space-y-12">
        <div className="border-b border-gray-900/10 pb-4">
          <h2 className="text-base font-semibold leading-7 text-gray-900">
            {agenda.themeName}
          </h2>
        </div>
        {/* TODO input para cambiar el theme */}
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
