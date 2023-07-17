import "./globals.css";
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import { NavigationEvents } from "./components/NavigationEvents";
import { Suspense } from "react";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Reservas Spice Garden",
  description: "Reservas a Spice Garden",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="es">
      <body className={inter.className} id="body">
        {children}
        <Suspense fallback={null}>
          <NavigationEvents />
        </Suspense>
      </body>
    </html>
  );
}
