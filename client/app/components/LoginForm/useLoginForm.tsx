import { useState, useRef, FormEvent } from "react";
import { config } from "../../../config";
import { useRouter } from "next/navigation";

export default function useLoginForm() {
  const usernameRef = useRef<HTMLInputElement>(null);
  const passwordRef = useRef<HTMLInputElement>(null);
  const [errorMessage, setErrorMesage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  let router = useRouter();

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const username = usernameRef.current?.value;
    const password = passwordRef.current?.value;
    if (username && password) {
      setIsLoading(true);
      fetch(`${config.apiUrl}/auth/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          apikey: config.apiKey,
        },
        body: JSON.stringify({ username, password }),
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.statusCode) {
            throw data;
          }
          localStorage.setItem("access_token_sg", data.access_token);

          console.log("user", data);
          router.replace("/");
        })
        .catch((error) => {
          console.log("error", error);
          setErrorMesage(error.message + " - statusCode " + error.statusCode);
        })
        .finally(() => {
          usernameRef.current!.value = "";
          passwordRef.current!.value = "";
          setIsLoading(false);
        });
    }
  };

  return { isLoading, errorMessage, usernameRef, passwordRef, handleSubmit };
}
