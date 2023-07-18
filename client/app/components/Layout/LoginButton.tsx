"use client"
import Link from "next/link";
import useAuthStore from "@/stores/authStore";

export default function LoginButton() {
  const {isAuth, setUser} = useAuthStore((state) => state);
  if (isAuth) {
    return (
      <button
        type="button"
        className="text-sm font-semibold leading-6 text-gray-900"
        onClick={()=> setUser(null)}
      >
        Log out <span aria-hidden="true">&rarr;</span>
      </button>
    )  
  }
  return (
    <Link
          href="/login"
          className="text-sm font-semibold leading-6 text-gray-900"
        >
          Log in <span aria-hidden="true">&rarr;</span>
        </Link>
  )
}