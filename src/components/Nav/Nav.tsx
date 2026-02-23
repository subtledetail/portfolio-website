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
