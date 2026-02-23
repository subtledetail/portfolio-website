import Nav from '@/components/Nav/Nav';
export const metadata = { title: 'Contact' };
export default function ContactPage() {
  return (
    <>
      <Nav />
      <main style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', paddingTop: 'var(--nav-height)' }}>
        <h1 style={{ fontSize: 'var(--type-display-size)', fontWeight: 800, letterSpacing: '-0.03em', color: 'var(--color-text-on-dark)', textTransform: 'uppercase' }}>Contact</h1>
      </main>
    </>
  );
}
