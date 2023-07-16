import { useRef, useState } from "preact/hooks";
import { userSignedIn } from "../utils/signals.ts";
import { config } from "../config.ts";
import { User } from "../schemas/users.ts";

export default function LoginForm() {
  const usernameRef = useRef<HTMLInputElement>(null);
  const passwordRef = useRef<HTMLInputElement>(null);
  const [errorMessage, setErrorMesage] = useState("");
  
  const handleSubmit = (
    event: Event,
  ) => {
    event.preventDefault();
    const username = usernameRef.current?.value;
    const password = passwordRef.current?.value;
    if (username && password) {
      fetch(`${config.apiUrl}/auth/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "apikey": config.akiKey,
        },
        body: JSON.stringify({ username, password }),
      }).then((response) => response.json())
        .then((data) => {
          if (data.statusCode) {
            throw data;
          }
          usernameRef.current!.value = "";
          passwordRef.current!.value = "";
          localStorage.setItem("access_token_sg", data.access_token);
          userSignedIn.value = data.user as User;
          console.log("user", userSignedIn);
          window.location.href = "/";
        })
        .catch((error) => {
          setErrorMesage(error.message + " - statusCode " + error.statusCode);
        });
    }
  };
  console.log("user", userSignedIn);
  
  return (
    <>
      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
        <form class="space-y-6" onSubmit={(e) => handleSubmit(e)}>
          <div>
            <label
              for="username"
              class="block text-sm font-medium leading-6 text-gray-900"
            >
              Usuario
            </label>
            <div class="mt-2">
              <input
                id="username"
                name="username"
                type="text"
                autocomplete="username"
                required
                ref={usernameRef}
                class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
              />
            </div>
          </div>

          <div>
            <div class="flex items-center justify-between">
              <label
                for="password"
                class="block text-sm font-medium leading-6 text-gray-900"
              >
                Contraseña
              </label>
            </div>
            <div class="mt-2">
              <input
                id="password"
                name="password"
                type="password"
                autocomplete="current-password"
                required
                ref={passwordRef}
                class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
              />
            </div>
          </div>

          <div>
            <button
              type="submit"
              class="flex w-full justify-center rounded-md bg-red-700 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-red-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            >
              Empezar
            </button>
          </div>
        </form>
        {errorMessage && (
          <div class="mt-4 text-center">
            <p class="text-base font-semibold text-red-600">{errorMessage}</p>
          </div>
        )}
      </div>
    </>
  );
}
