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
