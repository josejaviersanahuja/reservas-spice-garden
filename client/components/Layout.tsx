import { FunctionalComponent } from "preact";
import { useSignal } from "@preact/signals";
import ToggledMenu from "../islands/ToggledMenu.tsx";
import NavButtons from "./NavButtons.tsx";

interface LayoutProps {
  user: any | null;
}

const Layout: FunctionalComponent<LayoutProps> = ({ user, children }) => {
  const openMenu = useSignal(false);
  return (
    <main class="min-h-full">
      <header class="bg-white">
        <nav
          class="mx-auto flex max-w-7xl items-center justify-between p-6 lg:px-8"
          aria-label="Global"
        >
          <div class="flex lg:flex-1">
            <a href="/" class="-m-1.5 p-1.5">
              <span class="sr-only">Spice Garden Tenerife</span>
              <img class="h-12 w-auto" src="/logo-mgm.png" alt="" />
            </a>
          </div>

          <ToggledMenu openMenu={openMenu} />

          <NavButtons isToggle={false} />
        </nav>
      </header>
      {children}
      <footer class="bg-white border ">
        Footer
      </footer>
    </main>
  );
};

export default Layout;