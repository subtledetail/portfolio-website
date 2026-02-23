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
