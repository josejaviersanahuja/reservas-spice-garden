"use client";

import useAuthStore from "@/stores/authStore";
import { setCookie } from "cookies-next";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useEffect } from "react";

interface Props {}

export default function ProtectedRoutes({}: Props) {
  const isAuth = useAuthStore((state) => state.isAuth);
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const url = !searchParams.toString()
    ? `${pathname}`
    : `${pathname}?${searchParams.toString()}`;
  useEffect(() => {
    if (!isAuth) {
      setCookie("url", url, {
        expires: new Date(Date.now() + 1000 * 3)
      });
      router.push("/login");
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isAuth]);

  return null;
}
