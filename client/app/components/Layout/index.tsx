import Image from "next/image";

import NavButtons from "./NavButtons";
import ToggleMenu from "./ToggleMenu";

interface Props {
  children: React.ReactNode;
}

export default function Layout({ children }: Props) {
  return (
    <>
      <main>
        <header className="bg-white-100">
          <nav
            className="mx-auto flex max-w-7xl items-center justify-between p-6 lg:px-8"
            aria-label="Global"
          >
            <div className="flex lg:flex-1">
              <a href="/" className="-m-1.5 p-1.5">
                <span className="sr-only">Spice Garden Tenerife</span>
                <Image
                  className="h-12 w-auto"
                  src="/logo-mgm.png"
                  alt="logo"
                  height={48}
                  width={90}
                />
              </a>
            </div>
            <ToggleMenu />
            <NavButtons isToggle={false} />
          </nav>
        </header>
        {children}
        <footer className="bg-white border ">Footer</footer>
      </main>
    </>
  );
}
