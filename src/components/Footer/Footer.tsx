import styles from './Footer.module.css';

export default function Footer() {
  return (
    <footer className={styles.footer}>
      <div className={styles.inner}>
        <div>
          <p className={styles.copyright}>&copy; {new Date().getFullYear()} Jason Reid Scott</p>
          <p className={styles.tagline}>Built with obsessive grid discipline</p>
        </div>
        <div className={styles.social}>
          {['Li', '𝕏', 'Dr'].map(s => (
            <a key={s} href="#" className={styles.socialLink}>{s}</a>
          ))}
        </div>
      </div>
    </footer>
  );
}
