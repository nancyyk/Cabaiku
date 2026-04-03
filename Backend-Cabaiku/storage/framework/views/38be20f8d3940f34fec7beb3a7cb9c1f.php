<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk — Cabaiku</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Fraunces:ital,opsz,wght@0,9..144,600;0,9..144,700;1,9..144,500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root{--primary:#C0392B;--primary-dark:#922B21;--font-display:'Fraunces',serif;--font-body:'Plus Jakarta Sans',sans-serif;}
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:var(--font-body);min-height:100vh;display:flex;background:#F8F9FA;}
        .split{display:flex;min-height:100vh;width:100%;}
        .visual{flex:1;display:none;background:linear-gradient(145deg,#922B21 0%,#C0392B 45%,#E74C3C 100%);position:relative;overflow:hidden;align-items:center;justify-content:center;padding:60px;}
        @media(min-width:900px){.visual{display:flex;}}
        .visual::before{content:'';position:absolute;inset:0;background:url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.06'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E");}
        .vc{position:relative;z-index:1;color:#fff;max-width:380px;}
        .vc-logo{font-family:var(--font-display);font-size:2.4rem;font-weight:700;margin-bottom:36px;}
        .vc-logo span{font-style:italic;color:rgba(255,255,255,.65);}
        .vc h1{font-family:var(--font-display);font-size:2.6rem;line-height:1.15;font-weight:700;margin-bottom:16px;}
        .vc p{font-size:.95rem;color:rgba(255,255,255,.75);line-height:1.65;margin-bottom:36px;}
        .feat-list{display:flex;flex-direction:column;gap:12px;}
        .feat{display:flex;align-items:center;gap:14px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.15);padding:14px 18px;border-radius:12px;}
        .feat-icon{width:40px;height:40px;background:rgba(255,255,255,.15);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0;}
        .feat-text strong{display:block;font-size:.875rem;margin-bottom:2px;}
        .feat-text span{font-size:.78rem;color:rgba(255,255,255,.68);}
        /* Form panel */
        .form-panel{width:100%;max-width:480px;display:flex;align-items:center;justify-content:center;padding:40px 32px;background:#fff;}
        @media(min-width:900px){.form-panel{min-width:440px;}}
        .form-inner{width:100%;max-width:380px;}
        .mobile-logo{display:block;text-align:center;margin-bottom:28px;font-family:var(--font-display);font-size:2rem;font-weight:700;color:var(--primary);text-decoration:none;}
        @media(min-width:900px){.mobile-logo{display:none;}}
        .form-title{font-family:var(--font-display);font-size:1.75rem;font-weight:700;color:#1A1D23;margin-bottom:6px;}
        .form-sub{font-size:.875rem;color:#6B7280;margin-bottom:28px;}
        .fg{margin-bottom:18px;}
        .lbl{display:block;margin-bottom:6px;font-size:.875rem;font-weight:600;color:#374151;}
        .inp-wrap{position:relative;}
        .inp-icon{position:absolute;left:14px;top:50%;transform:translateY(-50%);color:#9CA3AF;font-size:.875rem;pointer-events:none;}
        .inp{width:100%;padding:12px 14px 12px 42px;border:1.5px solid #E5E7EB;border-radius:10px;font-family:var(--font-body);font-size:.9rem;color:#1A1D23;outline:none;transition:all .2s;background:#F9FAFB;}
        .inp:focus{border-color:var(--primary);background:#fff;box-shadow:0 0 0 3px rgba(192,57,43,.1);}
        .inp.err{border-color:#EF4444;}
        .toggle-pw{position:absolute;right:14px;top:50%;transform:translateY(-50%);background:none;border:none;color:#9CA3AF;cursor:pointer;padding:4px;font-size:.9rem;}
        .err-msg{font-size:.78rem;color:#DC2626;margin-top:5px;display:block;}
        .alert-box{background:#FEF2F2;border:1px solid #FECACA;color:#991B1B;padding:12px 14px;border-radius:10px;margin-bottom:20px;font-size:.875rem;display:flex;align-items:center;gap:10px;}
        .rem-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:22px;}
        .rem-label{display:flex;align-items:center;gap:8px;font-size:.875rem;color:#374151;cursor:pointer;}
        .rem-label input{width:16px;height:16px;accent-color:var(--primary);cursor:pointer;}
        .btn-sub{width:100%;padding:13px;background:var(--primary);color:#fff;border:none;border-radius:10px;font-family:var(--font-body);font-size:.95rem;font-weight:700;cursor:pointer;transition:all .2s;box-shadow:0 4px 14px rgba(192,57,43,.35);}
        .btn-sub:hover{background:var(--primary-dark);transform:translateY(-1px);}
        .divider{text-align:center;margin:22px 0;position:relative;color:#9CA3AF;font-size:.85rem;}
        .divider::before{content:'';position:absolute;left:0;top:50%;width:100%;height:1px;background:#E5E7EB;}
        .divider span{background:#fff;padding:0 14px;position:relative;}
        .switch{text-align:center;font-size:.875rem;color:#6B7280;}
        .switch a{color:var(--primary);font-weight:600;text-decoration:none;}
        .switch a:hover{text-decoration:underline;}
    </style>
</head>
<body>
<div class="split">
    <div class="visual">
        <div class="vc">
            <div class="vc-logo">Cabai<span>ku</span></div>
            <h1>Jaga Kesehatan Tanaman Cabaimu</h1>
            <p>Deteksi penyakit secara otomatis, pantau lahan, dan dapatkan panduan dari para ahli.</p>
            <div class="feat-list">
                <div class="feat"><div class="feat-icon">🔬</div><div class="feat-text"><strong>Deteksi AI Akurat</strong><span>Identifikasi penyakit dengan akurasi tinggi</span></div></div>
                <div class="feat"><div class="feat-icon">🌱</div><div class="feat-text"><strong>Panduan Lengkap</strong><span>Tips & artikel dari pakar agronomi</span></div></div>
                <div class="feat"><div class="feat-icon">📊</div><div class="feat-text"><strong>Riwayat Deteksi</strong><span>Pantau perkembangan kesehatan tanaman</span></div></div>
            </div>
        </div>
    </div>
    <div class="form-panel">
        <div class="form-inner">
            <a href="#" class="mobile-logo">🌶️ Cabaiku</a>
            <div class="form-title">Selamat Datang!</div>
            <div class="form-sub">Masuk ke akun Cabaiku Anda</div>

            <?php if($errors->any()): ?>
            <div class="alert-box"><i class="fa-solid fa-circle-exclamation"></i> <?php echo e($errors->first()); ?></div>
            <?php endif; ?>

            <form method="POST" action="<?php echo e(route('login.post')); ?>">
                <?php echo csrf_field(); ?>
                <div class="fg">
                    <label class="lbl">Email</label>
                    <div class="inp-wrap">
                        <i class="fa-solid fa-envelope inp-icon"></i>
                        <input type="email" name="email" class="inp <?php echo e($errors->has('email') ? 'err' : ''); ?>" placeholder="nama@email.com" value="<?php echo e(old('email')); ?>" required>
                    </div>
                </div>
                <div class="fg">
                    <label class="lbl">Password</label>
                    <div class="inp-wrap">
                        <i class="fa-solid fa-lock inp-icon"></i>
                        <input type="password" name="password" id="pw" class="inp" placeholder="Masukkan password" required>
                        <button type="button" class="toggle-pw" onclick="togglePw('pw',this)"><i class="fa-solid fa-eye"></i></button>
                    </div>
                </div>
                <div class="rem-row">
                    <label class="rem-label"><input type="checkbox" name="remember"> Ingat saya</label>
                </div>
                <button type="submit" class="btn-sub"><i class="fa-solid fa-right-to-bracket" style="margin-right:8px;"></i>Masuk</button>
            </form>
            <div class="divider"><span>atau</span></div>
            <div class="switch">Belum punya akun? <a href="<?php echo e(route('register')); ?>">Daftar Sekarang</a></div>
        </div>
    </div>
</div>
<script>
function togglePw(id,btn){const i=document.getElementById(id),ic=btn.querySelector('i');i.type=i.type==='password'?'text':'password';ic.className=i.type==='password'?'fa-solid fa-eye':'fa-solid fa-eye-slash';}
</script>
</body>
</html>
<?php /**PATH C:\Users\lapto\Documents\SEMESTER 4\workshop laravel\uas\cabaiku_laravel12\cabaiku\resources\views/auth/login.blade.php ENDPATH**/ ?>