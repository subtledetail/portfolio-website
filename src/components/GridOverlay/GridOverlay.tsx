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
