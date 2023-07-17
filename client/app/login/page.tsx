import Image from "next/image";
import LoginForm from "../components/LoginForm";

export default function Login() {
  return (
    <main className="flex flex-col items-center">
      <div className="flex shadow w-full max-w-lg min-h-screen flex-col justify-center border border-gray-400 border-solid lg:px-8">
        <div className="sm:mx-auto sm:w-full sm:max-w-sm">
          <Image
            className="mx-auto h-16 w-auto"
            src="/logo-mgm.png"
            alt="Your Company"
            height={64}
            width={120}
          />
          <h2 className="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">
            Inicia Sesión
          </h2>
          <LoginForm />
        </div>
      </div>
    </main>
  );
}
