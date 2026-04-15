"use client";

import { motion } from "framer-motion";

export default function Download() {
  return (
    <section className="section" style={{ textAlign: "center", paddingBottom: 80 }}>
      <motion.div
        initial={{ opacity: 0, y: 40 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.8 }}
      >
        {/* Glow orb */}
        <div style={{
          width: 200,
          height: 200,
          borderRadius: "50%",
          background: "radial-gradient(circle, rgba(0,229,255,0.15), transparent 70%)",
          margin: "0 auto 40px",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
        }}>
          <div style={{
            width: 100,
            height: 100,
            borderRadius: "50%",
            background: "radial-gradient(circle, rgba(0,229,255,0.3), transparent 70%)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontSize: 48,
          }}
          className="animate-pulse-glow"
          >
            ⚡
          </div>
        </div>

        <span style={{
          fontSize: 11,
          letterSpacing: 4,
          color: "#00e5ff",
          fontWeight: 700,
        }}>
          READY TO TRAIN?
        </span>

        <h2 style={{
          fontFamily: "Orbitron, sans-serif",
          fontSize: "clamp(28px, 5vw, 56px)",
          fontWeight: 900,
          marginTop: 16,
          marginBottom: 16,
        }}>
          Download <span style={{ color: "#00e5ff" }}>FitNinja</span>
        </h2>

        <p style={{
          color: "rgba(255,255,255,0.4)",
          maxWidth: 500,
          margin: "0 auto 40px",
          fontSize: 15,
          lineHeight: 1.7,
        }}>
          Free. Offline-capable. No ads. Just pure performance.
          <br />Available for Android devices.
        </p>

        <a href="https://github.com/mhdashikofficial/FitNinja/releases/latest/download/FitNinja.apk" className="download-btn" style={{ fontSize: 18, padding: "20px 48px" }}>
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
            <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4" />
            <polyline points="7 10 12 15 17 10" />
            <line x1="12" y1="15" x2="12" y2="3" />
          </svg>
          DOWNLOAD APK
        </a>

        <p style={{
          marginTop: 16,
          fontSize: 12,
          color: "rgba(255,255,255,0.2)",
        }}>
          v1.0 • ~88MB • Android 5.0+
        </p>
      </motion.div>
    </section>
  );
}
