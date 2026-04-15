"use client";

import { motion } from "framer-motion";

const features = [
  {
    icon: "🤖",
    title: "AI Workout Engine",
    description: "Daily personalized plans powered by Llama 3.1 70B. Adapts to your body, equipment, and schedule with military-grade precision.",
    accent: "#00e5ff",
  },
  {
    icon: "🥊",
    title: "Real-Time Boxing",
    description: "ML pose detection tracks your punches, speed, and form in real-time using your phone camera. Train like a champion.",
    accent: "#3b82f6",
  },
  {
    icon: "🥷",
    title: "Ninjutsu Mastery",
    description: "50+ classified tutorials — Urban Stealth, Tactical Flow, Neural Overclock, and Modern Genjutsu. Password-protected archives.",
    accent: "#00e5ff",
  },
  {
    icon: "📊",
    title: "Macro Intelligence",
    description: "AI-powered nutrition tracking. Describe your meal in plain text and get instant calorie + protein analysis. Zero manual input.",
    accent: "#3b82f6",
  },
  {
    icon: "🎯",
    title: "Progressive Mastery",
    description: "Rank up from Initiate to Shinobi Ghost. Track your progress across Basic, Intermediate, and Mastery level techniques.",
    accent: "#00e5ff",
  },
  {
    icon: "🔒",
    title: "Secure Archives",
    description: "Military-grade content gating. Restricted ninjutsu sections require master code authentication. Mind Hack modules include ethical safeguards.",
    accent: "#3b82f6",
  },
];

const container = {
  hidden: {},
  visible: {
    transition: { staggerChildren: 0.1 },
  },
};

const item = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: "easeOut" } },
};

export default function Features() {
  return (
    <section id="features" className="section">
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.8 }}
        style={{ textAlign: "center", marginBottom: 20 }}
      >
        <span style={{
          fontSize: 11,
          letterSpacing: 4,
          color: "#00e5ff",
          fontWeight: 700,
          textTransform: "uppercase",
        }}>
          WEAPON SYSTEMS
        </span>
        <h2 style={{
          fontFamily: "Orbitron, sans-serif",
          fontSize: "clamp(28px, 4vw, 48px)",
          fontWeight: 800,
          marginTop: 16,
          lineHeight: 1.2,
        }}>
          Your Arsenal<span style={{ color: "#00e5ff" }}>.</span>
        </h2>
        <p style={{ color: "rgba(255,255,255,0.4)", maxWidth: 500, margin: "16px auto 0", lineHeight: 1.7 }}>
          Every feature engineered for peak performance.
        </p>
      </motion.div>

      <motion.div
        className="feature-grid"
        variants={container}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true, margin: "-100px" }}
      >
        {features.map((f, i) => (
          <motion.div
            key={i}
            variants={item}
            className="glass-card"
            style={{
              padding: 32,
              cursor: "default",
              transition: "all 0.4s ease",
            }}
          >
            <div style={{
              width: 56,
              height: 56,
              borderRadius: 16,
              background: `linear-gradient(135deg, ${f.accent}15, ${f.accent}08)`,
              border: `1px solid ${f.accent}20`,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              fontSize: 28,
              marginBottom: 20,
            }}>
              {f.icon}
            </div>
            <h3 style={{
              fontFamily: "Orbitron, sans-serif",
              fontSize: 16,
              fontWeight: 700,
              marginBottom: 12,
              letterSpacing: 0.5,
            }}>
              {f.title}
            </h3>
            <p style={{
              color: "rgba(255,255,255,0.4)",
              fontSize: 14,
              lineHeight: 1.7,
            }}>
              {f.description}
            </p>
          </motion.div>
        ))}
      </motion.div>
    </section>
  );
}
