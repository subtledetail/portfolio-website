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
