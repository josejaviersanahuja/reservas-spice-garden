import { Handlers } from "$fresh/server.ts";
import { Head } from "$fresh/runtime.ts";
import LoginForm from "../../islands/LoginForm.tsx";
import { useEffect } from "preact/hooks";

export interface LoginProps {
  API_URL: string;
  API_KEY: string;
}

export const handler: Handlers = {
  GET(req, ctx) {
    const API_KEY = Deno.env.get("API_KEY");
    const API_URL = Deno.env.get("API_URL");
    if (typeof API_KEY !== "string" || typeof API_URL !== "string") {
      console.log("API_KEY or API_URL is not defined");
    }
    return ctx.render({API_KEY, API_URL});
  },
};

export default function Login({API_KEY, API_URL}: LoginProps) {
  useEffect(() => {
    throw new Error("Error");
  }, []);
  return (
    <>
      <Head>
        <title>Login | Reservas Spice Garden</title>
      </Head>
      <main className="flex flex-col items-center">
        <div class="flex shadow w-full max-w-lg min-h-screen flex-col justify-center border border-gray-400 border-solid lg:px-8">
          <div class="sm:mx-auto sm:w-full sm:max-w-sm">
            <img
              class="mx-auto h-16 w-auto"
              src="/logo-mgm.png"
              alt="Your Company"
            />
            <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">
              Inicia Sesión
            </h2>
          </div>
          <LoginForm />
        </div>
      </main>
    </>
  );
}
