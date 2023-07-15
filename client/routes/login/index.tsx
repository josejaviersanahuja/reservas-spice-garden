import { Head } from "$fresh/runtime.ts";
import LoginForm from "../../islands/LoginForm.tsx";


export default function Login() {

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
