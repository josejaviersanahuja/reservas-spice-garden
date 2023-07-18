import useAuthStore from "@/stores/authStore";
import { deleteCookie } from "cookies-next";

export default function useLogout() {
  const { isAuth, setUser } = useAuthStore((state) => state);
  const logout = () => {
    setUser(null);
    deleteCookie("access_token_sg");
  };
  return { isAuth, logout };
}
