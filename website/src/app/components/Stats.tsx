"use client";

import { motion, useInView } from "framer-motion";
import { useRef, useEffect, useState } from "react";

function AnimatedCounter({ target, suffix = "" }: { target: number; suffix?: string }) {
  const [count, setCount] = useState(0);
  const ref = useRef<HTMLDivElement>(null);
  const isInView = useInView(ref, { once: true });

  useEffect(() => {
    if (!isInView) return;
    let current = 0;
    const step = target / 60;
    const timer = setInterval(() => {
      current += step;
      if (current >= target) {
        setCount(target);
        clearInterval(timer);
      } else {
        setCount(Math.floor(current));
      }
    }, 16);
    return () => clearInterval(timer);
  }, [isInView, target]);

  return (
    <div ref={ref} className="stat-number">
      {count}{suffix}
    </div>
  );
}

const stats = [
  { number: 50, suffix: "+", label: "TRAINING MODULES" },
  { number: 7, suffix: "", label: "DISCIPLINE CATEGORIES" },
  { number: 4, suffix: "", label: "MASTERY RANKS" },
  { number: 100, suffix: "%", label: "OFFLINE CAPABLE" },
];

export default function Stats() {
  return (
    <section className="section" style={{ paddingTop: 60, paddingBottom: 60 }}>
      <motion.div
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: true }}
        transition={{ duration: 1 }}
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
          gap: 40,
          textAlign: "center",
        }}
      >
        {stats.map((s, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: i * 0.1 }}
          >
            <AnimatedCounter target={s.number} suffix={s.suffix} />
            <div style={{
              fontSize: 11,
              letterSpacing: 3,
              color: "rgba(255,255,255,0.3)",
              marginTop: 8,
              fontWeight: 600,
            }}>
              {s.label}
            </div>
          </motion.div>
        ))}
      </motion.div>
    </section>
  );
}
