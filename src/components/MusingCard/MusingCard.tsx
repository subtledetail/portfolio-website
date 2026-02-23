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
