import { create } from "zustand";

// Custom types for theme
import { User } from "../schemas/UserSchema";

interface AuthState {
  isAuth: boolean;
  user: null | User;
  setUser: (user: User | null) => void;
}

const useAuthStore = create<AuthState>((set) => ({
  isAuth: false,
  user: null,
  setUser: (user) => set({ user, isAuth: Boolean(user) }),
}));

export default useAuthStore;
