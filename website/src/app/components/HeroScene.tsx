"use client";

import { Canvas, useFrame } from "@react-three/fiber";
import { useRef, Suspense } from "react";
import { Float, MeshDistortMaterial, Sphere } from "@react-three/drei";
import * as THREE from "three";
import { motion } from "framer-motion";

function GlowingSphere() {
  const meshRef = useRef<THREE.Mesh>(null);
  useFrame(({ clock }) => {
    if (meshRef.current) {
      meshRef.current.rotation.y = clock.getElapsedTime() * 0.15;
      meshRef.current.rotation.x = Math.sin(clock.getElapsedTime() * 0.1) * 0.1;
    }
  });

  return (
    <Float speed={2} rotationIntensity={0.3} floatIntensity={1}>
      <Sphere ref={meshRef} args={[1.8, 64, 64]} position={[0, 0, 0]}>
        <MeshDistortMaterial
          color="#00e5ff"
          emissive="#003344"
          emissiveIntensity={0.5}
          roughness={0.2}
          metalness={0.9}
          distort={0.35}
          speed={2}
          transparent
          opacity={0.7}
        />
      </Sphere>
    </Float>
  );
}

function EnergyRing({ radius, speed, color }: { radius: number; speed: number; color: string }) {
  const ringRef = useRef<THREE.Mesh>(null);
  useFrame(({ clock }) => {
    if (ringRef.current) {
      ringRef.current.rotation.x = clock.getElapsedTime() * speed;
      ringRef.current.rotation.z = clock.getElapsedTime() * speed * 0.5;
    }
  });

  return (
    <mesh ref={ringRef}>
      <torusGeometry args={[radius, 0.02, 16, 100]} />
      <meshStandardMaterial color={color} emissive={color} emissiveIntensity={2} transparent opacity={0.6} />
    </mesh>
  );
}

function FloatingParticles() {
  const pointsRef = useRef<THREE.Points>(null);
  const count = 200;
  const positions = new Float32Array(count * 3);
  
  for (let i = 0; i < count; i++) {
    positions[i * 3] = (Math.random() - 0.5) * 10;
    positions[i * 3 + 1] = (Math.random() - 0.5) * 10;
    positions[i * 3 + 2] = (Math.random() - 0.5) * 10;
  }

  useFrame(({ clock }) => {
    if (pointsRef.current) {
      pointsRef.current.rotation.y = clock.getElapsedTime() * 0.05;
    }
  });

  return (
    <points ref={pointsRef}>
      <bufferGeometry>
        <bufferAttribute
          attach="attributes-position"
          args={[positions, 3]}
        />
      </bufferGeometry>
      <pointsMaterial size={0.03} color="#00e5ff" transparent opacity={0.6} sizeAttenuation />
    </points>
  );
}

export default function HeroScene() {
  return (
    <section style={{
      position: "relative",
      height: "100vh",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      overflow: "hidden",
    }}>
      {/* 3D Background */}
      <div style={{ position: "absolute", inset: 0, zIndex: 0 }}>
        <Canvas camera={{ position: [0, 0, 5], fov: 60 }}>
          <ambientLight intensity={0.3} />
          <pointLight position={[5, 5, 5]} intensity={1} color="#00e5ff" />
          <pointLight position={[-5, -5, 5]} intensity={0.5} color="#3b82f6" />
          <Suspense fallback={null}>
            <GlowingSphere />
            <EnergyRing radius={2.8} speed={0.3} color="#00e5ff" />
            <EnergyRing radius={3.2} speed={-0.2} color="#3b82f6" />
            <EnergyRing radius={3.6} speed={0.15} color="#0088aa" />
            <FloatingParticles />
          </Suspense>
        </Canvas>
      </div>

      {/* Radial gradient overlay */}
      <div style={{
        position: "absolute",
        inset: 0,
        background: "radial-gradient(ellipse at center, transparent 30%, #050507 75%)",
        zIndex: 1,
        pointerEvents: "none"
      }} />

      {/* Content */}
      <div style={{ position: "relative", zIndex: 2, textAlign: "center", maxWidth: 800, padding: "0 20px" }}>
        <motion.div
          initial={{ opacity: 0, y: 40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 0.3 }}
        >
          <div style={{
            display: "inline-block",
            padding: "8px 20px",
            borderRadius: 100,
            border: "1px solid rgba(0, 229, 255, 0.2)",
            background: "rgba(0, 229, 255, 0.05)",
            marginBottom: 24,
            fontSize: 12,
            letterSpacing: 3,
            color: "#00e5ff",
            fontWeight: 600,
          }}>
            ⚡ AI-POWERED TRAINING SYSTEM
          </div>
        </motion.div>

        <motion.h1
          initial={{ opacity: 0, y: 50 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 0.5 }}
          style={{
            fontFamily: "Orbitron, sans-serif",
            fontSize: "clamp(40px, 7vw, 80px)",
            fontWeight: 900,
            lineHeight: 1.1,
            marginBottom: 24,
          }}
        >
          <span className="glow-text">FIT</span>
          <span style={{ color: "#00e5ff" }} className="glow-text">NINJA</span>
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 0.7 }}
          style={{
            fontSize: "clamp(14px, 2vw, 18px)",
            color: "rgba(255,255,255,0.5)",
            lineHeight: 1.8,
            maxWidth: 600,
            margin: "0 auto 40px",
          }}
        >
          Train like a warrior. AI-generated workout plans, real-time boxing pose detection,
          50+ martial arts tutorials — from elite boxing to classified ninjutsu mastery.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 0.9 }}
          style={{ display: "flex", gap: 16, justifyContent: "center", flexWrap: "wrap" }}
        >
          <a href="https://github.com/mhdashikofficial/FitNinja/releases/latest/download/FitNinja.apk" className="download-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4" />
              <polyline points="7 10 12 15 17 10" />
              <line x1="12" y1="15" x2="12" y2="3" />
            </svg>
            DOWNLOAD APK
          </a>
          <a href="#features" style={{
            padding: "18px 40px",
            border: "1px solid rgba(255,255,255,0.1)",
            borderRadius: 16,
            color: "rgba(255,255,255,0.6)",
            textDecoration: "none",
            fontWeight: 600,
            fontSize: 14,
            letterSpacing: 1,
            transition: "all 0.3s",
          }}>
            EXPLORE →
          </a>
        </motion.div>
      </div>

      {/* Bottom Gradient Fade */}
      <div style={{
        position: "absolute",
        bottom: 0,
        left: 0,
        right: 0,
        height: 200,
        background: "linear-gradient(to top, #050507, transparent)",
        zIndex: 3,
        pointerEvents: "none"
      }} />
    </section>
  );
}
