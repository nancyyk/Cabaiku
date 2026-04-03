<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar — Cabaiku</title>
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
        .vc-logo{font-family:var(--font-display);font-size:2.4rem;font-weight:700;margin-bottom:28px;}
        .vc-logo span{font-style:italic;color:rgba(255,255,255,.65);}
        .vc h1{font-family:var(--font-display);font-size:2.4rem;line-height:1.2;font-weight:700;margin-bottom:14px;}
        .vc p{font-size:.95rem;color:rgba(255,255,255,.75);line-height:1.65;margin-bottom:28px;}
        .steps{display:flex;flex-direction:column;gap:12px;}
        .step{display:flex;align-items:center;gap:14px;padding:12px 16px;border-radius:10px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.15);}
        .step-num{width:32px;height:32px;border-radius:50%;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;font-weight:700;font-size:.9rem;flex-shrink:0;}
        .step strong{display:block;font-size:.875rem;margin-bottom:1px;}
        .step span{font-size:.78rem;color:rgba(255,255,255,.68);}
        /* Form */
        .form-panel{width:100%;display:flex;align-items:center;justify-content:center;padding:32px 24px;background:#fff;overflow-y:auto;}
        @media(min-width:900px){.form-panel{max-width:520px;min-width:480px;}}
        .form-inner{width:100%;max-width:440px;}
        .mobile-logo{display:block;text-align:center;margin-bottom:20px;font-family:var(--font-display);font-size:2rem;font-weight:700;color:var(--primary);text-decoration:none;}
        @media(min-width:900px){.mobile-logo{display:none;}}
        .form-title{font-family:var(--font-display);font-size:1.7rem;font-weight:700;color:#1A1D23;margin-bottom:4px;}
        .form-sub{font-size:.875rem;color:#6B7280;margin-bottom:22px;}
        .form-sub a{color:var(--primary);font-weight:600;text-decoration:none;}
        .sec-label{font-size:.72rem;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:#9CA3AF;margin:18px 0 12px;padding-bottom:8px;border-bottom:1px solid #F3F4F6;}
        .row2{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
        @media(max-width:500px){.row2{grid-template-columns:1fr;}}
        .fg{margin-bottom:14px;}
        .lbl{display:block;margin-bottom:6px;font-size:.875rem;font-weight:600;color:#374151;}
        .inp-wrap{position:relative;}
        .inp-icon{position:absolute;left:14px;top:50%;transform:translateY(-50%);color:#9CA3AF;font-size:.875rem;pointer-events:none;}
        .inp{width:100%;padding:11px 14px 11px 42px;border:1.5px solid #E5E7EB;border-radius:10px;font-family:var(--font-body);font-size:.875rem;color:#1A1D23;outline:none;transition:all .2s;background:#F9FAFB;}
        .inp:focus{border-color:var(--primary);background:#fff;box-shadow:0 0 0 3px rgba(192,57,43,.1);}
        .inp.err{border-color:#EF4444;}
        .toggle-pw{position:absolute;right:14px;top:50%;transform:translateY(-50%);background:none;border:none;color:#9CA3AF;cursor:pointer;font-size:.875rem;}
        .err-msg{font-size:.77rem;color:#DC2626;margin-top:4px;display:block;}
        .btn-sub{width:100%;padding:13px;background:var(--primary);color:#fff;border:none;border-radius:10px;font-family:var(--font-body);font-size:.95rem;font-weight:700;cursor:pointer;transition:all .2s;box-shadow:0 4px 14px rgba(192,57,43,.35);margin-top:8px;}
        .btn-sub:hover{background:var(--primary-dark);transform:translateY(-1px);}
        .divider{text-align:center;margin:18px 0;position:relative;color:#9CA3AF;font-size:.85rem;}
        .divider::before{content:'';position:absolute;left:0;top:50%;width:100%;height:1px;background:#E5E7EB;}
        .divider span{background:#fff;padding:0 14px;position:relative;}
        .switch{text-align:center;font-size:.875rem;color:#6B7280;}
        .switch a{color:var(--primary);font-weight:600;text-decoration:none;}
    </style>
</head>
<body>
<div class="split">
    <div class="visual">
        <div class="vc">
            <div class="vc-logo">Cabai<span>ku</span></div>
            <h1>Mulai Perjalanan Bertanimu</h1>
            <p>Bergabung dengan petani cabai yang merasakan manfaat teknologi AI untuk lahan mereka.</p>
            <div class="steps">
                <div class="step"><div class="step-num">1</div><div><strong>Buat Akun</strong><span>Daftar gratis dalam 1 menit</span></div></div>
                <div class="step"><div class="step-num">2</div><div><strong>Tambah Lahan</strong><span>Daftarkan lahan cabai Anda</span></div></div>
                <div class="step"><div class="step-num">3</div><div><strong>Foto & Deteksi</strong><span>Upload foto, hasil instan</span></div></div>
                <div class="step"><div class="step-num">4</div><div><strong>Ikuti Rekomendasi</strong><span>Tangani penyakit dengan tepat</span></div></div>
            </div>
        </div>
    </div>
    <div class="form-panel">
        <div class="form-inner">
            <a href="#" class="mobile-logo">🌶️ Cabaiku</a>
            <div class="form-title">Buat Akun Baru</div>
            <div class="form-sub">Sudah punya akun? <a href="{{ route('login') }}">Masuk di sini</a></div>
            <form method="POST" action="{{ route('register.post') }}">
                @csrf
                <div class="sec-label">Informasi Akun</div>
                <div class="fg">
                    <label class="lbl">Nama Lengkap <span style="color:#EF4444">*</span></label>
                    <div class="inp-wrap">
                        <i class="fa-solid fa-user inp-icon"></i>
                        <input type="text" name="name" class="inp {{ $errors->has('name') ? 'err' : '' }}" placeholder="Nama lengkap Anda" value="{{ old('name') }}" required>
                    </div>
                    @error('name')<span class="err-msg">{{ $message }}</span>@enderror
                </div>
                <div class="fg">
                    <label class="lbl">Email <span style="color:#EF4444">*</span></label>
                    <div class="inp-wrap">
                        <i class="fa-solid fa-envelope inp-icon"></i>
                        <input type="email" name="email" class="inp {{ $errors->has('email') ? 'err' : '' }}" placeholder="nama@email.com" value="{{ old('email') }}" required>
                    </div>
                    @error('email')<span class="err-msg">{{ $message }}</span>@enderror
                </div>
                <div class="row2">
                    <div class="fg">
                        <label class="lbl">Password <span style="color:#EF4444">*</span></label>
                        <div class="inp-wrap">
                            <i class="fa-solid fa-lock inp-icon"></i>
                            <input type="password" name="password" id="pw1" class="inp {{ $errors->has('password') ? 'err' : '' }}" placeholder="Min. 8 karakter" required>
                            <button type="button" class="toggle-pw" onclick="togglePw('pw1',this)"><i class="fa-solid fa-eye"></i></button>
                        </div>
                        @error('password')<span class="err-msg">{{ $message }}</span>@enderror
                    </div>
                    <div class="fg">
                        <label class="lbl">Konfirmasi <span style="color:#EF4444">*</span></label>
                        <div class="inp-wrap">
                            <i class="fa-solid fa-lock inp-icon"></i>
                            <input type="password" name="password_confirmation" id="pw2" class="inp" placeholder="Ulangi password" required>
                            <button type="button" class="toggle-pw" onclick="togglePw('pw2',this)"><i class="fa-solid fa-eye"></i></button>
                        </div>
                    </div>
                </div>
                <div class="sec-label">Informasi Tambahan (Opsional)</div>
                <div class="row2">
                    <div class="fg">
                        <label class="lbl">No. Telepon</label>
                        <div class="inp-wrap">
                            <i class="fa-solid fa-phone inp-icon"></i>
                            <input type="tel" name="phone" class="inp" placeholder="08xxxxxxxxxx" value="{{ old('phone') }}">
                        </div>
                    </div>
                    <div class="fg">
                        <label class="lbl">Lokasi / Kota</label>
                        <div class="inp-wrap">
                            <i class="fa-solid fa-location-dot inp-icon"></i>
                            <input type="text" name="location" class="inp" placeholder="Kota, Provinsi" value="{{ old('location') }}">
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn-sub"><i class="fa-solid fa-user-plus" style="margin-right:8px;"></i>Buat Akun Sekarang</button>
            </form>
            <div class="divider"><span>sudah punya akun?</span></div>
            <div class="switch"><a href="{{ route('login') }}">Masuk ke Cabaiku</a></div>
        </div>
    </div>
</div>
<script>
function togglePw(id,btn){const i=document.getElementById(id),ic=btn.querySelector('i');i.type=i.type==='password'?'text':'password';ic.className=i.type==='password'?'fa-solid fa-eye':'fa-solid fa-eye-slash';}
</script>
</body>
</html>
