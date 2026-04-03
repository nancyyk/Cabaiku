<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="<?php echo e(csrf_token()); ?>">
    <title><?php echo $__env->yieldContent('title', 'Cabaiku'); ?> — Deteksi Penyakit Cabai</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Fraunces:ital,opsz,wght@0,9..144,400;0,9..144,600;0,9..144,700;1,9..144,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary:#C0392B; --primary-dark:#922B21; --primary-light:#F1948A;
            --primary-bg:#FDEDEC; --accent:#E74C3C;
            --success:#27AE60; --warning:#E67E22; --danger:#C0392B;
            --surface:#FFFFFF; --surface2:#F8F9FA; --surface3:#F0F2F5;
            --border:#E5E8ED; --text:#1A1D23; --text-muted:#6B7280; --text-light:#9CA3AF;
            --shadow-sm:0 1px 3px rgba(0,0,0,.08);
            --shadow:0 4px 16px rgba(0,0,0,.10);
            --shadow-lg:0 12px 40px rgba(0,0,0,.14);
            --radius:14px; --radius-sm:8px; --radius-lg:20px;
            --font-display:'Fraunces',Georgia,serif;
            --font-body:'Plus Jakarta Sans',sans-serif;
            --nav-h:64px; --bottom-nav-h:68px;
        }
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:var(--font-body);background:var(--surface3);color:var(--text);min-height:100vh;}

        /* TOP NAV */
        .top-nav{position:fixed;top:0;left:0;right:0;height:var(--nav-h);background:var(--primary);display:flex;align-items:center;justify-content:space-between;padding:0 24px;z-index:1000;box-shadow:0 2px 12px rgba(192,57,43,.35);}
        .top-nav .brand{font-family:var(--font-display);font-size:1.5rem;font-weight:700;color:#fff;letter-spacing:-.02em;text-decoration:none;}
        .top-nav .brand span{color:#FDECEA;font-style:italic;}
        .btn-logout{display:flex;align-items:center;gap:8px;color:rgba(255,255,255,.85);font-size:.875rem;font-weight:500;background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.2);border-radius:8px;padding:7px 14px;cursor:pointer;text-decoration:none;transition:all .2s;}
        .btn-logout:hover{background:rgba(255,255,255,.22);color:#fff;}

        /* MAIN */
        .main-wrapper{padding-top:var(--nav-h);padding-bottom:calc(var(--bottom-nav-h) + 16px);min-height:100vh;}
        .page-container{max-width:1100px;margin:0 auto;padding:28px 20px 0;}

        /* BOTTOM NAV */
        .bottom-nav{position:fixed;bottom:0;left:0;right:0;height:var(--bottom-nav-h);background:#fff;border-top:1px solid var(--border);display:flex;align-items:center;justify-content:space-around;z-index:1000;box-shadow:0 -4px 20px rgba(0,0,0,.07);}
        .nav-item{display:flex;flex-direction:column;align-items:center;gap:4px;padding:8px 14px;text-decoration:none;color:var(--text-light);font-size:.7rem;font-weight:500;border-radius:12px;transition:all .2s;}
        .nav-item i{font-size:1.25rem;transition:all .2s;}
        .nav-item:hover{color:var(--primary);}
        .nav-item.active{color:var(--primary);background:var(--primary-bg);}
        .nav-item.active i{transform:scale(1.1);}

        /* ALERTS */
        .alert{display:flex;align-items:flex-start;gap:12px;padding:14px 16px;border-radius:var(--radius-sm);margin-bottom:20px;font-size:.875rem;animation:slideDown .3s ease;}
        .alert-success{background:#ECFDF5;border:1px solid #A7F3D0;color:#065F46;}
        .alert-error{background:#FEF2F2;border:1px solid #FECACA;color:#991B1B;}
        .alert-close{margin-left:auto;cursor:pointer;opacity:.6;}
        .alert-close:hover{opacity:1;}
        @keyframes slideDown{from{opacity:0;transform:translateY(-8px);}to{opacity:1;transform:translateY(0);}}

        /* BUTTONS */
        .btn{display:inline-flex;align-items:center;gap:8px;padding:10px 20px;border-radius:10px;font-family:var(--font-body);font-size:.875rem;font-weight:600;cursor:pointer;border:none;text-decoration:none;transition:all .2s;white-space:nowrap;}
        .btn-primary{background:var(--primary);color:#fff;box-shadow:0 4px 14px rgba(192,57,43,.35);}
        .btn-primary:hover{background:var(--primary-dark);transform:translateY(-1px);box-shadow:0 6px 20px rgba(192,57,43,.4);}
        .btn-secondary{background:var(--surface3);color:var(--text);border:1px solid var(--border);}
        .btn-secondary:hover{background:var(--border);}
        .btn-outline{background:transparent;color:var(--primary);border:1.5px solid var(--primary);}
        .btn-outline:hover{background:var(--primary-bg);}
        .btn-sm{padding:7px 14px;font-size:.8rem;}
        .btn-lg{padding:14px 28px;font-size:1rem;border-radius:12px;}
        .btn-block{width:100%;justify-content:center;}

        /* CARD */
        .card{background:var(--surface);border-radius:var(--radius);box-shadow:var(--shadow-sm);border:1px solid var(--border);overflow:hidden;}
        .card-body{padding:20px;}
        .card-header{padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
        .card-title{font-size:1rem;font-weight:700;color:var(--text);}

        /* FORMS */
        .form-group{margin-bottom:18px;}
        .form-label{display:block;margin-bottom:6px;font-size:.875rem;font-weight:600;color:var(--text);}
        .form-control{width:100%;padding:11px 14px;background:var(--surface);border:1.5px solid var(--border);border-radius:10px;font-family:var(--font-body);font-size:.9rem;color:var(--text);transition:border-color .2s,box-shadow .2s;outline:none;}
        .form-control:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(192,57,43,.12);}
        .form-control::placeholder{color:var(--text-light);}
        .form-control.is-invalid{border-color:var(--danger);}
        .invalid-feedback{font-size:.8rem;color:var(--danger);margin-top:5px;display:block;}
        textarea.form-control{resize:vertical;min-height:90px;}

        /* BADGES */
        .badge{display:inline-flex;align-items:center;gap:4px;padding:3px 10px;border-radius:20px;font-size:.75rem;font-weight:600;}
        .badge-ringan{background:#DCFCE7;color:#166534;}
        .badge-sedang{background:#FEF9C3;color:#854D0E;}
        .badge-berat{background:#FEE2E2;color:#991B1B;}
        .badge-primary{background:var(--primary-bg);color:var(--primary);}

        /* MODAL */
        .modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:2000;display:flex;align-items:center;justify-content:center;padding:20px;opacity:0;pointer-events:none;transition:opacity .25s;}
        .modal-overlay.active{opacity:1;pointer-events:all;}
        .modal{background:var(--surface);border-radius:var(--radius-lg);width:100%;max-width:500px;box-shadow:var(--shadow-lg);transform:scale(.95) translateY(10px);transition:all .25s;}
        .modal-overlay.active .modal{transform:scale(1) translateY(0);}
        .modal-header{display:flex;align-items:center;justify-content:space-between;padding:20px 24px 16px;border-bottom:1px solid var(--border);}
        .modal-title{font-size:1.1rem;font-weight:700;}
        .modal-close{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;background:var(--surface3);border:none;cursor:pointer;color:var(--text-muted);transition:all .2s;}
        .modal-close:hover{background:var(--border);}
        .modal-body{padding:20px 24px;}
        .modal-footer{padding:16px 24px 20px;display:flex;gap:10px;justify-content:flex-end;border-top:1px solid var(--border);}

        /* PAGE HEADER */
        .page-header{margin-bottom:28px;}
        .page-header h1{font-family:var(--font-display);font-size:1.8rem;font-weight:700;color:var(--text);letter-spacing:-.03em;margin-bottom:4px;}
        .page-header p{color:var(--text-muted);font-size:.9rem;}

        @media(max-width:640px){.page-container{padding:20px 14px 0;}.page-header h1{font-size:1.4rem;}}
    </style>
    <?php echo $__env->yieldContent('styles'); ?>
</head>
<body>
    <nav class="top-nav">
        <a href="<?php echo e(route('beranda')); ?>" class="brand">Cabai<span>ku</span></a>
        <form method="POST" action="<?php echo e(route('logout')); ?>">
            <?php echo csrf_field(); ?>
            <button type="submit" class="btn-logout">
                <i class="fa-solid fa-right-from-bracket"></i><span>Keluar</span>
            </button>
        </form>
    </nav>

    <div class="main-wrapper">
        <div class="page-container">
            <?php if(session('success')): ?>
            <div class="alert alert-success" id="flash-ok">
                <i class="fa-solid fa-circle-check"></i>
                <span><?php echo e(session('success')); ?></span>
                <span class="alert-close" onclick="this.closest('.alert').remove()"><i class="fa-solid fa-xmark"></i></span>
            </div>
            <?php endif; ?>
            <?php if(session('error')): ?>
            <div class="alert alert-error" id="flash-err">
                <i class="fa-solid fa-circle-exclamation"></i>
                <span><?php echo e(session('error')); ?></span>
                <span class="alert-close" onclick="this.closest('.alert').remove()"><i class="fa-solid fa-xmark"></i></span>
            </div>
            <?php endif; ?>
            <?php echo $__env->yieldContent('content'); ?>
        </div>
    </div>

    <nav class="bottom-nav">
        <a href="<?php echo e(route('beranda')); ?>"  class="nav-item <?php echo e(request()->routeIs('beranda')   ? 'active' : ''); ?>"><i class="fa-solid fa-house"></i><span>Beranda</span></a>
        <a href="<?php echo e(route('deteksi')); ?>"  class="nav-item <?php echo e(request()->routeIs('deteksi*')  ? 'active' : ''); ?>"><i class="fa-solid fa-camera"></i><span>Deteksi</span></a>
        <a href="<?php echo e(route('tips')); ?>"     class="nav-item <?php echo e(request()->routeIs('tips*')     ? 'active' : ''); ?>"><i class="fa-solid fa-book-open"></i><span>Tips</span></a>
        <a href="<?php echo e(route('riwayat')); ?>"  class="nav-item <?php echo e(request()->routeIs('riwayat*')  ? 'active' : ''); ?>"><i class="fa-solid fa-clock-rotate-left"></i><span>Riwayat</span></a>
        <a href="<?php echo e(route('profil')); ?>"   class="nav-item <?php echo e(request()->routeIs('profil*')   ? 'active' : ''); ?>"><i class="fa-solid fa-user"></i><span>Profil</span></a>
    </nav>

    <script>
        setTimeout(()=>{document.querySelectorAll('#flash-ok,#flash-err').forEach(el=>{el.style.transition='all .4s';el.style.opacity='0';setTimeout(()=>el.remove(),400);});},4000);
    </script>
    <?php echo $__env->yieldContent('scripts'); ?>
</body>
</html>
<?php /**PATH D:\kuliah\semester4\projek semster 4\cabaikuSyafik\cabaiku\resources\views/layouts/app.blade.php ENDPATH**/ ?>