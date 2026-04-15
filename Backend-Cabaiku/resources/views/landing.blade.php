<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cabaiku - Sistem Deteksi Penyakit Cabai</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Fraunces:ital,opsz,wght@0,9..144,600;0,9..144,700;1,9..144,500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root{--primary:#C0392B;--primary-dark:#922B21;--font-display:'Fraunces',serif;--font-body:'Plus Jakarta Sans',sans-serif;}
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:var(--font-body);color:#1A1D23;line-height:1.6;}
        .navbar{background:#fff;box-shadow:0 2px 8px rgba(0,0,0,.08);position:sticky;top:0;z-index:100;}
        .nav-container{max-width:1200px;margin:0 auto;padding:0 24px;display:flex;align-items:center;justify-content:space-between;height:70px;}
        .logo{font-family:var(--font-display);font-size:1.8rem;font-weight:700;color:var(--primary);text-decoration:none;}
        .logo span{font-style:italic;color:rgba(192,57,43,.6);}
        .nav-links{display:none;list-style:none;gap:32px;}
        @media(min-width:768px){.nav-links{display:flex;}}
        .nav-links a{color:#1A1D23;text-decoration:none;font-weight:500;font-size:.95rem;transition:color .2s;}
        .nav-links a:hover{color:var(--primary);}
        .nav-buttons{display:flex;gap:12px;align-items:center;}
        .btn{padding:10px 20px;border-radius:8px;font-family:var(--font-body);font-weight:600;font-size:.9rem;text-decoration:none;cursor:pointer;border:none;transition:all .2s;display:inline-block;}
        .btn-login{color:var(--primary);background:transparent;border:1.5px solid var(--primary);}
        .btn-login:hover{background:var(--primary);color:#fff;}
        .btn-register{background:var(--primary);color:#fff;box-shadow:0 4px 14px rgba(192,57,43,.35);}
        .btn-register:hover{background:var(--primary-dark);transform:translateY(-2px);}
        .menu-toggle{display:none;background:none;border:none;cursor:pointer;font-size:1.5rem;color:#1A1D23;}
        @media(max-width:768px){.menu-toggle{display:block;}.nav-links{flex-direction:column;}}
        .hero{min-height:100vh;background:linear-gradient(145deg,#922B21 0%,#C0392B 45%,#E74C3C 100%);display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden;padding:40px 24px;}
        .hero::before{content:'';position:absolute;inset:0;background:url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.06'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E");pointer-events:none;}
        .hero-content{position:relative;z-index:1;max-width:700px;text-align:center;color:#fff;}
        .hero-title{font-family:var(--font-display);font-size:3.5rem;line-height:1.1;font-weight:700;margin-bottom:20px;}
        @media(max-width:768px){.hero-title{font-size:2.5rem;}}
        .hero-subtitle{font-size:1.2rem;margin-bottom:40px;opacity:.95;line-height:1.6;}
        .hero-buttons{display:flex;gap:16px;justify-content:center;flex-wrap:wrap;}
        .btn-hero{padding:14px 32px;font-size:1rem;font-weight:700;border-radius:10px;text-decoration:none;border:none;cursor:pointer;transition:all .2s;display:inline-block;}
        .btn-hero-primary{background:#fff;color:var(--primary);box-shadow:0 8px 24px rgba(0,0,0,.15);}
        .btn-hero-primary:hover{transform:translateY(-3px);box-shadow:0 12px 32px rgba(0,0,0,.2);}
        .btn-hero-secondary{background:transparent;color:#fff;border:2px solid #fff;}
        .btn-hero-secondary:hover{background:rgba(255,255,255,.1);}
        .features{padding:80px 24px;max-width:1200px;margin:0 auto;}
        .section-title{font-family:var(--font-display);font-size:2.5rem;font-weight:700;text-align:center;margin-bottom:50px;color:#1A1D23;}
        .features-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:32px;}
        .feature-card{background:#F8F9FA;padding:32px;border-radius:16px;text-align:center;transition:all .3s;border:1px solid #E5E7EB;}
        .feature-card:hover{transform:translateY(-8px);box-shadow:0 12px 24px rgba(192,57,43,.12);border-color:var(--primary);}
        .feature-icon{font-size:3rem;margin-bottom:16px;}
        .feature-card h3{font-family:var(--font-display);font-size:1.3rem;margin-bottom:12px;color:#1A1D23;}
        .feature-card p{color:#6B7280;font-size:.95rem;line-height:1.6;}
        .how-it-works{background:#F8F9FA;padding:80px 24px;}
        .how-it-works-container{max-width:1200px;margin:0 auto;}
        .steps-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:24px;margin-top:50px;}
        .step-card{background:#fff;padding:28px;border-radius:12px;text-align:center;border:2px solid #E5E7EB;position:relative;}
        .step-number{width:50px;height:50px;background:var(--primary);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:1.5rem;font-weight:700;margin:0 auto 16px;}
        .step-card h3{font-family:var(--font-display);font-size:1.2rem;margin-bottom:10px;color:#1A1D23;}
        .step-card p{color:#6B7280;font-size:.9rem;}
        .cta{background:linear-gradient(145deg,#922B21 0%,#C0392B 100%);color:#fff;padding:80px 24px;text-align:center;}
        .cta-content{max-width:600px;margin:0 auto;}
        .cta h2{font-family:var(--font-display);font-size:2.5rem;margin-bottom:20px;}
        .cta p{font-size:1.1rem;margin-bottom:40px;opacity:.95;}
        .footer{background:#1A1D23;color:#fff;padding:40px 24px;text-align:center;}
        .footer-content{max-width:1200px;margin:0 auto;}
        .footer-links{display:flex;justify-content:center;gap:24px;margin-bottom:20px;flex-wrap:wrap;}
        .footer-links a{color:#fff;text-decoration:none;font-size:.9rem;opacity:.8;transition:opacity .2s;}
        .footer-links a:hover{opacity:1;}
        .footer-copy{font-size:.9rem;opacity:.6;border-top:1px solid rgba(255,255,255,.1);padding-top:20px;}
        .mobile-menu{display:none;position:fixed;top:70px;left:0;right:0;background:#fff;padding:24px;box-shadow:0 4px 12px rgba(0,0,0,.1);z-index:99;}
        .mobile-menu.active{display:block;}
        .mobile-menu a{display:block;padding:12px 0;color:#1A1D23;text-decoration:none;border-bottom:1px solid #E5E7EB;}
        .mobile-menu .nav-buttons{flex-direction:column;margin-top:16px;gap:8px;}
        .mobile-menu .btn{width:100%;text-align:center;}
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="{{ route('home') }}" class="logo">🌶️ Cabai<span>ku</span></a>
            <ul class="nav-links">
                <li><a href="#fitur">Fitur</a></li>
                <li><a href="#cara-kerja">Alur Penggunaan</a></li>
                <li><a href="#tentang">Tentang</a></li>
            </ul>
            <div class="nav-buttons">
                <a href="{{ route('login') }}" class="btn btn-login"><i class="fas fa-sign-in-alt" style="margin-right:6px;"></i>Masuk</a>
                <a href="{{ route('register') }}" class="btn btn-register"><i class="fas fa-user-plus" style="margin-right:6px;"></i>Daftar</a>
            </div>
            <button class="menu-toggle" onclick="toggleMenu()"><i class="fas fa-bars"></i></button>
        </div>
        <div class="mobile-menu" id="mobileMenu">
            <a href="#fitur">Fitur</a>
            <a href="#cara-kerja">Alur Penggunaan</a>
            <a href="#tentang">Tentang</a>
            <div class="nav-buttons">
                <a href="{{ route('login') }}" class="btn btn-login">Masuk</a>
                <a href="{{ route('register') }}" class="btn btn-register">Daftar</a>
            </div>
        </div>
    </nav>

    <section class="hero">
        <div class="hero-content">
            <h1 class="hero-title">Sistem Deteksi Penyakit Tanaman Cabai</h1>
            <p class="hero-subtitle">Aplikasi ini membantu petani maupun mahasiswa pertanian
                                    dalam mengenali kondisi kesehatan tanaman cabai melalui
                                    analisis gambar secara otomatis.</p>
            <div class="hero-buttons">
                <a href="{{ route('register') }}" class="btn btn-hero btn-hero-primary"><i class="fas fa-rocket" style="margin-right:8px;"></i>Coba Sekarang</a>
                <a href="#fitur" class="btn btn-hero btn-hero-secondary"><i class="fas fa-info-circle" style="margin-right:8px;"></i>Pelajari Lebih Lanjut</a>
            </div>
        </div>
    </section>

    <section class="features" id="fitur">
        <h2 class="section-title">Fitur Unggulan</h2>
        <div class="features-grid">
            <div class="feature-card"><div class="feature-icon">🔬</div><h3>Deteksi AI Akurat</h3><p>Identifikasi penyakit cabai dengan akurasi tinggi menggunakan teknologi machine learning terdepan.</p></div>
            <div class="feature-card"><div class="feature-icon">📸</div><h3>Upload Foto Mudah</h3><p>Cukup ambil foto daun cabai yang terserang, dan AI akan menganalisis dalam hitungan detik.</p></div>
            <div class="feature-card"><div class="feature-icon">📊</div><h3>Riwayat Lengkap</h3><p>Pantau perkembangan kesehatan tanaman dan riwayat semua deteksi yang sudah dilakukan.</p></div>
            <div class="feature-card"><div class="feature-icon">🌱</div><h3>Panduan Perawatan</h3><p>Dapatkan rekomendasi penanganan penyakit yang tepat dari para ahli agronomi berpengalaman.</p></div>
            <div class="feature-card"><div class="feature-icon">🗺️</div><h3>Kelola Lahan</h3><p>Atur dan pantau data lahan cabai Anda dengan dashboard yang intuitif dan mudah digunakan.</p></div>
            <div class="feature-card"><div class="feature-icon">💡</div><h3>Tips & Artikel</h3><p>Baca artikel edukatif dan tips praktis untuk meningkatkan hasil panen Anda setiap hari.</p></div>
        </div>
    </section>

    <section class="how-it-works" id="cara-kerja">
        <div class="how-it-works-container">
            <h2 class="section-title">Alur Penggunaan</h2>
            <div class="steps-grid">
                <div class="step-card"><div class="step-number">1</div><h3>Buat Akun</h3><p>Daftar gratis dan buat akun Cabaiku Anda dalam waktu kurang dari 1 menit.</p></div>
                <div class="step-card"><div class="step-number">2</div><h3>Tambah Lahan</h3><p>Daftarkan informasi lahan cabai Anda untuk memulai monitoring dan deteksi.</p></div>
                <div class="step-card"><div class="step-number">3</div><h3>Foto & Deteksi</h3><p>Upload foto daun yang terserang, dan AI akan memberikan hasil analisis instan.</p></div>
                <div class="step-card"><div class="step-number">4</div><h3>Ikuti Rekomendasi</h3><p>Dapatkan panduan penanganan dan pantau perkembangan kesehatan tanaman Anda.</p></div>
            </div>
        </div>
    </section>

    <section class="cta" id="tentang">
        <div class="cta-content">
            <h2>Mari Pantau Kesehatan Tanaman Cabai Lebih Mudah</h2>
            <p>Aplikasi ini membantu pengguna mengenali kondisi tanaman cabai
            sejak dini melalui analisis gambar berbasis AI. Dengan pemantauan
            yang lebih sederhana, diharapkan perawatan tanaman menjadi lebih
            tepat dan hasil panen dapat terjaga dengan baik.</p>
            <a href="{{ route('register') }}" class="btn btn-hero btn-hero-primary"><i class="fas fa-user-plus" style="margin-right:8px;"></i>Daftar Sekarang</a>
        </div>
    </section>

    <footer class="footer">
        <div class="footer-content">
            <div class="footer-links">
                <a href="#fitur">Fitur</a>
                <a href="#cara-kerja">Cara Kerja</a>
                <a href="#tentang">Tentang Kami</a>
            </div>
            <div class="footer-copy">© 2024 Cabaiku. Semua hak dilindungi. Teknologi untuk pertanian yang lebih baik.</div>
        </div>
    </footer>

    <script>
function toggleMenu(){const m=document.getElementById('mobileMenu');m.classList.toggle('active');}
document.querySelectorAll('.mobile-menu a').forEach(l=>{l.addEventListener('click',()=>{document.getElementById('mobileMenu').classList.remove('active');});});
document.querySelectorAll('a[href^="#"]').forEach(a=>{a.addEventListener('click',function(e){e.preventDefault();const t=document.querySelector(this.getAttribute('href'));if(t){t.scrollIntoView({behavior:'smooth'});}});});
    </script>
</body>
</html>
