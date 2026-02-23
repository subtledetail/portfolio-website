#!/bin/bash
# ============================================================
# JRS_UXD Portfolio — Setup Script
# Run this from inside ~/Desktop/portfolio-website
# ============================================================

set -e

echo "🔧 Setting up JRS_UXD Portfolio v1..."
echo ""

# Safety check
if [ ! -d ".git" ]; then
  echo "❌ Error: Run this from inside your git repo (~/Desktop/portfolio-website)"
  exit 1
fi

# Clean old files that conflict
echo "🧹 Cleaning old config files..."
rm -f postcss.config.mjs postcss.config.js tailwind.config.ts tailwind.config.js jsconfig.json
rm -rf node_modules package-lock.json .next

# Remove old app directory if it exists (we're replacing it)
rm -rf app src

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p src/app/work/'[slug]'
mkdir -p src/app/about
mkdir -p src/app/musings
mkdir -p src/app/contact
mkdir -p src/components/GridOverlay
mkdir -p src/components/Nav
mkdir -p src/components/Splash
mkdir -p src/components/SectionReveal
mkdir -p src/components/ProjectCard
mkdir -p src/components/MusingCard
mkdir -p src/components/CircleArrow
mkdir -p src/components/Footer
mkdir -p src/components/AnimatedGradient
mkdir -p src/styles
mkdir -p src/lib
mkdir -p src/hooks
mkdir -p public

# ============================================================
# package.json
# ============================================================
echo "📦 Writing package.json..."
cat > package.json << 'ENDOFFILE'
{
  "name": "jrs-portfolio",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev --turbopack",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "gsap": "^3.12.7",
    "next": "^15.1.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "eslint": "^9.0.0",
    "eslint-config-next": "^15.1.0",
    "typescript": "^5.7.0"
  }
}
ENDOFFILE

# ============================================================
# tsconfig.json
# ============================================================
echo "📝 Writing tsconfig.json..."
cat > tsconfig.json << 'ENDOFFILE'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
ENDOFFILE

# ============================================================
# next.config.ts
# ============================================================
cat > next.config.ts << 'ENDOFFILE'
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  images: {
    formats: ['image/avif', 'image/webp'],
    deviceSizes: [640, 768, 1024, 1280, 1920],
  },
};

export default nextConfig;
ENDOFFILE

# ============================================================
# eslint.config.mjs
# ============================================================
cat > eslint.config.mjs << 'ENDOFFILE'
import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const compat = new FlatCompat({
  baseDirectory: __dirname,
});

const eslintConfig = [
  ...compat.extends("next/core-web-vitals", "next/typescript"),
];

export default eslintConfig;
ENDOFFILE

# ============================================================
# .gitignore
# ============================================================
cat > .gitignore << 'ENDOFFILE'
/node_modules
/.next/
/out/
/build
.DS_Store
*.pem
npm-debug.log*
.env*.local
.vercel
*.tsbuildinfo
next-env.d.ts
ENDOFFILE

# ============================================================
# src/styles/tokens.css
# ============================================================
echo "🎨 Writing design tokens..."
cat > src/styles/tokens.css << 'ENDOFFILE'
:root {
  --space-1: 8px;
  --space-2: 16px;
  --space-3: 24px;
  --space-4: 32px;
  --space-5: 40px;
  --space-6: 48px;
  --space-7: 56px;
  --space-8: 64px;
  --space-10: 80px;
  --space-12: 96px;
  --space-15: 120px;
  --space-20: 160px;
  --space-30: 240px;

  --grid-columns: 5;
  --grid-gutter: 24px;
  --grid-margin: clamp(16px, 4vw, 64px);
  --grid-line-color: rgba(255, 255, 255, 0.28);
  --grid-line-color-light: rgba(0, 0, 0, 0.08);

  --color-bg-dark: #0A0A0A;
  --color-bg-light: #F5F5F3;
  --color-bg-hero: #E8E4DF;

  --color-text-primary: #222222;
  --color-text-secondary: #6B6B6B;
  --color-text-tertiary: #999999;
  --color-text-on-dark: #E8E8E8;
  --color-text-on-dark-secondary: rgba(255, 255, 255, 0.6);
  --color-text-on-dark-tertiary: rgba(255, 255, 255, 0.4);

  --color-accent: #F2EB26;
  --color-accent-80: rgba(242, 235, 38, 0.8);
  --color-selection: rgba(242, 235, 38, 0.8);

  --color-project-1: #E84D2F;
  --color-project-2: #1B7B5A;
  --color-project-3: #1A3A5C;
  --color-project-4: #2C2C2C;

  --type-display-size: clamp(64px, 10vw, 160px);
  --type-display-lh: 0.9;
  --type-display-weight: 800;
  --type-display-tracking: -0.03em;

  --type-h1-size: clamp(32px, 5vw, 72px);
  --type-h1-lh: 1.1;
  --type-h1-weight: 600;
  --type-h1-tracking: -0.02em;

  --type-h2-size: clamp(24px, 3vw, 40px);
  --type-h2-lh: 1.2;
  --type-h2-weight: 600;
  --type-h2-tracking: -0.01em;

  --type-h3-size: 20px;
  --type-h3-lh: 32px;
  --type-h3-weight: 500;

  --type-body-size: 16px;
  --type-body-lh: 24px;
  --type-body-weight: 400;

  --type-caption-size: 13px;
  --type-caption-lh: 16px;
  --type-caption-weight: 400;

  --type-mono-size: 13px;
  --type-mono-lh: 16px;
  --type-mono-weight: 400;

  --type-nav-size: 14px;
  --type-nav-lh: 24px;
  --type-nav-weight: 500;
  --type-nav-tracking: 0.08em;

  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-out-quart: cubic-bezier(0.25, 1, 0.5, 1);
  --ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);
  --duration-fast: 200ms;
  --duration-normal: 400ms;
  --duration-slow: 800ms;
  --duration-reveal: 1200ms;

  --z-grid: 1;
  --z-content: 2;
  --z-nav: 100;
  --z-splash: 1000;

  --nav-height: 80px;
  --max-width: 1920px;
}

@media (max-width: 1023px) {
  :root {
    --grid-columns: 4;
    --grid-gutter: 20px;
    --nav-height: 64px;
  }
}

@media (max-width: 767px) {
  :root {
    --grid-columns: 2;
    --grid-gutter: 16px;
    --nav-height: 56px;
  }
}
ENDOFFILE

# ============================================================
# src/styles/globals.css
# ============================================================
cat > src/styles/globals.css << 'ENDOFFILE'
@import url('https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,100..900&display=swap');
@import './tokens.css';

*,
*::before,
*::after {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
  scroll-behavior: smooth;
}

@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  font-size: var(--type-body-size);
  line-height: var(--type-body-lh);
  font-weight: var(--type-body-weight);
  color: var(--color-text-primary);
  background-color: var(--color-bg-dark);
  overflow-x: hidden;
}

::selection {
  background-color: var(--color-selection);
  color: var(--color-text-primary);
}

img, video { display: block; max-width: 100%; height: auto; }
a { color: inherit; text-decoration: none; }
button { font: inherit; color: inherit; background: none; border: none; cursor: pointer; }
ul, ol { list-style: none; }

:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 4px;
}

.sr-only {
  position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px;
  overflow: hidden; clip: rect(0,0,0,0); white-space: nowrap; border-width: 0;
}
ENDOFFILE

# ============================================================
# src/hooks/useScrollDirection.ts
# ============================================================
echo "🪝 Writing hooks..."
cat > src/hooks/useScrollDirection.ts << 'ENDOFFILE'
'use client';

import { useState, useEffect, useRef } from 'react';

type ScrollDirection = 'up' | 'down' | null;

export function useScrollDirection(threshold = 10): {
  scrollDirection: ScrollDirection;
  scrollY: number;
} {
  const [scrollDirection, setScrollDirection] = useState<ScrollDirection>(null);
  const [scrollY, setScrollY] = useState(0);
  const lastScrollY = useRef(0);
  const ticking = useRef(false);

  useEffect(() => {
    const updateScrollDirection = () => {
      const currentScrollY = window.scrollY;
      setScrollY(currentScrollY);
      if (Math.abs(currentScrollY - lastScrollY.current) < threshold) {
        ticking.current = false;
        return;
      }
      setScrollDirection(currentScrollY > lastScrollY.current ? 'down' : 'up');
      lastScrollY.current = currentScrollY > 0 ? currentScrollY : 0;
      ticking.current = false;
    };

    const onScroll = () => {
      if (!ticking.current) {
        window.requestAnimationFrame(updateScrollDirection);
        ticking.current = true;
      }
    };

    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, [threshold]);

  return { scrollDirection, scrollY };
}
ENDOFFILE

# ============================================================
# src/hooks/useReducedMotion.ts
# ============================================================
cat > src/hooks/useReducedMotion.ts << 'ENDOFFILE'
'use client';

import { useState, useEffect } from 'react';

export function useReducedMotion(): boolean {
  const [prefersReducedMotion, setPrefersReducedMotion] = useState(false);

  useEffect(() => {
    const mql = window.matchMedia('(prefers-reduced-motion: reduce)');
    setPrefersReducedMotion(mql.matches);
    const handler = (e: MediaQueryListEvent) => setPrefersReducedMotion(e.matches);
    mql.addEventListener('change', handler);
    return () => mql.removeEventListener('change', handler);
  }, []);

  return prefersReducedMotion;
}
ENDOFFILE

# ============================================================
# src/components/GridOverlay
# ============================================================
echo "🧱 Writing components..."
cat > src/components/GridOverlay/GridOverlay.tsx << 'ENDOFFILE'
'use client';

import { useState, useEffect, useCallback } from 'react';
import styles from './GridOverlay.module.css';

export default function GridOverlay() {
  const [devMode, setDevMode] = useState(false);

  const handleKeydown = useCallback((e: KeyboardEvent) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'g') {
      e.preventDefault();
      setDevMode((prev) => !prev);
    }
  }, []);

  useEffect(() => {
    window.addEventListener('keydown', handleKeydown);
    return () => window.removeEventListener('keydown', handleKeydown);
  }, [handleKeydown]);

  return (
    <div
      className={`${styles.grid} ${devMode ? styles.dev : ''}`}
      aria-hidden="true"
      data-grid-overlay
    >
      {Array.from({ length: 5 }).map((_, i) => (
        <div key={i} className={styles.column}>
          {devMode && <span className={styles.label}>{i + 1}</span>}
        </div>
      ))}
    </div>
  );
}
ENDOFFILE

cat > src/components/GridOverlay/GridOverlay.module.css << 'ENDOFFILE'
.grid {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  z-index: var(--z-grid);
  pointer-events: none;
  display: grid;
  grid-template-columns: repeat(var(--grid-columns), 1fr);
  gap: var(--grid-gutter);
  padding-left: var(--grid-margin);
  padding-right: var(--grid-margin);
  max-width: var(--max-width);
  margin: 0 auto;
}

.column {
  position: relative;
  height: 100%;
}

.column::before,
.column::after {
  content: '';
  position: absolute;
  top: 0; bottom: 0;
  width: 1px;
  background-color: var(--grid-line-color);
  transition: opacity var(--duration-normal) var(--ease-out-quart);
}

.column::before { left: 0; }
.column::after { right: 0; }
.column:first-child::before { opacity: 0.5; }
.column:last-child::after { opacity: 0.5; }

.dev .column::before,
.dev .column::after {
  background-color: rgba(242, 235, 38, 0.4) !important;
}

.dev .column {
  background-color: rgba(242, 235, 38, 0.03);
}

.label {
  position: absolute;
  top: var(--space-1);
  left: 50%;
  transform: translateX(-50%);
  font-family: 'Inter', monospace;
  font-size: 10px;
  font-weight: 600;
  color: var(--color-accent);
  background: rgba(0, 0, 0, 0.7);
  padding: 2px 6px;
  border-radius: 2px;
  letter-spacing: 0.05em;
}

@media (max-width: 1023px) {
  .column:nth-child(5) { display: none; }
}

@media (max-width: 767px) {
  .column:nth-child(3),
  .column:nth-child(4),
  .column:nth-child(5) { display: none; }
}
ENDOFFILE

# ============================================================
# src/components/Nav
# ============================================================
cat > src/components/Nav/Nav.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useScrollDirection } from '@/hooks/useScrollDirection';
import styles from './Nav.module.css';

const NAV_ITEMS = [
  { label: 'Work', href: '/work' },
  { label: 'About', href: '/about' },
  { label: 'Musings', href: '/musings' },
  { label: 'Contact', href: '/contact' },
] as const;

interface NavProps {
  splashActive?: boolean;
}

export default function Nav({ splashActive = false }: NavProps) {
  const { scrollDirection, scrollY } = useScrollDirection();
  const [mobileOpen, setMobileOpen] = useState(false);

  const isHidden = !splashActive && scrollDirection === 'down' && scrollY > 100;
  const isTransparent = scrollY < 50;

  return (
    <header
      className={`${styles.header} ${isHidden ? styles.hidden : ''} ${isTransparent ? styles.transparent : ''} ${splashActive ? styles.splashActive : ''}`}
    >
      <nav className={styles.nav}>
        <Link href="/" className={styles.brand}>JRS_UXD</Link>
        <ul className={styles.menu}>
          {NAV_ITEMS.map((item) => (
            <li key={item.href}>
              <Link href={item.href} className={styles.link}>
                <span className={styles.linkText}>{item.label}</span>
              </Link>
            </li>
          ))}
        </ul>
        <button
          className={`${styles.burger} ${mobileOpen ? styles.burgerOpen : ''}`}
          onClick={() => setMobileOpen(!mobileOpen)}
          aria-expanded={mobileOpen}
          aria-label={mobileOpen ? 'Close menu' : 'Open menu'}
        >
          <span className={styles.burgerLine} />
          <span className={styles.burgerLine} />
        </button>
      </nav>
      <div className={`${styles.mobileMenu} ${mobileOpen ? styles.mobileMenuOpen : ''}`}>
        <ul className={styles.mobileList}>
          {NAV_ITEMS.map((item, i) => (
            <li key={item.href} className={styles.mobileItem} style={{ transitionDelay: mobileOpen ? `${i * 80}ms` : '0ms' }}>
              <Link href={item.href} className={styles.mobileLink} onClick={() => setMobileOpen(false)}>{item.label}</Link>
            </li>
          ))}
        </ul>
      </div>
    </header>
  );
}
ENDOFFILE

cat > src/components/Nav/Nav.module.css << 'ENDOFFILE'
.header {
  position: fixed; top: 0; left: 0; right: 0;
  z-index: var(--z-nav);
  height: var(--nav-height);
  transition: transform var(--duration-normal) var(--ease-out-expo), background-color var(--duration-normal) var(--ease-out-quart);
  background-color: rgba(10, 10, 10, 0.85);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}
.hidden { transform: translateY(-100%); }
.transparent { background-color: transparent; backdrop-filter: none; -webkit-backdrop-filter: none; }
.splashActive { opacity: 0; pointer-events: none; }

.nav {
  display: flex; align-items: center; justify-content: space-between;
  height: 100%; max-width: var(--max-width); margin: 0 auto;
  padding: 0 var(--grid-margin);
}

.brand {
  font-size: var(--type-nav-size); font-weight: 700;
  letter-spacing: 0.12em; text-transform: uppercase;
  color: var(--color-text-on-dark);
  transition: opacity var(--duration-fast) ease;
  position: relative; z-index: 2;
}
.brand:hover { opacity: 0.7; }

.menu { display: flex; align-items: center; gap: var(--space-1); }

.link { display: block; padding: var(--space-1) var(--space-2); position: relative; overflow: hidden; }

.linkText {
  font-size: var(--type-nav-size); font-weight: var(--type-nav-weight);
  letter-spacing: var(--type-nav-tracking); text-transform: uppercase;
  color: var(--color-text-on-dark);
  transition: color var(--duration-fast) ease;
  position: relative;
}

.linkText::after {
  content: ''; position: absolute; bottom: -2px; left: 0;
  width: 100%; height: 1px;
  background-color: var(--color-accent);
  transform: scaleX(0); transform-origin: right;
  transition: transform var(--duration-normal) var(--ease-out-expo);
}
.link:hover .linkText::after { transform: scaleX(1); transform-origin: left; }
.link:hover .linkText { color: var(--color-accent); }

.burger {
  display: none; flex-direction: column; justify-content: center;
  gap: 6px; width: 32px; height: 32px; position: relative; z-index: 2;
}
.burgerLine {
  display: block; width: 100%; height: 1.5px;
  background-color: var(--color-text-on-dark);
  transition: transform var(--duration-normal) var(--ease-out-expo), opacity var(--duration-fast) ease;
}
.burgerOpen .burgerLine:first-child { transform: translateY(3.75px) rotate(45deg); }
.burgerOpen .burgerLine:last-child { transform: translateY(-3.75px) rotate(-45deg); }

.mobileMenu {
  display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  background-color: var(--color-bg-dark); z-index: 1;
  padding: calc(var(--nav-height) + var(--space-8)) var(--grid-margin) var(--space-8);
  opacity: 0; pointer-events: none;
  transition: opacity var(--duration-normal) var(--ease-out-expo);
}
.mobileMenuOpen { opacity: 1; pointer-events: auto; }

.mobileList { display: flex; flex-direction: column; gap: var(--space-4); }

.mobileItem {
  opacity: 0; transform: translateY(24px);
  transition: opacity var(--duration-slow) var(--ease-out-expo), transform var(--duration-slow) var(--ease-out-expo);
}
.mobileMenuOpen .mobileItem { opacity: 1; transform: translateY(0); }

.mobileLink {
  font-size: clamp(32px, 8vw, 48px); font-weight: 700;
  letter-spacing: -0.02em; color: var(--color-text-on-dark);
}
.mobileLink:hover { color: var(--color-accent); }

@media (max-width: 767px) {
  .menu { display: none; }
  .burger { display: flex; }
  .mobileMenu { display: block; }
}
ENDOFFILE

# ============================================================
# src/components/Splash
# ============================================================
cat > src/components/Splash/Splash.tsx << 'ENDOFFILE'
'use client';

import { useRef, useEffect, useState } from 'react';
import { useReducedMotion } from '@/hooks/useReducedMotion';
import styles from './Splash.module.css';

interface SplashProps {
  onComplete: () => void;
}

export default function Splash({ onComplete }: SplashProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [isComplete, setIsComplete] = useState(false);
  const reducedMotion = useReducedMotion();

  useEffect(() => {
    if (reducedMotion) {
      setIsComplete(true);
      onComplete();
      return;
    }

    const runAnimation = async () => {
      const { gsap } = await import('gsap');
      const container = containerRef.current;
      if (!container) return;

      const columns = container.querySelectorAll('[data-splash-col]');
      const letters = container.querySelectorAll('[data-splash-letter]');

      const tl = gsap.timeline({
        onComplete: () => { setIsComplete(true); onComplete(); },
      });

      tl.fromTo(columns, { yPercent: 110 }, {
        yPercent: 0, duration: 0.7, stagger: 0.09, ease: 'power3.out',
      });

      tl.fromTo(letters, { opacity: 0, yPercent: 40 }, {
        opacity: 1, yPercent: 0, duration: 0.5, stagger: 0.04, ease: 'power2.out',
      }, '-=0.2');

      tl.to(container, {
        opacity: 0, yPercent: -3, duration: 0.6, ease: 'power2.inOut', delay: 0.6,
      });
    };

    runAnimation();
  }, [onComplete, reducedMotion]);

  if (isComplete) return null;

  const cols: (string[] | null)[] = [null, ['J','U'], ['R','X'], ['S','D'], null];

  return (
    <div ref={containerRef} className={styles.splash} aria-hidden="true">
      {cols.map((pair, i) => (
        <div key={i} className={styles.column} data-splash-col>
          <div className={`${styles.columnInner} ${i === 0 || i === 4 ? styles.edge : ''}`}>
            {pair && pair.map((letter, j) => (
              <span key={j} className={`${styles.letter} ${j === 0 ? styles.letterTop : styles.letterBottom}`} data-splash-letter>
                {letter}
              </span>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}
ENDOFFILE

cat > src/components/Splash/Splash.module.css << 'ENDOFFILE'
.splash {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  z-index: var(--z-splash);
  background-color: var(--color-bg-dark);
  display: grid; grid-template-columns: repeat(5, 1fr);
  overflow: hidden;
}

.column { position: relative; height: 100vh; will-change: transform; }

.columnInner {
  width: 100%; height: 100%;
  background-color: #111111;
  border-left: 1px solid rgba(255,255,255,0.12);
  border-right: 1px solid rgba(255,255,255,0.12);
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  gap: var(--space-15);
}

.edge { background-color: #0d0d0d; }

.letter {
  font-family: 'Inter', sans-serif;
  font-size: clamp(48px, 10vw, 120px);
  font-weight: 800; color: #FFFFFF;
  letter-spacing: -0.03em; line-height: 1;
  will-change: opacity, transform;
}

.letterTop { margin-bottom: auto; margin-top: 30%; }
.letterBottom { margin-top: auto; margin-bottom: 30%; }

@media (max-width: 767px) {
  .letter { font-size: clamp(28px, 8vw, 56px); }
  .letterTop { margin-top: 35%; }
  .letterBottom { margin-bottom: 35%; }
}
ENDOFFILE

# ============================================================
# src/components/AnimatedGradient
# ============================================================
cat > src/components/AnimatedGradient/AnimatedGradient.tsx << 'ENDOFFILE'
'use client';

import { useRef, useEffect } from 'react';
import { useReducedMotion } from '@/hooks/useReducedMotion';
import styles from './AnimatedGradient.module.css';

export default function AnimatedGradient() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const animationRef = useRef<number>(0);
  const reducedMotion = useReducedMotion();

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let width = 0;
    let height = 0;

    const resize = () => {
      const dpr = Math.min(window.devicePixelRatio, 2);
      const rect = canvas.parentElement?.getBoundingClientRect();
      if (!rect) return;
      width = rect.width; height = rect.height;
      canvas.width = width * dpr; canvas.height = height * dpr;
      canvas.style.width = `${width}px`; canvas.style.height = `${height}px`;
      ctx.scale(dpr, dpr);
    };

    resize();
    window.addEventListener('resize', resize);

    const blobs = [
      { bx: 0.6, by: 0.4, br: 0.45, bH: 270, s: 40, l: 25, sx: 0.00015, sy: 0.00012, px: 0, py: 1.57, pr: 0.94 },
      { bx: 0.3, by: 0.6, br: 0.5, bH: 340, s: 35, l: 22, sx: 0.00018, sy: 0.0001, px: 3.14, py: 0, pr: 2.2 },
      { bx: 0.75, by: 0.7, br: 0.35, bH: 220, s: 30, l: 20, sx: 0.00012, sy: 0.00016, px: 1.57, py: 4.71, pr: 0 },
      { bx: 0.5, by: 0.3, br: 0.4, bH: 15, s: 30, l: 18, sx: 0.0001, sy: 0.00014, px: 3.77, py: 2.51, pr: 4.71 },
    ];

    const draw = (time: number) => {
      ctx.clearRect(0, 0, width, height);
      ctx.fillStyle = '#0e0a14';
      ctx.fillRect(0, 0, width, height);

      for (const b of blobs) {
        const x = (b.bx + Math.sin(time * b.sx + b.px) * 0.12) * width;
        const y = (b.by + Math.cos(time * b.sy + b.py) * 0.1) * height;
        const r = b.br * Math.max(width, height) * (1 + Math.sin(time * 0.0001 + b.pr) * 0.15);
        const h = b.bH + Math.sin(time * 0.00008 + b.px) * 15;

        const gradient = ctx.createRadialGradient(x, y, 0, x, y, r);
        gradient.addColorStop(0, `hsla(${h},${b.s}%,${b.l}%,0.55)`);
        gradient.addColorStop(0.5, `hsla(${h},${b.s}%,${b.l * 0.7}%,0.25)`);
        gradient.addColorStop(1, `hsla(${h},${b.s}%,${b.l}%,0)`);

        ctx.globalCompositeOperation = 'screen';
        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, width, height);
      }
      ctx.globalCompositeOperation = 'source-over';
    };

    if (reducedMotion) {
      draw(0);
    } else {
      const animate = (time: number) => {
        draw(time);
        animationRef.current = requestAnimationFrame(animate);
      };
      animationRef.current = requestAnimationFrame(animate);
    }

    return () => { cancelAnimationFrame(animationRef.current); window.removeEventListener('resize', resize); };
  }, [reducedMotion]);

  return (
    <div className={styles.container}>
      <canvas ref={canvasRef} className={styles.canvas} aria-hidden="true" />
    </div>
  );
}
ENDOFFILE

cat > src/components/AnimatedGradient/AnimatedGradient.module.css << 'ENDOFFILE'
.container { position: absolute; top: 0; left: 0; right: 0; bottom: 0; overflow: hidden; z-index: 0; }
.canvas { display: block; width: 100%; height: 100%; }
ENDOFFILE

# ============================================================
# src/components/SectionReveal
# ============================================================
cat > src/components/SectionReveal/SectionReveal.tsx << 'ENDOFFILE'
'use client';

import { useRef, useEffect, type ReactNode } from 'react';
import { useReducedMotion } from '@/hooks/useReducedMotion';

interface SectionRevealProps {
  children: ReactNode;
  stagger?: number;
  direction?: 'up' | 'left' | 'right' | 'fade';
  distance?: number;
  className?: string;
  triggerOffset?: string;
}

export default function SectionReveal({
  children, stagger = 0.08, direction = 'up', distance = 40,
  className = '', triggerOffset = 'top 85%',
}: SectionRevealProps) {
  const ref = useRef<HTMLDivElement>(null);
  const reducedMotion = useReducedMotion();

  useEffect(() => {
    if (reducedMotion) return;
    const el = ref.current;
    if (!el) return;

    const initAnimation = async () => {
      const { gsap } = await import('gsap');
      const { ScrollTrigger } = await import('gsap/ScrollTrigger');
      gsap.registerPlugin(ScrollTrigger);

      const targets = el.querySelectorAll('[data-reveal]');
      const animTargets = targets.length > 0 ? targets : [el];

      const fromVars: Record<string, unknown> = { opacity: 0 };
      if (direction === 'up') fromVars.y = distance;
      if (direction === 'left') fromVars.x = -distance;
      if (direction === 'right') fromVars.x = distance;

      gsap.fromTo(animTargets, fromVars, {
        opacity: 1, y: 0, x: 0, duration: 0.8, stagger, ease: 'power3.out',
        scrollTrigger: { trigger: el, start: triggerOffset, once: true },
      });
    };

    initAnimation();
  }, [direction, distance, stagger, triggerOffset, reducedMotion]);

  return (
    <div ref={ref} className={className} style={reducedMotion ? {} : { opacity: 0 }}>
      {children}
    </div>
  );
}
ENDOFFILE

# ============================================================
# src/components/CircleArrow
# ============================================================
cat > src/components/CircleArrow/CircleArrow.tsx << 'ENDOFFILE'
'use client';

import Link from 'next/link';
import styles from './CircleArrow.module.css';

interface CircleArrowProps {
  href: string;
  label?: string;
  variant?: 'filled' | 'outlined';
  size?: 'sm' | 'md' | 'lg';
  onDark?: boolean;
  className?: string;
}

export default function CircleArrow({
  href, label = 'View more', variant = 'filled',
  size = 'md', onDark = false, className = '',
}: CircleArrowProps) {
  return (
    <Link href={href} className={`${styles.circle} ${styles[variant]} ${styles[size]} ${onDark ? styles.onDark : ''} ${className}`} aria-label={label}>
      <svg className={styles.arrow} viewBox="0 0 24 24" fill="none" aria-hidden="true">
        <path d="M7 17L17 7M17 7H7M17 7V17" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
      </svg>
    </Link>
  );
}
ENDOFFILE

cat > src/components/CircleArrow/CircleArrow.module.css << 'ENDOFFILE'
.circle {
  display: inline-flex; align-items: center; justify-content: center;
  border-radius: 50%; flex-shrink: 0;
  transition: transform var(--duration-normal) var(--ease-out-expo), background-color var(--duration-normal) var(--ease-out-quart), border-color var(--duration-normal) var(--ease-out-quart);
}
.sm { width: 48px; height: 48px; }
.md { width: 80px; height: 80px; }
.lg { width: 120px; height: 120px; }

.filled { background-color: var(--color-text-on-dark); color: var(--color-bg-dark); }
.filled:hover { background-color: var(--color-accent); transform: scale(1.08); }

.outlined { background-color: transparent; border: 1.5px solid var(--color-text-primary); color: var(--color-text-primary); }
.outlined:hover { border-color: var(--color-accent); color: var(--color-accent); transform: scale(1.08); }

.onDark.outlined { border-color: var(--color-text-on-dark); color: var(--color-text-on-dark); }
.onDark.outlined:hover { border-color: var(--color-accent); color: var(--color-accent); }
.onDark.filled { background-color: var(--color-text-on-dark); color: var(--color-bg-dark); }

.arrow { width: 40%; height: 40%; transition: transform var(--duration-normal) var(--ease-out-expo); }
.circle:hover .arrow { transform: translate(2px, -2px); }
ENDOFFILE

# ============================================================
# src/components/ProjectCard
# ============================================================
cat > src/components/ProjectCard/ProjectCard.tsx << 'ENDOFFILE'
'use client';

import Link from 'next/link';
import styles from './ProjectCard.module.css';

export interface ProjectData {
  slug: string; title: string; description: string;
  client: string; category: string; accentColor: string; mediaColor?: string;
}

interface ProjectCardProps { project: ProjectData; layout?: 'wide' | 'standard'; index: number; }

export default function ProjectCard({ project, layout = 'standard', index }: ProjectCardProps) {
  return (
    <article className={`${styles.card} ${styles[layout]}`} data-reveal
      style={{ '--media-bg': project.mediaColor || project.accentColor } as React.CSSProperties}>
      <Link href={`/work/${project.slug}`} className={styles.link}>
        <div className={styles.media}>
          <span className={styles.index}>{String(index + 1).padStart(2, '0')}</span>
          <div className={styles.overlay}>
            <span className={styles.overlayText}>View Project</span>
          </div>
        </div>
        <div className={styles.info}>
          <span className={styles.category}>{project.category}</span>
          <h3 className={styles.title}>{project.title}</h3>
          <p className={styles.description}>{project.description}</p>
          <span className={styles.client}>{project.client}</span>
        </div>
      </Link>
    </article>
  );
}
ENDOFFILE

cat > src/components/ProjectCard/ProjectCard.module.css << 'ENDOFFILE'
.card { position: relative; overflow: hidden; }

.link { display: grid; grid-template-columns: 3fr 1fr; text-decoration: none; color: inherit; min-height: 360px; }

.media {
  position: relative; overflow: hidden; background-color: var(--media-bg);
  min-height: 360px; display: flex; align-items: center; justify-content: center;
}

.index {
  font-size: clamp(64px,8vw,120px); font-weight: 800;
  color: rgba(255,255,255,0.06); letter-spacing: -0.03em;
}

.overlay {
  position: absolute; inset: 0;
  display: flex; align-items: center; justify-content: center;
  background-color: rgba(0,0,0,0);
  transition: background-color var(--duration-normal) var(--ease-out-quart);
}
.card:hover .overlay { background-color: rgba(0,0,0,0.45); }

.overlayText {
  font-size: var(--type-caption-size); font-weight: 500;
  letter-spacing: 0.1em; text-transform: uppercase; color: #FFF;
  opacity: 0; transform: translateY(8px);
  transition: opacity var(--duration-normal) var(--ease-out-expo), transform var(--duration-normal) var(--ease-out-expo);
}
.card:hover .overlayText { opacity: 1; transform: translateY(0); }

.info {
  display: flex; flex-direction: column; justify-content: flex-end;
  padding: var(--space-4); background-color: var(--color-bg-dark);
}

.category {
  font-size: var(--type-caption-size); line-height: var(--type-caption-lh);
  text-transform: uppercase; letter-spacing: 0.08em;
  color: var(--color-text-on-dark-tertiary); margin-bottom: var(--space-2);
}

.title {
  font-size: var(--type-h3-size); line-height: var(--type-h3-lh); font-weight: var(--type-h3-weight);
  color: var(--color-text-on-dark); margin-bottom: var(--space-1); letter-spacing: -0.01em;
}

.description {
  font-size: var(--type-caption-size); line-height: var(--type-caption-lh);
  color: var(--color-text-on-dark-secondary); margin-bottom: var(--space-3);
}

.client {
  font-size: var(--type-mono-size); font-weight: 500;
  text-transform: uppercase; letter-spacing: 0.06em;
  color: var(--color-text-on-dark-tertiary); margin-top: auto;
}

.wide .link { grid-template-columns: 1fr; grid-template-rows: auto auto; }
.wide .media { min-height: 480px; }

@media (max-width: 1023px) {
  .link { grid-template-columns: 1fr; grid-template-rows: auto auto; }
  .media { min-height: 280px; }
}

@media (max-width: 767px) {
  .media { min-height: 220px; }
  .info { padding: var(--space-2) var(--space-3); }
}
ENDOFFILE

# ============================================================
# src/components/MusingCard
# ============================================================
cat > src/components/MusingCard/MusingCard.tsx << 'ENDOFFILE'
'use client';

import Link from 'next/link';
import styles from './MusingCard.module.css';

export interface MusingData {
  slug: string; title: string; excerpt: string;
  category: string; date: string; mediaColor?: string;
}

interface MusingCardProps { musing: MusingData; variant?: 'featured' | 'compact'; }

export default function MusingCard({ musing, variant = 'compact' }: MusingCardProps) {
  return (
    <article className={`${styles.card} ${styles[variant]}`} data-reveal>
      <Link href={`/musings/${musing.slug}`} className={styles.link}>
        <div className={styles.media} style={{ backgroundColor: musing.mediaColor || '#2a2a2a' }}>
          <div className={styles.mediaInner} />
        </div>
        <div className={styles.content}>
          <span className={styles.category}>{musing.category}</span>
          <h3 className={styles.title}>{musing.title}</h3>
          <p className={styles.excerpt}>{musing.excerpt}</p>
          <time className={styles.date}>{musing.date}</time>
        </div>
      </Link>
    </article>
  );
}
ENDOFFILE

cat > src/components/MusingCard/MusingCard.module.css << 'ENDOFFILE'
.card { position: relative; }
.link { display: flex; flex-direction: column; text-decoration: none; color: inherit; height: 100%; }

.media {
  position: relative; overflow: hidden;
  transition: transform var(--duration-normal) var(--ease-out-expo);
}
.mediaInner { width: 100%; padding-bottom: 100%; }
.featured .mediaInner { padding-bottom: 75%; }
.card:hover .media { transform: scale(0.98); }

.content { padding: var(--space-3) 0; }

.category {
  display: block; font-size: var(--type-caption-size);
  font-weight: 500; color: var(--color-text-secondary);
  text-transform: capitalize; margin-bottom: var(--space-1);
}

.title {
  font-size: var(--type-h3-size); line-height: var(--type-h3-lh); font-weight: var(--type-h3-weight);
  color: var(--color-text-primary); margin-bottom: var(--space-1);
  transition: color var(--duration-fast) ease;
}
.card:hover .title { color: var(--color-text-secondary); }

.excerpt {
  font-size: var(--type-body-size); line-height: var(--type-body-lh);
  color: var(--color-text-secondary);
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
  overflow: hidden; margin-bottom: var(--space-1);
}

.date { font-size: var(--type-mono-size); color: var(--color-text-tertiary); }

@media (max-width: 767px) { .content { padding: var(--space-2) 0; } }
ENDOFFILE

# ============================================================
# src/components/Footer
# ============================================================
cat > src/components/Footer/Footer.tsx << 'ENDOFFILE'
import styles from './Footer.module.css';

export default function Footer() {
  return (
    <footer className={styles.footer}>
      <div className={styles.inner}>
        <div>
          <p className={styles.copyright}>&copy; {new Date().getFullYear()} Jason Reid Scott</p>
          <p className={styles.tagline}>Built with obsessive grid discipline</p>
        </div>
        <div className={styles.social}>
          {['Li', '𝕏', 'Dr'].map(s => (
            <a key={s} href="#" className={styles.socialLink}>{s}</a>
          ))}
        </div>
      </div>
    </footer>
  );
}
ENDOFFILE

cat > src/components/Footer/Footer.module.css << 'ENDOFFILE'
.footer {
  position: relative; background-color: var(--color-bg-dark);
  border-top: 1px solid rgba(255,255,255,0.06); padding: var(--space-6) 0;
}
.inner {
  max-width: var(--max-width); margin: 0 auto; padding: 0 var(--grid-margin);
  display: flex; align-items: flex-end; justify-content: space-between;
}
.copyright { font-size: var(--type-caption-size); color: var(--color-text-on-dark-secondary); }
.tagline { font-size: var(--type-mono-size); color: var(--color-text-on-dark-tertiary); font-style: italic; margin-top: 4px; }
.social { display: flex; gap: var(--space-3); }
.socialLink { font-size: var(--type-caption-size); font-weight: 500; color: var(--color-text-on-dark-secondary); transition: color var(--duration-fast) ease; }
.socialLink:hover { color: var(--color-accent); }

@media (max-width: 767px) {
  .inner { flex-direction: column; align-items: flex-start; gap: var(--space-4); }
}
ENDOFFILE

# ============================================================
# src/lib/projects.ts
# ============================================================
echo "📊 Writing data files..."
cat > src/lib/projects.ts << 'ENDOFFILE'
import type { ProjectData } from '@/components/ProjectCard/ProjectCard';

export const projects: ProjectData[] = [
  {
    slug: 'yeti-brand-launch',
    title: 'Launching a Stellar Brand to a New Product Category',
    description: 'Led the design strategy and product experience for a premium brand entering an entirely new market segment.',
    client: 'Yeti Build',
    category: 'Brand Strategy · Product Design',
    accentColor: '#E84D2F',
    mediaColor: '#C84424',
  },
  {
    slug: 'allways-permanent-collection',
    title: 'Reimagining a Permanent Collection — Designing with Heritage and Launching a New Digital Experience',
    description: 'Created an immersive digital platform that honors legacy while embracing modern interaction patterns.',
    client: 'Always Permanent',
    category: 'UX Strategy · Digital Product',
    accentColor: '#1B7B5A',
    mediaColor: '#166B4D',
  },
  {
    slug: 'first-republic-mobile',
    title: "Leading First Republic's Mobile App Redesign with a Unified Design System",
    description: 'Established a comprehensive design system and led the mobile banking experience redesign.',
    client: 'First Republic Bank',
    category: 'Design Systems · Mobile',
    accentColor: '#1A3A5C',
    mediaColor: '#15304D',
  },
  {
    slug: 'clover-city',
    title: "Leading Clover City's UI/UX Design, Overseeing a Full-Scale System Redesign",
    description: 'Directed the complete platform redesign, establishing new patterns for complex data workflows.',
    client: 'Clover',
    category: 'UX Direction · Systems Design',
    accentColor: '#2C2C2C',
    mediaColor: '#1a1a1a',
  },
  {
    slug: 'galaxy-digital-mvp',
    title: 'Facilitating Knowledge Management — MVP and Expansion',
    description: 'Designed the MVP for an internal knowledge platform, then scaled it across the organization.',
    client: 'Galaxy Digital',
    category: 'Product Design · Knowledge Systems',
    accentColor: '#1A1A3A',
    mediaColor: '#12122a',
  },
  {
    slug: 'roku-streaming',
    title: 'Delivering a Peer-to-Peer Streaming Experience — Billions of Impressions',
    description: 'Built streaming interfaces that scale to billions of daily interactions with zero-compromise performance.',
    client: 'Roku Media',
    category: 'Streaming · Scale Design',
    accentColor: '#3A1A3A',
    mediaColor: '#2a122a',
  },
];
ENDOFFILE

# ============================================================
# src/lib/musings.ts
# ============================================================
cat > src/lib/musings.ts << 'ENDOFFILE'
import type { MusingData } from '@/components/MusingCard/MusingCard';

export const musings: MusingData[] = [
  {
    slug: 'design-systems-at-scale',
    title: 'Why Design Systems Fail at Scale — And How to Fix Them',
    excerpt: "Most design systems die not from poor components, but from poor governance. Here's what I've learned leading systems across three organizations.",
    category: 'Design Systems',
    date: 'January 15, 2026',
    mediaColor: '#3a2a1a',
  },
  {
    slug: 'ai-ux-paradigm',
    title: 'The AI-UX Paradigm: Designing Interfaces for Models, Not Menus',
    excerpt: "We're at an inflection point. The next generation of product design won't be about screens — it'll be about orchestrating intelligence.",
    category: 'Thought Leadership',
    date: 'December 8, 2025',
    mediaColor: '#1a2a3a',
  },
  {
    slug: 'craft-vs-velocity',
    title: 'Craft vs. Velocity: The False Dichotomy Killing Design Teams',
    excerpt: "The best teams I've led don't choose between speed and quality. They architect systems that make both inevitable.",
    category: 'Leadership',
    date: 'November 22, 2025',
    mediaColor: '#2a1a2a',
  },
];
ENDOFFILE

# ============================================================
# src/app/layout.tsx
# ============================================================
echo "📄 Writing pages..."
cat > src/app/layout.tsx << 'ENDOFFILE'
import type { Metadata, Viewport } from 'next';
import '@/styles/globals.css';
import GridOverlay from '@/components/GridOverlay/GridOverlay';
import Footer from '@/components/Footer/Footer';

export const metadata: Metadata = {
  title: {
    default: 'JRS_UXD — Jason Reid Scott · Design Director & UX Strategist',
    template: '%s — JRS_UXD',
  },
  description: 'Portfolio of Jason Reid Scott — a hands-on design director & UX strategist who builds products people love.',
};

export const viewport: Viewport = {
  themeColor: '#0A0A0A',
  width: 'device-width',
  initialScale: 1,
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <GridOverlay />
        <div style={{ position: 'relative', zIndex: 2 }}>
          {children}
          <Footer />
        </div>
      </body>
    </html>
  );
}
ENDOFFILE

# ============================================================
# src/app/page.tsx (HOME)
# ============================================================
cat > src/app/page.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import Nav from '@/components/Nav/Nav';
import Splash from '@/components/Splash/Splash';
import AnimatedGradient from '@/components/AnimatedGradient/AnimatedGradient';
import SectionReveal from '@/components/SectionReveal/SectionReveal';
import ProjectCard from '@/components/ProjectCard/ProjectCard';
import MusingCard from '@/components/MusingCard/MusingCard';
import CircleArrow from '@/components/CircleArrow/CircleArrow';
import { projects } from '@/lib/projects';
import { musings } from '@/lib/musings';
import styles from './page.module.css';

export default function HomePage() {
  const [splashComplete, setSplashComplete] = useState(false);

  return (
    <>
      <Splash onComplete={() => setSplashComplete(true)} />
      <Nav splashActive={!splashComplete} />

      <main>
        {/* HERO */}
        <section className={styles.hero}>
          <AnimatedGradient />
          <div className={styles.heroInner}>
            <SectionReveal direction="up" distance={48} stagger={0.12}>
              <h1 className={styles.heroHeadline}>
                <span className={styles.heroName} data-reveal>Jason Reid Scott </span>
                <span className={styles.heroRole} data-reveal>is a hands-on design director &amp; UX strategist who builds products people love.</span>
              </h1>
              <div className={styles.heroCta} data-reveal>
                <CircleArrow href="/work" label="View work" variant="outlined" size="md" onDark />
              </div>
            </SectionReveal>
          </div>
        </section>

        {/* WORK */}
        <section className={styles.work} id="work">
          <div className={styles.sectionInner}>
            <SectionReveal>
              <h2 className={styles.workTitle} data-reveal>Work</h2>
            </SectionReveal>
            <div className={styles.workGrid}>
              {projects.map((project, i) => (
                <SectionReveal key={project.slug} stagger={0}>
                  <ProjectCard project={project} index={i} layout={i === 0 ? 'wide' : 'standard'} />
                </SectionReveal>
              ))}
            </div>
            <SectionReveal>
              <div className={styles.workFooter} data-reveal>
                <CircleArrow href="/work" label="View all work" variant="filled" size="lg" onDark />
              </div>
            </SectionReveal>
          </div>
        </section>

        {/* MUSINGS */}
        <section className={styles.musings} id="musings">
          <div className={styles.sectionInner}>
            <SectionReveal>
              <h2 className={styles.musingsTitle} data-reveal>Musings</h2>
            </SectionReveal>
            <div className={styles.musingsGrid}>
              {musings.map((musing, i) => (
                <SectionReveal key={musing.slug} className={i === 0 ? styles.musingFeatured : styles.musingCompact}>
                  <MusingCard musing={musing} variant={i === 0 ? 'featured' : 'compact'} />
                </SectionReveal>
              ))}
            </div>
            <SectionReveal>
              <div className={styles.musingsFooter} data-reveal>
                <CircleArrow href="/musings" label="More musings" variant="outlined" size="lg" />
              </div>
            </SectionReveal>
          </div>
        </section>

        {/* LET'S CONNECT */}
        <section className={styles.connect} id="connect">
          <div className={styles.connectInner}>
            <SectionReveal direction="up" distance={60}>
              <h2 className={styles.connectHeadline} data-reveal>Let&rsquo;s<br />Connect /</h2>
            </SectionReveal>
            <div className={styles.connectContent}>
              <SectionReveal className={styles.connectInfo}>
                <div data-reveal>
                  <p className={styles.connectLabel}>Say hello</p>
                  <a href="mailto:hello@jrsuxd.com" className={styles.connectEmail}>hello@jrsuxd.com</a>
                </div>
                <div data-reveal>
                  <p className={styles.connectLabel}>Based in</p>
                  <p style={{ color: 'var(--color-text-on-dark)', fontSize: 'var(--type-body-size)', lineHeight: 'var(--type-body-lh)' }}>New York City</p>
                </div>
              </SectionReveal>
              <SectionReveal className={styles.connectCtas}>
                <a href="mailto:hello@jrsuxd.com" className={`${styles.ctaCircle} ${styles.ctaFilled}`} data-reveal>
                  <span className={styles.ctaLabel}>Work<br />With Me</span>
                  <svg className={styles.ctaArrow} viewBox="0 0 24 24" fill="none"><path d="M7 17L17 7M17 7H7M17 7V17" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" /></svg>
                </a>
                <a href="/about" className={`${styles.ctaCircle} ${styles.ctaOutlined}`} data-reveal>
                  <span className={styles.ctaLabel}>Learn<br />More</span>
                  <svg className={styles.ctaArrow} viewBox="0 0 24 24" fill="none"><path d="M7 17L17 7M17 7H7M17 7V17" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" /></svg>
                </a>
              </SectionReveal>
            </div>
          </div>
        </section>
      </main>
    </>
  );
}
ENDOFFILE

# ============================================================
# src/app/page.module.css
# ============================================================
cat > src/app/page.module.css << 'ENDOFFILE'
.sectionInner {
  max-width: var(--max-width); margin: 0 auto;
  padding: 0 var(--grid-margin); position: relative; z-index: 2;
}

.sectionTitle {
  font-size: var(--type-display-size); line-height: var(--type-display-lh);
  font-weight: var(--type-display-weight); letter-spacing: var(--type-display-tracking);
  text-transform: uppercase; margin-bottom: var(--space-10);
}

/* HERO */
.hero {
  position: relative; min-height: 100vh; display: flex; align-items: flex-end;
  padding-bottom: var(--space-15); background-color: var(--color-bg-dark); overflow: hidden;
}
.heroInner {
  max-width: var(--max-width); margin: 0 auto;
  padding: 0 var(--grid-margin); padding-top: calc(var(--nav-height) + var(--space-20));
  position: relative; z-index: 2; width: 100%;
}
.heroHeadline {
  font-size: var(--type-h1-size); line-height: var(--type-h1-lh);
  font-weight: var(--type-h1-weight); letter-spacing: var(--type-h1-tracking); max-width: 900px;
}
.heroName { color: #8B2252; }
.heroRole { color: var(--color-text-on-dark-secondary); }
.heroCta { margin-top: var(--space-6); }

/* WORK */
.work { background-color: var(--color-bg-dark); padding: var(--space-15) 0 var(--space-20); }
.workTitle { composes: sectionTitle; color: var(--color-text-on-dark); }
.workGrid { display: flex; flex-direction: column; gap: var(--space-1); }
.workFooter { display: flex; justify-content: flex-end; margin-top: var(--space-8); }

/* MUSINGS */
.musings { background-color: var(--color-bg-light); padding: var(--space-15) 0 var(--space-20); }
.musingsTitle { composes: sectionTitle; color: var(--color-text-primary); }
.musingsGrid { display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--grid-gutter); }
.musingFeatured { grid-column: 1 / -1; }
.musingCompact {}
.musingsFooter { display: flex; justify-content: center; margin-top: var(--space-10); }

/* CONNECT */
.connect {
  background-color: var(--color-bg-dark); min-height: 100vh;
  display: flex; align-items: center; padding: var(--space-20) 0; overflow: hidden;
}
.connectInner { max-width: var(--max-width); margin: 0 auto; padding: 0 var(--grid-margin); width: 100%; position: relative; z-index: 2; }
.connectHeadline {
  font-size: clamp(48px, 12vw, 200px); line-height: 0.85; font-weight: 800;
  letter-spacing: -0.04em; text-transform: uppercase;
  color: var(--color-text-on-dark); margin-bottom: var(--space-10);
}
.connectContent { display: grid; grid-template-columns: 2fr 3fr; gap: var(--grid-gutter); align-items: start; }
.connectInfo { display: flex; flex-direction: column; gap: var(--space-4); }
.connectLabel {
  font-size: var(--type-caption-size); color: var(--color-text-on-dark-tertiary);
  text-transform: uppercase; letter-spacing: 0.08em; font-weight: 500; margin-bottom: var(--space-1);
}
.connectEmail {
  font-size: var(--type-h3-size); line-height: var(--type-h3-lh);
  color: var(--color-text-on-dark); transition: color var(--duration-fast) ease;
}
.connectEmail:hover { color: var(--color-accent); }
.connectCtas { display: flex; justify-content: center; align-items: center; gap: var(--space-6); }

.ctaCircle {
  width: clamp(160px, 20vw, 280px); height: clamp(160px, 20vw, 280px);
  border-radius: 50%; display: flex; flex-direction: column;
  align-items: center; justify-content: center; gap: var(--space-1);
  text-decoration: none;
  transition: transform var(--duration-normal) var(--ease-out-expo), background-color var(--duration-normal) var(--ease-out-quart);
}
.ctaCircle:hover { transform: scale(1.05); }

.ctaFilled { background-color: var(--color-text-on-dark); color: var(--color-bg-dark); }
.ctaFilled:hover { background-color: var(--color-accent); }
.ctaOutlined { border: 1.5px solid var(--color-text-on-dark); color: var(--color-text-on-dark); background: transparent; }
.ctaOutlined:hover { border-color: var(--color-accent); color: var(--color-accent); }

.ctaLabel { font-size: var(--type-nav-size); font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; text-align: center; line-height: 1.3; }
.ctaArrow { width: 20px; height: 20px; }

/* RESPONSIVE */
@media (max-width: 1023px) {
  .hero { padding-bottom: var(--space-10); }
  .heroInner { padding-top: calc(var(--nav-height) + var(--space-12)); }
  .musingsGrid { grid-template-columns: repeat(2, 1fr); }
  .musingFeatured { grid-column: 1 / -1; }
  .connectContent { grid-template-columns: 1fr; }
  .connectCtas { justify-content: flex-start; margin-top: var(--space-6); }
  .connect { min-height: auto; padding: var(--space-12) 0; }
}

@media (max-width: 767px) {
  .hero { min-height: 80vh; padding-bottom: var(--space-8); }
  .heroInner { padding-top: calc(var(--nav-height) + var(--space-10)); }
  .musingsGrid { grid-template-columns: 1fr; }
  .connectCtas { flex-direction: column; align-items: flex-start; gap: var(--space-3); }
  .ctaCircle { width: 160px; height: 160px; }
}
ENDOFFILE

# ============================================================
# Scaffold pages
# ============================================================
for page in work about musings contact; do
  TITLE="$(tr '[:lower:]' '[:upper:]' <<< ${page:0:1})${page:1}"
  cat > "src/app/${page}/page.tsx" << ENDOFFILE
import Nav from '@/components/Nav/Nav';
export const metadata = { title: '${TITLE}' };
export default function ${TITLE}Page() {
  return (
    <>
      <Nav />
      <main style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', paddingTop: 'var(--nav-height)' }}>
        <h1 style={{ fontSize: 'var(--type-display-size)', fontWeight: 800, letterSpacing: '-0.03em', color: 'var(--color-text-on-dark)', textTransform: 'uppercase' }}>${TITLE}</h1>
      </main>
    </>
  );
}
ENDOFFILE
done

# Work [slug] page
cat > 'src/app/work/[slug]/page.tsx' << 'ENDOFFILE'
import Nav from '@/components/Nav/Nav';
import { projects } from '@/lib/projects';
import { notFound } from 'next/navigation';

interface Props { params: Promise<{ slug: string }>; }

export async function generateStaticParams() {
  return projects.map((p) => ({ slug: p.slug }));
}

export default async function ProjectPage({ params }: Props) {
  const { slug } = await params;
  const project = projects.find((p) => p.slug === slug);
  if (!project) notFound();

  return (
    <>
      <Nav />
      <main style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', paddingTop: 'var(--nav-height)', gap: 16 }}>
        <h1 style={{ fontSize: 'var(--type-h1-size)', fontWeight: 600, color: 'var(--color-text-on-dark)', maxWidth: 700, textAlign: 'center', padding: '0 var(--grid-margin)' }}>{project.title}</h1>
        <p style={{ fontSize: 'var(--type-caption-size)', color: 'rgba(255,255,255,0.6)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{project.client} · {project.category}</p>
      </main>
    </>
  );
}
ENDOFFILE

# ============================================================
# Done!
# ============================================================
echo ""
echo "✅ All files written! Now run:"
echo ""
echo "   npm install"
echo "   npm run dev"
echo ""
echo "Then open http://localhost:3000"
echo ""
echo "🎹 Press Ctrl+G to toggle grid dev mode"
echo ""