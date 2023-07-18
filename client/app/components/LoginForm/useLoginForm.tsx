import { useState, useRef, FormEvent, useEffect } from "react";
import { useRouter } from "next/navigation";
import { setCookie, getCookie } from "cookies-next";
import { Zoom, toast } from "react-toastify";

import { config } from "../../../config";
import useAuthStore from "@/stores/authStore";

export default function useLoginForm() {
  const usernameRef = useRef<HTMLInputElement>(null);
  const passwordRef = useRef<HTMLInputElement>(null);
  const [errorMessage, setErrorMesage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const { isAuth, setUser } = useAuthStore((state) => state);
  const notifySuccess = (message: string) =>
    toast(message, {
      position: "bottom-right",
      theme: "dark",
      transition: Zoom,
      autoClose: 2300,
    });
  const notifyError = (message: string) =>
    toast.error(message, {
      position: "bottom-right",
      theme: "dark",
      transition: Zoom,
      autoClose: 4000,
    });

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
          setCookie("access_token_sg", data.access_token, {
            expires: new Date(Date.now() + 1000 * 60 * 60 * 24),
          });
          setUser(data.user);
          notifySuccess("Bienvenido " + data.user.username);
          router.replace("/");
        })
        .catch((error) => {
          notifyError(error.message + " - statusCode " + error.statusCode);
          setErrorMesage(error.message + " - statusCode " + error.statusCode);
        })
        .finally(() => {
          usernameRef.current!.value = "";
          passwordRef.current!.value = "";
          setIsLoading(false);
        });
    }
  };

  useEffect(() => {
    if (isAuth) {
      router.replace("/");
    }
    const token = getCookie("access_token_sg");
    if (!token) {
      return;
    } else {
      setIsLoading(true);
      fetch(`${config.apiUrl}/auth/login`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          apikey: config.apiKey,
          Authorization: `Bearer ${token}`,
        },
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.statusCode) {
            throw data;
          }

          setUser(data);
          notifySuccess("Login Automático: Bienvenido " + data.username);
          router.replace("/");
        })
        .catch((error) => {
          notifyError(error.message + " - statusCode " + error.statusCode);
          setErrorMesage(error.message + " - statusCode " + error.statusCode);
        })
        .finally(() => {
          setIsLoading(false);
        });
    }

    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return { isLoading, errorMessage, usernameRef, passwordRef, handleSubmit };
}
