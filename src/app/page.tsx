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
