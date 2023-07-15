import { ErrorPageProps } from "$fresh/server.ts";
import { Head } from "$fresh/runtime.ts";

export default function _500({ error }: ErrorPageProps) {
  let statusCode = 500;
  let errorCode = "Error interno del servidor"
  let message = "Internal Server Error";
  if (typeof error === "object" && error !== null && "statusCode" in error && typeof error.statusCode === "number") {
    statusCode = error.statusCode;
  }
  if (typeof error === "object" && error !== null && "message" in error && typeof error.message === "string") {
    message = error.message;
  }
  if (typeof error === "object" && error !== null && "error" in error && typeof error.error === "string") {
    errorCode = error.error;
  }
  return (
    <>
      <Head>
        <title>Error :{"("} | Reservas Spice Garden</title>
      </Head>
      <main class="grid min-h-full place-items-center bg-white px-6 py-24 sm:py-32 lg:px-8">
        <div class="text-center">
          <p class="text-base font-semibold text-red-600">{statusCode}</p>
          <h1 class="mt-4 text-3xl font-bold tracking-tight text-gray-900 sm:text-5xl">
            {errorCode}
          </h1>
          <p class="mt-6 text-base leading-7 text-gray-600">
            {message}
          </p>
          <div class="mt-10 flex items-center justify-center gap-x-6">
            <a
              href="/"
              class="rounded-md bg-red-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-red-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-600"
            >
              Go back home
            </a>
          </div>
        </div>
      </main>
    </>
  );
}
