import { TIME_OPTIONS } from "@/schemas/AgendaSchema";

interface Props {
  hora: TIME_OPTIONS;
  defaultValue: number;
  isDisable?: boolean;
}

export default function AgendaHoraInput({ hora, defaultValue, isDisable = false }: Props) {
  return (
    <div className="sm:col-span-2">
      <label
        htmlFor={hora}
        className="block text-sm font-medium leading-6 text-gray-900"
      >
        {hora}
      </label>
      <div className="mt-2">
        <input
          type="number"
          name={hora}
          id={hora}
          disabled={isDisable}
          className="block w-16 rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
          defaultValue={defaultValue}
        />
      </div>
    </div>
  );
}
