import { useEffect } from "preact/hooks";

export default function ProtectedRoute() {
  useEffect(() => {
    // get localstorage.access_token_sg and current path
    const access_token_sg = localStorage.getItem("access_token_sg");
    const current_path = window.location.pathname;
    // if access_token_sg is null and current_path !== /login, redirect to /login
    if (!access_token_sg && current_path !== "/login") {
      window.location.href = "/login";
    }
  }, []);
  return null;
}
