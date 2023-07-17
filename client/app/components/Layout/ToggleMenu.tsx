"use client"
import { useState } from "react";
import NavButtons from "./NavButtons";

export default function ToggleMenu() {
  const [openMenu, setOpenMenu] = useState(false);

  return (
    <>
      <div className="flex lg:hidden">
        <button
          type="button"
          onClick={() => setOpenMenu(!openMenu)}
          className="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-gray-700"
        >
          <span className="sr-only">Open main menu</span>
          <svg
            className="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth="1.5"
            stroke="currentColor"
            aria-hidden="true"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
            />
          </svg>
        </button>
      </div>
      {openMenu && <NavButtons isToggle={true} />}
    </>
  );
}
