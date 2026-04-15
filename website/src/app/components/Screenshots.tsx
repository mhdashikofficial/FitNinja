"use client";

import { motion } from "framer-motion";

const screenshots = [
  {
    title: "AI Dashboard",
    subtitle: "Today's Protocol",
    gradient: "linear-gradient(135deg, #0a1628, #0d2847)",
    icon: "🤖",
    details: ["Personalized Plan", "Boxing Drills", "Macro Tracking"],
  },
  {
    title: "Boxing Arena",
    subtitle: "Real-Time Detection",
    gradient: "linear-gradient(135deg, #1a0a0a, #2d1010)",
    icon: "🥊",
    details: ["Pose AI Camera", "Punch Counter", "Speed Metrics"],
  },
  {
    title: "Shinobi Vault",
    subtitle: "Locked Archives",
    gradient: "linear-gradient(135deg, #0a1a1a, #0d2828)",
    icon: "🥷",
    details: ["Urban Stealth", "Mind Hack", "Rank System"],
  },
  {
    title: "Macro Engine",
    subtitle: "AI Nutrition",
    gradient: "linear-gradient(135deg, #0a0a1a, #101028)",
    icon: "🍗",
    details: ["Text-to-Calories", "Protein Tracking", "Meal History"],
  },
];

export default function Screenshots() {
  return (
    <section id="screenshots" className="section">
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.8 }}
        style={{ textAlign: "center", marginBottom: 60 }}
      >
        <span style={{
          fontSize: 11,
          letterSpacing: 4,
          color: "#3b82f6",
          fontWeight: 700,
        }}>
          INTERFACE PREVIEW
        </span>
        <h2 style={{
          fontFamily: "Orbitron, sans-serif",
          fontSize: "clamp(28px, 4vw, 48px)",
          fontWeight: 800,
          marginTop: 16,
        }}>
          Built Different<span style={{ color: "#3b82f6" }}>.</span>
        </h2>
      </motion.div>

      <div style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(260px, 1fr))",
        gap: 24,
      }}>
        {screenshots.map((s, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 50 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: i * 0.15 }}
          >
            <div className="phone-mockup" style={{ margin: "0 auto" }}>
              <div className="phone-screen" style={{ background: s.gradient }}>
                <div style={{ fontSize: 48, marginBottom: 20 }}>{s.icon}</div>
                <div style={{
                  fontFamily: "Orbitron, sans-serif",
                  fontWeight: 700,
                  fontSize: 16,
                  letterSpacing: 1,
                  marginBottom: 6,
                }}>
                  {s.title}
                </div>
                <div style={{
                  fontSize: 11,
                  color: "rgba(255,255,255,0.4)",
                  letterSpacing: 2,
                  marginBottom: 32,
                }}>
                  {s.subtitle}
                </div>
                <div style={{ width: "100%" }}>
                  {s.details.map((d, j) => (
                    <div key={j} style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 10,
                      padding: "10px 16px",
                      marginBottom: 8,
                      background: "rgba(255,255,255,0.03)",
                      borderRadius: 12,
                      border: "1px solid rgba(255,255,255,0.05)",
                      fontSize: 12,
                      color: "rgba(255,255,255,0.6)",
                    }}>
                      <div style={{
                        width: 6,
                        height: 6,
                        borderRadius: "50%",
                        background: i % 2 === 0 ? "#00e5ff" : "#3b82f6",
                      }} />
                      {d}
                    </div>
                  ))}
                </div>
              </div>
            </div>
            <p style={{
              textAlign: "center",
              marginTop: 16,
              fontFamily: "Orbitron, sans-serif",
              fontSize: 12,
              letterSpacing: 1,
              color: "rgba(255,255,255,0.3)",
            }}>
              {s.title}
            </p>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
