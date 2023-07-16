interface Props {
  isToggle?: boolean;
}

export default function NavButtons({isToggle}: Props) {
  const mainClass = isToggle ? "absolute top-20 right-3 flex flex-col gap-x-12 items-end" : "hidden lg:flex lg:gap-x-12";
  const loginClass = isToggle ? "absolute top-44 right-3 flex flex-col gap-x-12 items-end" : "hidden lg:flex lg:flex-1 lg:justify-end";
  return (
    <>
      <div class={mainClass}>
        <div class="relative">
          <button
            type="button"
            class="flex items-center gap-x-1 text-sm font-semibold leading-6 text-gray-900"
            aria-expanded="false"
          >
            Agendas del Mes
          </button>
        </div>

        <a href="#" class="text-sm font-semibold leading-6 text-gray-900">
          Reservas
        </a>
        <a href="#" class="text-sm font-semibold leading-6 text-gray-900">
          Reportes
        </a>
        <a href="#" class="text-sm font-semibold leading-6 text-gray-900">
          Demo
        </a>
      </div>
      <div class={loginClass}>
        <a
          href="/login"
          class="text-sm font-semibold leading-6 text-gray-900"
        >
          Log in <span aria-hidden="true">&rarr;</span>
        </a>
      </div>
    </>
  );
}
