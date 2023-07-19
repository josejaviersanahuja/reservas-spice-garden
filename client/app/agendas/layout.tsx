import { redirect } from "next/navigation";
import ProtectedRoutes from "../components/ProtectedRoutes";

async function redirecBySearch(formData: FormData) {
  "use server";
  let fechaI = formData.get("fechaI") as string;
  let fechaF = formData.get("fechaF") as string;

  if (!fechaI && !fechaF) {
    throw new Error("Fechas no válidas");
  }

  if (!fechaI) {
    redirect(`/agendas/${fechaF}`);
  } else if (!fechaF || fechaI === fechaF) {
    redirect(`/agendas/${fechaI}`);
  } else if (fechaI > fechaF) {
    [fechaI, fechaF] = [fechaF, fechaI];
  }

  redirect(`/agendas?fechaI=${fechaI}&fechaF=${fechaF}`);
}

interface Props {
  children: React.ReactNode;
}

export default function AgendasLayout({ children }: Props) {
  return (
    <div className="flex flex-col items-center justify-start min-h-custom-body">
      <form
        className="flex flex-col items-center md:flex-row sm:items-center sm:space-x-4"
        action={redirecBySearch}
      >
        <label htmlFor="fechaI" className="text-lg">
          Fecha Inicial
        </label>
        <input
          type="date"
          name="fechaI"
          id="fechaI"
          className="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:border-blue-500"
        />
        <label htmlFor="fechaF" className="text-lg">
          Fecha Final
        </label>
        <input
          type="date"
          name="fechaF"
          id="fechaF"
          className="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:border-blue-500"
        />
        <button
          type="submit"
          className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        >
          Buscar
        </button>
      </form>
      {children}
      <ProtectedRoutes />
    </div>
  );
}
