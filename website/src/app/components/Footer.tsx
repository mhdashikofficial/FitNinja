"use client";

export default function Footer() {
  return (
    <footer className="footer">
      <div style={{ maxWidth: 800, margin: "0 auto" }}>
        {/* Logo */}
        <div style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          gap: 12,
          marginBottom: 24,
        }}>
          <div style={{
            width: 40,
            height: 40,
            background: "linear-gradient(135deg, #00e5ff, #3b82f6)",
            borderRadius: 12,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontWeight: 900,
            fontSize: 16,
            color: "#000",
          }}>FN</div>
          <span style={{
            fontFamily: "Orbitron, sans-serif",
            fontWeight: 700,
            fontSize: 20,
            letterSpacing: 2,
          }}>FITNINJA</span>
        </div>

        {/* Links */}
        <div style={{
          display: "flex",
          justifyContent: "center",
          gap: 32,
          marginBottom: 32,
          flexWrap: "wrap",
        }}>
          <a href="#features" style={{ color: "rgba(255,255,255,0.3)", textDecoration: "none", fontSize: 13, letterSpacing: 1, transition: "color 0.3s" }}>
            FEATURES
          </a>
          <a href="#screenshots" style={{ color: "rgba(255,255,255,0.3)", textDecoration: "none", fontSize: 13, letterSpacing: 1 }}>
            PREVIEW
          </a>
          <a href="https://github.com/mhdashikofficial/FitNinja/releases/latest/download/FitNinja.apk" style={{ color: "rgba(255,255,255,0.3)", textDecoration: "none", fontSize: 13, letterSpacing: 1 }}>
            DOWNLOAD
          </a>
          <a href="https://github.com/mhdashikofficial/FitNinja" target="_blank" rel="noopener noreferrer" style={{ color: "rgba(255,255,255,0.3)", textDecoration: "none", fontSize: 13, letterSpacing: 1 }}>
            GITHUB
          </a>
        </div>

        {/* Developer Credit */}
        <div style={{
          padding: "20px 0",
          borderTop: "1px solid rgba(255,255,255,0.05)",
        }}>
          <p style={{ fontSize: 13, color: "rgba(255,255,255,0.25)", marginBottom: 8 }}>
            Designed & Developed by
          </p>
          <a
            href="https://instagram.com/byyyy.ash"
            target="_blank"
            rel="noopener noreferrer"
            style={{
              display: "inline-flex",
              alignItems: "center",
              gap: 10,
              padding: "10px 24px",
              borderRadius: 12,
              border: "1px solid rgba(0, 229, 255, 0.15)",
              background: "rgba(0, 229, 255, 0.03)",
              color: "#00e5ff",
              textDecoration: "none",
              fontWeight: 600,
              fontSize: 14,
              letterSpacing: 1,
              transition: "all 0.3s",
            }}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
            </svg>
            @byyyy.ash
          </a>
        </div>

        <p style={{
          fontSize: 11,
          color: "rgba(255,255,255,0.15)",
          marginTop: 20,
          letterSpacing: 1,
        }}>
          © 2026 FitNinja. All Rights Reserved.
        </p>
      </div>
    </footer>
  );
}
