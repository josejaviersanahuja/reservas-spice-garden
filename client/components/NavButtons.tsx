interface Props {
  isToggle?: boolean;
}

export default function NavButtons({isToggle}: Props) {
  const clase = isToggle ? "absolute top-24 right-3 flex flex-col gap-x-12" : "hidden lg:flex lg:gap-x-12";
  return (
    <>
      <div class={clase}>
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
      <div class="hidden lg:flex lg:flex-1 lg:justify-end">
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
