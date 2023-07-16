import { signal, Signal } from "@preact/signals";
import { User } from "../schemas/users.ts";

export const userSignedIn: Signal<User | null> = signal(null);