"use client";
import Link from "next/link";
import useLogout from "./useLogout";

export default function LoginButton() {
  const { isAuth, logout } = useLogout();

  if (isAuth) {
    return (
      <button
        type="button"
        className="text-sm font-semibold leading-6 text-gray-900"
        onClick={logout}
      >
        Log out <span aria-hidden="true">&rarr;</span>
      </button>
    );
  }
  return (
    <Link
      href="/login"
      className="text-sm font-semibold leading-6 text-gray-900"
    >
      Log in <span aria-hidden="true">&rarr;</span>
    </Link>
  );
}
