import Link from "next/link";
import LoginButton from "./LoginButton";
interface Props {
  isToggle?: boolean;
}

export default function NavButtons({ isToggle }: Props) {
  const mainClass = isToggle
    ? "absolute top-20 right-3 flex flex-col gap-x-12 items-end lg:hidden"
    : "hidden lg:flex lg:gap-x-12";
  const loginClass = isToggle
    ? "absolute top-44 right-3 flex flex-col gap-x-12 items-end lg:hidden"
    : "hidden lg:flex lg:flex-1 lg:justify-end";
  return (
    <>
      <div className={mainClass}>
        <div className="relative">
          <button
            type="button"
            className="flex items-center gap-x-1 text-sm font-semibold leading-6 text-gray-900"
            aria-expanded="false"
          >
            Agendas del Mes
          </button>
        </div>

        <a href="#" className="text-sm font-semibold leading-6 text-gray-900">
          Reservas
        </a>
        <a href="#" className="text-sm font-semibold leading-6 text-gray-900">
          Reportes
        </a>
        <a href="#" className="text-sm font-semibold leading-6 text-gray-900">
          Demo
        </a>
      </div>
      <div className={loginClass}>
        <LoginButton />
      </div>
    </>
  );
}
