import type { Metadata, Viewport } from 'next';
import '@/styles/globals.css';
import GridOverlay from '@/components/GridOverlay/GridOverlay';
import Footer from '@/components/Footer/Footer';

export const metadata: Metadata = {
  title: {
    default: 'JRS_UXD — Jason Reid Scott · Design Director & UX Strategist',
    template: '%s — JRS_UXD',
  },
  description: 'Portfolio of Jason Reid Scott — a hands-on design director & UX strategist who builds products people love.',
};

export const viewport: Viewport = {
  themeColor: '#0A0A0A',
  width: 'device-width',
  initialScale: 1,
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <GridOverlay />
        <div style={{ position: 'relative', zIndex: 2 }}>
          {children}
          <Footer />
        </div>
      </body>
    </html>
  );
}
