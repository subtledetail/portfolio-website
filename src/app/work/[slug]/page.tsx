import Nav from '@/components/Nav/Nav';
import { projects } from '@/lib/projects';
import { notFound } from 'next/navigation';

interface Props { params: Promise<{ slug: string }>; }

export async function generateStaticParams() {
  return projects.map((p) => ({ slug: p.slug }));
}

export default async function ProjectPage({ params }: Props) {
  const { slug } = await params;
  const project = projects.find((p) => p.slug === slug);
  if (!project) notFound();

  return (
    <>
      <Nav />
      <main style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', paddingTop: 'var(--nav-height)', gap: 16 }}>
        <h1 style={{ fontSize: 'var(--type-h1-size)', fontWeight: 600, color: 'var(--color-text-on-dark)', maxWidth: 700, textAlign: 'center', padding: '0 var(--grid-margin)' }}>{project.title}</h1>
        <p style={{ fontSize: 'var(--type-caption-size)', color: 'rgba(255,255,255,0.6)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{project.client} · {project.category}</p>
      </main>
    </>
  );
}
