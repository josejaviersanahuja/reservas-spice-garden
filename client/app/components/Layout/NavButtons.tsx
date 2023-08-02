"use client";
import { Fragment } from "react";
import Link from "next/link";
import { Popover, Transition } from "@headlessui/react";
import {
  ChevronDownIcon,
  NewspaperIcon,
  EyeIcon,
} from "@heroicons/react/24/outline";
import LoginButton from "./LoginButton";
interface Props {
  isToggle?: boolean;
}

export default function NavButtons({ isToggle }: Props) {
  const mainClass = isToggle
    ? "absolute top-20 right-3 flex flex-col gap-x-12 items-end lg:hidden"
    : "hidden lg:flex lg:gap-x-12";
  const loginClass = isToggle
    ? "absolute top-[198px] right-3 flex flex-col gap-x-12 items-end lg:hidden"
    : "hidden lg:flex lg:flex-1 lg:justify-end";

  const agendasSubmenu = [
    {
      name: "Nueva Agenda",
      description: "Crea una nueva agenda",
      href: "/agendas/nueva",
      icon: NewspaperIcon,
    },
    {
      name: "Buscar",
      description: "Encuentra alguna agenda que ya exista",
      href: "/agendas",
      icon: EyeIcon,
    },
  ];

  return (
    <>
      <div className={mainClass}>
        <Link
          href="/"
          className="flex items-center gap-x-1 text-sm font-semibold leading-6 text-gray-900"
          aria-expanded="false"
        >
          Inicio
        </Link>
        <Popover.Group className="hidden lg:flex lg:gap-x-12">
          <Popover className="relative">
            <Popover.Button className="flex items-center gap-x-1 text-sm font-semibold leading-6 text-gray-900">
              Agendas
              <ChevronDownIcon
                className="h-5 w-5 flex-none text-gray-400"
                aria-hidden="true"
              />
            </Popover.Button>

            <Transition
              as={Fragment}
              enter="transition ease-out duration-200"
              enterFrom="opacity-0 translate-y-1"
              enterTo="opacity-100 translate-y-0"
              leave="transition ease-in duration-150"
              leaveFrom="opacity-100 translate-y-0"
              leaveTo="opacity-0 translate-y-1"
            >
              <Popover.Panel className="absolute -left-8 top-full z-10 mt-3 w-screen max-w-md overflow-hidden rounded-3xl bg-white shadow-lg ring-1 ring-gray-900/5">
                <div className="p-4">
                  {agendasSubmenu.map((item) => (
                    <div
                      key={item.name}
                      className="group relative flex items-center gap-x-6 rounded-lg p-4 text-sm leading-6 hover:bg-gray-50"
                    >
                      <div className="flex h-11 w-11 flex-none items-center justify-center rounded-lg bg-gray-50 group-hover:bg-white">
                        <item.icon
                          className="h-6 w-6 text-gray-600 group-hover:text-indigo-600"
                          aria-hidden="true"
                        />
                      </div>
                      <div className="flex-auto">
                        <Link
                          href={item.href}
                          className="block font-semibold text-gray-900"
                        >
                          {item.name}
                          <span className="absolute inset-0" />
                        </Link>
                        <p className="mt-1 text-gray-600">{item.description}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </Popover.Panel>
            </Transition>
          </Popover>
        </Popover.Group>
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
