#!/bin/bash
# ============================================================
# JRS_UXD Portfolio — Fix v1.1
# Fixes: invisible content, grid toggle, splash, reveals
# Run from ~/Desktop/portfolio-website
# ============================================================

set -e
echo "🔧 Applying v1.1 fixes..."

# ============================================================
# FIX 1: SectionReveal — content must be visible by default
# GSAP enhances it, but never gates visibility
# ============================================================
echo "  ✅ Fixing SectionReveal..."
cat > src/components/SectionReveal/SectionReveal.tsx << 'ENDOFFILE'
'use client';

import { useRef, useEffect, useState, type ReactNode } from 'react';

interface SectionRevealProps {
  children: ReactNode;
  stagger?: number;
  direction?: 'up' | 'left' | 'right' | 'fade';
  distance?: number;
  className?: string;
  triggerOffset?: string;
}

export default function SectionReveal({
  children,
  stagger = 0.08,
  direction = 'up',
  distance = 40,
  className = '',
  triggerOffset = 'top 85%',
}: SectionRevealProps) {
  const ref = useRef<HTMLDivElement>(null);
  const [gsapReady, setGsapReady] = useState(false);

  useEffect(() => {
    // Check for reduced motion
    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (prefersReduced) return;

    const el = ref.current;
    if (!el) return;

    let ctx: { revert: () => void } | null = null;

    const initAnimation = async () => {
      try {
        const gsapModule = await import('gsap');
        const scrollModule = await import('gsap/ScrollTrigger');
        const gsap = gsapModule.gsap;
        const ScrollTrigger = scrollModule.ScrollTrigger;
        gsap.registerPlugin(ScrollTrigger);

        const targets = el.querySelectorAll('[data-reveal]');
        const animTargets = targets.length > 0 ? Array.from(targets) : [el];

        // Set initial state
        gsap.set(animTargets, {
          opacity: 0,
          y: direction === 'up' ? distance : 0,
          x: direction === 'left' ? -distance : direction === 'right' ? distance : 0,
        });

        setGsapReady(true);

        // Create context for cleanup
        ctx = gsap.context(() => {
          gsap.to(animTargets, {
            opacity: 1,
            y: 0,
            x: 0,
            duration: 0.9,
            stagger,
            ease: 'power3.out',
            scrollTrigger: {
              trigger: el,
              start: triggerOffset,
              once: true,
            },
          });
        });
      } catch (e) {
        // If GSAP fails, content stays visible (no opacity:0 was set)
        console.warn('GSAP init failed, content visible by default', e);
      }
    };

    initAnimation();

    return () => {
      if (ctx) ctx.revert();
    };
  }, [direction, distance, stagger, triggerOffset]);

  // Content is always visible by default — GSAP hides then reveals
  return (
    <div ref={ref} className={className}>
      {children}
    </div>
  );
}
ENDOFFILE

# ============================================================
# FIX 2: GridOverlay — fix Cmd+G toggle on Mac
# ============================================================
echo "  ✅ Fixing GridOverlay toggle..."
cat > src/components/GridOverlay/GridOverlay.tsx << 'ENDOFFILE'
'use client';

import { useState, useEffect, useCallback } from 'react';
import styles from './GridOverlay.module.css';

export default function GridOverlay() {
  const [devMode, setDevMode] = useState(false);

  const handleKeydown = useCallback((e: KeyboardEvent) => {
    // Ctrl+G (Windows) or Cmd+G (Mac)
    if ((e.ctrlKey || e.metaKey) && (e.key === 'g' || e.key === 'G')) {
      e.preventDefault();
      e.stopPropagation();
      setDevMode((prev) => !prev);
    }
  }, []);

  useEffect(() => {
    document.addEventListener('keydown', handleKeydown, true);
    return () => document.removeEventListener('keydown', handleKeydown, true);
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
      {devMode && <div className={styles.badge}>GRID DEV MODE — Cmd+G to toggle</div>}
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
}

.column::before { left: 0; }
.column::after { right: 0; }
.column:first-child::before { opacity: 0.5; }
.column:last-child::after { opacity: 0.5; }

/* Dev mode: bright yellow lines */
.dev .column::before,
.dev .column::after {
  background-color: rgba(242, 235, 38, 0.5) !important;
  width: 2px;
}

.dev .column {
  background-color: rgba(242, 235, 38, 0.04);
}

.label {
  position: absolute;
  top: var(--space-1);
  left: 50%;
  transform: translateX(-50%);
  font-family: 'Inter', monospace;
  font-size: 11px;
  font-weight: 700;
  color: var(--color-accent);
  background: rgba(0, 0, 0, 0.8);
  padding: 2px 8px;
  border-radius: 3px;
  letter-spacing: 0.05em;
}

.badge {
  position: fixed;
  bottom: var(--space-2);
  left: 50%;
  transform: translateX(-50%);
  font-family: 'Inter', monospace;
  font-size: 11px;
  font-weight: 600;
  color: var(--color-bg-dark);
  background: var(--color-accent);
  padding: 4px 12px;
  border-radius: 4px;
  letter-spacing: 0.03em;
  z-index: 9999;
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
# FIX 3: Splash — simpler, more reliable CSS-based animation
# ============================================================
echo "  ✅ Fixing Splash sequence..."
cat > src/components/Splash/Splash.tsx << 'ENDOFFILE'
'use client';

import { useEffect, useState } from 'react';
import styles from './Splash.module.css';

interface SplashProps {
  onComplete: () => void;
}

export default function Splash({ onComplete }: SplashProps) {
  const [phase, setPhase] = useState<'enter' | 'letters' | 'exit' | 'done'>('enter');

  useEffect(() => {
    // Check reduced motion
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      setPhase('done');
      onComplete();
      return;
    }

    const t1 = setTimeout(() => setPhase('letters'), 100);
    const t2 = setTimeout(() => setPhase('exit'), 1600);
    const t3 = setTimeout(() => {
      setPhase('done');
      onComplete();
    }, 2200);

    return () => {
      clearTimeout(t1);
      clearTimeout(t2);
      clearTimeout(t3);
    };
  }, [onComplete]);

  if (phase === 'done') return null;

  const cols: (string[] | null)[] = [null, ['J', 'U'], ['R', 'X'], ['S', 'D'], null];

  return (
    <div
      className={`${styles.splash} ${phase === 'exit' ? styles.exit : ''}`}
      aria-hidden="true"
    >
      {cols.map((pair, i) => (
        <div
          key={i}
          className={`${styles.column} ${phase !== 'enter' ? styles.columnIn : ''}`}
          style={{ transitionDelay: `${i * 90}ms` }}
        >
          <div className={`${styles.inner} ${i === 0 || i === 4 ? styles.edge : ''}`}>
            {pair?.map((letter, j) => (
              <span
                key={j}
                className={`${styles.letter} ${j === 0 ? styles.top : styles.bottom} ${phase !== 'enter' ? styles.letterIn : ''}`}
                style={{ transitionDelay: `${400 + (i * 2 + j) * 50}ms` }}
              >
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
  position: fixed;
  inset: 0;
  z-index: var(--z-splash);
  background-color: var(--color-bg-dark);
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  overflow: hidden;
  transition: opacity 0.6s cubic-bezier(0.65, 0, 0.35, 1),
              transform 0.6s cubic-bezier(0.65, 0, 0.35, 1);
}

.exit {
  opacity: 0;
  transform: translateY(-3%);
}

.column {
  height: 100vh;
  transform: translateY(110%);
  transition: transform 0.7s cubic-bezier(0.16, 1, 0.3, 1);
}

.columnIn {
  transform: translateY(0);
}

.inner {
  width: 100%;
  height: 100%;
  background-color: #111;
  border-left: 1px solid rgba(255, 255, 255, 0.1);
  border-right: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 120px;
}

.edge {
  background-color: #0d0d0d;
}

.letter {
  font-family: 'Inter', sans-serif;
  font-size: clamp(48px, 10vw, 120px);
  font-weight: 800;
  color: #FFFFFF;
  letter-spacing: -0.03em;
  line-height: 1;
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.5s ease, transform 0.5s ease;
}

.letterIn {
  opacity: 1;
  transform: translateY(0);
}

.top {
  margin-bottom: auto;
  margin-top: 28%;
}

.bottom {
  margin-top: auto;
  margin-bottom: 28%;
}

@media (max-width: 767px) {
  .letter { font-size: clamp(28px, 8vw, 56px); }
  .inner { gap: 80px; }
}
ENDOFFILE

# ============================================================
# FIX 4: Home page — ensure hero content is always visible,
# match Figma layout more closely
# ============================================================
echo "  ✅ Fixing Home page layout..."
cat > src/app/page.tsx << 'ENDOFFILE'
'use client';

import { useState, useCallback } from 'react';
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
  const handleSplashComplete = useCallback(() => setSplashComplete(true), []);

  return (
    <>
      <Splash onComplete={handleSplashComplete} />
      <Nav splashActive={!splashComplete} />

      <main>
        {/* ===== HERO ===== */}
        <section className={styles.hero}>
          <AnimatedGradient />
          <div className={styles.heroInner}>
            <h1 className={styles.heroHeadline}>
              <span className={styles.heroName}>Jason Reid Scott</span>{' '}
              <span className={styles.heroRole}>
                is a hands-on design director &amp; UX strategist who builds products people love.
              </span>
            </h1>
            <div className={styles.heroCta}>
              <CircleArrow href="/work" label="View work" variant="outlined" size="md" onDark />
            </div>
          </div>
        </section>

        {/* ===== WORK ===== */}
        <section className={styles.work} id="work">
          <div className={styles.sectionInner}>
            <SectionReveal>
              <h2 className={styles.workTitle} data-reveal>Work</h2>
            </SectionReveal>
            <div className={styles.workGrid}>
              {projects.map((project, i) => (
                <SectionReveal key={project.slug}>
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

        {/* ===== MUSINGS ===== */}
        <section className={styles.musings} id="musings">
          <div className={styles.sectionInner}>
            <SectionReveal>
              <h2 className={styles.musingsTitle} data-reveal>Musings</h2>
            </SectionReveal>
            <div className={styles.musingsGrid}>
              {musings.map((musing, i) => (
                <SectionReveal key={musing.slug} className={i === 0 ? styles.musingFeatured : ''}>
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

        {/* ===== LET'S CONNECT ===== */}
        <section className={styles.connect} id="connect">
          <div className={styles.connectInner}>
            <SectionReveal direction="up" distance={60}>
              <h2 className={styles.connectHeadline} data-reveal>
                Let&rsquo;s<br />Connect /
              </h2>
            </SectionReveal>
            <div className={styles.connectContent}>
              <SectionReveal className={styles.connectInfo}>
                <div data-reveal>
                  <p className={styles.connectLabel}>Say hello</p>
                  <a href="mailto:hello@jrsuxd.com" className={styles.connectEmail}>hello@jrsuxd.com</a>
                </div>
                <div data-reveal>
                  <p className={styles.connectLabel}>Based in</p>
                  <p className={styles.connectDetail}>New York City</p>
                </div>
              </SectionReveal>
              <SectionReveal className={styles.connectCtas}>
                <a href="mailto:hello@jrsuxd.com" className={`${styles.ctaCircle} ${styles.ctaFilled}`} data-reveal>
                  <span className={styles.ctaLabel}>Work<br />With Me</span>
                  <svg className={styles.ctaArrow} viewBox="0 0 24 24" fill="none">
                    <path d="M7 17L17 7M17 7H7M17 7V17" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
                  </svg>
                </a>
                <a href="/about" className={`${styles.ctaCircle} ${styles.ctaOutlined}`} data-reveal>
                  <span className={styles.ctaLabel}>Learn<br />More</span>
                  <svg className={styles.ctaArrow} viewBox="0 0 24 24" fill="none">
                    <path d="M7 17L17 7M17 7H7M17 7V17" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
                  </svg>
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
# FIX 5: Page CSS — ensure hero content visible, better spacing
# ============================================================
echo "  ✅ Fixing page styles..."
cat > src/app/page.module.css << 'ENDOFFILE'
/* ============================================================
   HOME PAGE — All sections
   ============================================================ */

.sectionInner {
  max-width: var(--max-width);
  margin: 0 auto;
  padding: 0 var(--grid-margin);
  position: relative;
  z-index: 2;
}

.sectionTitle {
  font-size: var(--type-display-size);
  line-height: var(--type-display-lh);
  font-weight: var(--type-display-weight);
  letter-spacing: var(--type-display-tracking);
  text-transform: uppercase;
  margin-bottom: var(--space-10);
}

/* ===== HERO ===== */
.hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: flex-end;
  padding-bottom: var(--space-15);
  background-color: var(--color-bg-dark);
  overflow: hidden;
}

.heroInner {
  max-width: var(--max-width);
  margin: 0 auto;
  padding: 0 var(--grid-margin);
  padding-top: calc(var(--nav-height) + var(--space-20));
  position: relative;
  z-index: 2;
  width: 100%;
}

.heroHeadline {
  font-size: var(--type-h1-size);
  line-height: var(--type-h1-lh);
  font-weight: var(--type-h1-weight);
  letter-spacing: var(--type-h1-tracking);
  max-width: 900px;
}

.heroName {
  color: #8B2252;
}

.heroRole {
  color: var(--color-text-on-dark-secondary);
}

.heroCta {
  margin-top: var(--space-6);
}

/* ===== WORK ===== */
.work {
  background-color: var(--color-bg-dark);
  padding: var(--space-15) 0 var(--space-20);
}

.workTitle {
  composes: sectionTitle;
  color: var(--color-text-on-dark);
}

.workGrid {
  display: flex;
  flex-direction: column;
  gap: var(--space-1);
}

.workFooter {
  display: flex;
  justify-content: flex-end;
  margin-top: var(--space-8);
}

/* ===== MUSINGS ===== */
.musings {
  background-color: var(--color-bg-light);
  padding: var(--space-15) 0 var(--space-20);
}

.musingsTitle {
  composes: sectionTitle;
  color: var(--color-text-primary);
}

.musingsGrid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--grid-gutter);
}

.musingFeatured {
  grid-column: 1 / -1;
}

.musingsFooter {
  display: flex;
  justify-content: center;
  margin-top: var(--space-10);
}

/* ===== CONNECT ===== */
.connect {
  background-color: var(--color-bg-dark);
  min-height: 100vh;
  display: flex;
  align-items: center;
  padding: var(--space-20) 0;
  overflow: hidden;
}

.connectInner {
  max-width: var(--max-width);
  margin: 0 auto;
  padding: 0 var(--grid-margin);
  width: 100%;
  position: relative;
  z-index: 2;
}

.connectHeadline {
  font-size: clamp(48px, 12vw, 200px);
  line-height: 0.85;
  font-weight: 800;
  letter-spacing: -0.04em;
  text-transform: uppercase;
  color: var(--color-text-on-dark);
  margin-bottom: var(--space-10);
}

.connectContent {
  display: grid;
  grid-template-columns: 2fr 3fr;
  gap: var(--grid-gutter);
  align-items: start;
}

.connectInfo {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.connectLabel {
  font-size: var(--type-caption-size);
  color: var(--color-text-on-dark-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  font-weight: 500;
  margin-bottom: var(--space-1);
}

.connectEmail {
  font-size: var(--type-h3-size);
  line-height: var(--type-h3-lh);
  color: var(--color-text-on-dark);
  transition: color var(--duration-fast) ease;
}

.connectEmail:hover {
  color: var(--color-accent);
}

.connectDetail {
  color: var(--color-text-on-dark);
  font-size: var(--type-body-size);
  line-height: var(--type-body-lh);
}

.connectCtas {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: var(--space-6);
}

.ctaCircle {
  width: clamp(160px, 20vw, 280px);
  height: clamp(160px, 20vw, 280px);
  border-radius: 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--space-1);
  text-decoration: none;
  transition: transform var(--duration-normal) var(--ease-out-expo),
              background-color var(--duration-normal) var(--ease-out-quart),
              border-color var(--duration-normal) var(--ease-out-quart),
              color var(--duration-normal) var(--ease-out-quart);
}

.ctaCircle:hover {
  transform: scale(1.05);
}

.ctaFilled {
  background-color: var(--color-text-on-dark);
  color: var(--color-bg-dark);
}

.ctaFilled:hover {
  background-color: var(--color-accent);
}

.ctaOutlined {
  border: 1.5px solid var(--color-text-on-dark);
  color: var(--color-text-on-dark);
  background: transparent;
}

.ctaOutlined:hover {
  border-color: var(--color-accent);
  color: var(--color-accent);
}

.ctaLabel {
  font-size: var(--type-nav-size);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  text-align: center;
  line-height: 1.3;
}

.ctaArrow {
  width: 20px;
  height: 20px;
}

/* ===== RESPONSIVE ===== */
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
# FIX 6: Nav — ensure it appears after splash
# ============================================================
echo "  ✅ Fixing Nav visibility..."
cat > src/components/Nav/Nav.module.css << 'ENDOFFILE'
.header {
  position: fixed; top: 0; left: 0; right: 0;
  z-index: var(--z-nav);
  height: var(--nav-height);
  transition: transform var(--duration-normal) var(--ease-out-expo),
              background-color var(--duration-normal) var(--ease-out-quart),
              opacity 0.6s ease;
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

.link { display: block; padding: var(--space-1) var(--space-2); position: relative; }

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
  display: none; position: fixed; inset: 0;
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

echo ""
echo "✅ All fixes applied! Your dev server should hot-reload automatically."
echo "   If not, refresh http://localhost:3000"
echo ""
echo "   What to check:"
echo "   • Splash: 5 columns cascade in with J/R/S U/X/D letters"
echo "   • Hero: gradient + headline visible immediately"
echo "   • Cmd+G: yellow grid dev mode toggles"
echo "   • Scroll: Work, Musings, Connect sections all visible"
echo ""