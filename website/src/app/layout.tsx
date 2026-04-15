import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "FitNinja — AI-Powered Fitness & Martial Arts Mastery",
  description: "The ultimate AI-driven fitness companion. Boxing techniques, Ninjutsu mastery, real-time pose detection, and personalized workout plans. Download now for Android.",
  keywords: ["fitness app", "boxing", "ninjutsu", "AI workout", "pose detection", "martial arts", "FitNinja"],
  authors: [{ name: "Ashik", url: "https://instagram.com/byyyy.ash" }],
  openGraph: {
    title: "FitNinja — AI-Powered Fitness & Martial Arts Mastery",
    description: "Train like a warrior. AI-powered fitness with boxing and ninjutsu mastery.",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Orbitron:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
      </head>
      <body>
        {children}
      </body>
    </html>
  );
}
