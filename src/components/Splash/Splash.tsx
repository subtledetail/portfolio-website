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
