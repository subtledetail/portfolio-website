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
