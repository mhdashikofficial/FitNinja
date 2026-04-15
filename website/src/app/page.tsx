"use client";

import { useEffect, useRef, useState } from "react";
import { motion, useScroll, useTransform } from "framer-motion";
import ParticleField from "./components/ParticleField";
import HeroScene from "./components/HeroScene";
import Features from "./components/Features";
import Screenshots from "./components/Screenshots";
import Stats from "./components/Stats";
import Download from "./components/Download";
import Footer from "./components/Footer";

export default function Home() {
  const { scrollYProgress } = useScroll();
  const navOpacity = useTransform(scrollYProgress, [0, 0.05], [0, 1]);

  return (
    <main>
      <ParticleField />

      {/* NAVBAR */}
      <motion.nav className="navbar" style={{ opacity: navOpacity }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
          <div style={{
            width: 36, height: 36,
            background: "linear-gradient(135deg, #00e5ff, #3b82f6)",
            borderRadius: 10,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontWeight: 900,
            fontSize: 14,
            color: "#000"
          }}>FN</div>
          <span style={{ fontFamily: "Orbitron, sans-serif", fontWeight: 700, fontSize: 18, letterSpacing: 2 }}>FITNINJA</span>
        </div>
        <div style={{ display: "flex", gap: 32, alignItems: "center" }}>
          <a href="#features" style={{ color: "rgba(255,255,255,0.5)", textDecoration: "none", fontSize: 13, letterSpacing: 1, fontWeight: 500, transition: "color 0.3s" }}>FEATURES</a>
          <a href="#screenshots" style={{ color: "rgba(255,255,255,0.5)", textDecoration: "none", fontSize: 13, letterSpacing: 1, fontWeight: 500 }}>PREVIEW</a>
          <a href="https://github.com/mhdashikofficial/FitNinja/releases/latest/download/FitNinja.apk" className="download-btn" style={{ padding: "10px 24px", fontSize: 12 }}>
            DOWNLOAD
          </a>
        </div>
      </motion.nav>

      {/* HERO */}
      <HeroScene />

      {/* STATS */}
      <Stats />

      {/* FEATURES */}
      <Features />

      {/* SCREENSHOTS */}
      <Screenshots />

      {/* DOWNLOAD CTA */}
      <Download />

      {/* FOOTER */}
      <Footer />
    </main>
  );
}
