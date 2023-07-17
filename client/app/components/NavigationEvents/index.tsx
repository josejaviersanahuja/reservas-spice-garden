"use client";

import { useEffect } from "react";
import { usePathname, useSearchParams } from "next/navigation";

export function NavigationEvents() {
  const pathname = usePathname();
  const searchParams = useSearchParams();

  useEffect(() => {
    const url = `${pathname}?${searchParams}`;
    console.log(url);
    // You can now use the current URL
    // ...
    if ("startViewTransition" in document) {
      const transitionContainer = document.getElementById("body");
      transitionContainer?.classList.add("hide-content");
      document.startViewTransition(() => {
        transitionContainer?.classList.remove("hide-content");
      });
    }
  }, [pathname, searchParams]);

  return null;
}
