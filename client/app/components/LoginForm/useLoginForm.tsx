import { useState, useRef, FormEvent, useEffect } from "react";
import { useRouter } from "next/navigation";
import { setCookie, getCookie } from "cookies-next";
import { config } from "../../../config";
import useAuthStore from "@/stores/authStore";

export default function useLoginForm() {
  const usernameRef = useRef<HTMLInputElement>(null);
  const passwordRef = useRef<HTMLInputElement>(null);
  const [errorMessage, setErrorMesage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const {user, isAuth, setUser} = useAuthStore((state) => state);
  
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
          router.replace("/");
        })
        .catch((error) => {
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
      
      return
    } else {
      setIsLoading(true);
      fetch(`${config.apiUrl}/auth/login`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          apikey: config.apiKey,
          "Authorization": `Bearer ${token}`
        },
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.statusCode) {
            throw data;
          }
          
          setUser(data);
          router.replace("/");
        })
        .catch((error) => {
          setErrorMesage(error.message + " - statusCode " + error.statusCode);
        })
        .finally(() => {
          setIsLoading(false);
        });
    }

  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isAuth]);

  return { isLoading, errorMessage, usernameRef, passwordRef, handleSubmit };
}
