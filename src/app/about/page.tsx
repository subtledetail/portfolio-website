import Nav from '@/components/Nav/Nav';
export const metadata = { title: 'About' };
export default function AboutPage() {
  return (
    <>
      <Nav />
      <main style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', paddingTop: 'var(--nav-height)' }}>
        <h1 style={{ fontSize: 'var(--type-display-size)', fontWeight: 800, letterSpacing: '-0.03em', color: 'var(--color-text-on-dark)', textTransform: 'uppercase' }}>About</h1>
      </main>
    </>
  );
}
