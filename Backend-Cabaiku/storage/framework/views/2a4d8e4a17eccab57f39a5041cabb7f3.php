
<?php $__env->startSection('title','Profil Saya'); ?>
<?php $__env->startSection('styles'); ?>
<style>
.pcard{background:var(--surface);border-radius:var(--radius-lg);border:1px solid var(--border);box-shadow:var(--shadow-sm);overflow:hidden;margin-bottom:20px;}
.pheader{background:linear-gradient(135deg,#922B21 0%,#C0392B 55%,#E74C3C 100%);padding:32px 24px;text-align:center;position:relative;}
.pheader::before{content:'';position:absolute;inset:0;background:url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M20 20c5.523 0 10-4.477 10-10S25.523 0 20 0 10 4.477 10 10s4.477 10 10 10z'/%3E%3C/g%3E%3C/svg%3E");}
.pavatar{width:80px;height:80px;border-radius:50%;background:rgba(255,255,255,.2);border:3px solid rgba(255,255,255,.4);display:flex;align-items:center;justify-content:center;font-size:1.8rem;font-weight:700;color:#fff;margin:0 auto 14px;position:relative;z-index:1;font-family:var(--font-display);}
.pname{font-family:var(--font-display);font-size:1.4rem;font-weight:700;color:#fff;margin-bottom:4px;position:relative;z-index:1;}
.psince{font-size:.8rem;color:rgba(255,255,255,.7);position:relative;z-index:1;}
.pstats{display:grid;grid-template-columns:repeat(3,1fr);border-top:1px solid var(--border);}
.pstat{padding:16px;text-align:center;border-right:1px solid var(--border);}
.pstat:last-child{border-right:none;}
.pstat-num{font-size:1.5rem;font-weight:800;color:var(--text);}
.pstat-label{font-size:.7rem;color:var(--text-muted);margin-top:2px;}
.info-list{padding:0 20px;}
.irow{display:flex;align-items:center;gap:14px;padding:14px 0;border-bottom:1px solid var(--border);}
.irow:last-child{border-bottom:none;}
.irow-icon{width:36px;height:36px;border-radius:10px;background:var(--surface3);display:flex;align-items:center;justify-content:center;color:var(--text-muted);font-size:.875rem;flex-shrink:0;}
.irow-label{font-size:.7rem;color:var(--text-muted);font-weight:500;margin-bottom:2px;}
.irow-val{font-size:.9rem;font-weight:600;color:var(--text);}
.edit-btn{width:calc(100% - 40px);margin:16px 20px 20px;padding:12px;border-radius:10px;background:var(--text);color:#fff;border:none;font-family:var(--font-body);font-size:.875rem;font-weight:700;cursor:pointer;transition:all .2s;display:flex;align-items:center;justify-content:center;gap:8px;}
.edit-btn:hover{background:#111;transform:translateY(-1px);}
.sec{background:var(--surface);border-radius:var(--radius);border:1px solid var(--border);box-shadow:var(--shadow-sm);margin-bottom:14px;overflow:hidden;}
.sec-hd{display:flex;align-items:center;gap:12px;padding:16px 20px;cursor:pointer;user-select:none;border-bottom:1px solid transparent;transition:all .2s;}
.sec-hd:hover{background:var(--surface3);}
.sec-hd.open{border-bottom-color:var(--border);}
.sec-ic{width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:.9rem;flex-shrink:0;}
.si-r{background:var(--primary-bg);color:var(--primary);}
.si-b{background:#EFF6FF;color:#2563EB;}
.si-y{background:#FFFBEB;color:#D97706;}
.sec-label{font-weight:700;font-size:.9rem;flex:1;}
.sec-chev{color:var(--text-muted);font-size:.8rem;transition:transform .2s;}
.sec-body{display:none;padding:20px;}
.sec-body.open{display:block;}
.lang-opt{display:flex;align-items:center;gap:12px;padding:14px;border:1.5px solid var(--border);border-radius:10px;cursor:pointer;transition:all .2s;margin-bottom:10px;}
.lang-opt.sel{border-color:var(--primary);background:var(--primary-bg);}
.lang-opt input{width:18px;height:18px;accent-color:var(--primary);}
.logout-btn{width:100%;padding:14px;background:#FEF2F2;color:var(--danger);border:1.5px solid #FECACA;border-radius:12px;font-family:var(--font-body);font-size:.9rem;font-weight:700;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:10px;transition:all .2s;margin-bottom:32px;}
.logout-btn:hover{background:#FEE2E2;}
</style>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('content'); ?>
<div class="page-header"><h1>👤 Profil Saya</h1><p>Kelola informasi akun Anda</p></div>

<div class="pcard">
    <div class="pheader">
        <div class="pavatar"><?php echo e(strtoupper(substr($user->name,0,1))); ?><?php echo e(strtoupper(substr(strstr($user->name.' ',' '),1,1))); ?></div>
        <div class="pname"><?php echo e($user->name); ?></div>
        <div class="psince">Bergabung sejak <?php echo e($user->created_at->translatedFormat('F Y')); ?></div>
    </div>
    <div class="pstats">
        <div class="pstat"><div class="pstat-num"><?php echo e($totalDeteksi); ?></div><div class="pstat-label">Total Deteksi</div></div>
        <div class="pstat"><div class="pstat-num"><?php echo e($artikelDibaca); ?></div><div class="pstat-label">Artikel Dibaca</div></div>
        <div class="pstat"><div class="pstat-num"><?php echo e($hariAktif); ?></div><div class="pstat-label">Hari Aktif</div></div>
    </div>
    <div class="info-list">
        <div class="irow"><div class="irow-icon"><i class="fa-solid fa-user"></i></div><div><div class="irow-label">Nama Lengkap</div><div class="irow-val"><?php echo e($user->name); ?></div></div></div>
        <div class="irow"><div class="irow-icon"><i class="fa-solid fa-envelope"></i></div><div><div class="irow-label">Email</div><div class="irow-val"><?php echo e($user->email); ?></div></div></div>
        <div class="irow"><div class="irow-icon"><i class="fa-solid fa-phone"></i></div><div><div class="irow-label">No. Telepon</div><div class="irow-val"><?php echo e($user->phone ?? '-'); ?></div></div></div>
        <div class="irow"><div class="irow-icon"><i class="fa-solid fa-location-dot"></i></div><div><div class="irow-label">Lokasi</div><div class="irow-val"><?php echo e($user->location ?? '-'); ?></div></div></div>
    </div>
    <button class="edit-btn" onclick="toggleSec('edit')"><i class="fa-solid fa-pen-to-square"></i> Edit Profil</button>
</div>

<!-- Edit Profil -->
<div class="sec" id="sec-edit" style="display:none;">
    <div class="sec-hd open"><div class="sec-ic si-r"><i class="fa-solid fa-pen"></i></div><span class="sec-label">Edit Informasi Profil</span><i class="fa-solid fa-chevron-down sec-chev" style="transform:rotate(180deg);"></i></div>
    <div class="sec-body open">
        <form method="POST" action="<?php echo e(route('profil.update')); ?>"><?php echo csrf_field(); ?>
            <div class="form-group"><label class="form-label">Nama Lengkap</label><input type="text" name="name" class="form-control <?php $__errorArgs = ['name'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" value="<?php echo e(old('name',$user->name)); ?>" required><?php $__errorArgs = ['name'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?><span class="invalid-feedback"><?php echo e($message); ?></span><?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?></div>
            <div class="form-group"><label class="form-label">Email</label><input type="email" name="email" class="form-control <?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" value="<?php echo e(old('email',$user->email)); ?>" required><?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?><span class="invalid-feedback"><?php echo e($message); ?></span><?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?></div>
            <div class="form-group"><label class="form-label">No. Telepon</label><input type="tel" name="phone" class="form-control" value="<?php echo e(old('phone',$user->phone)); ?>" placeholder="08xxxxxxxxxx"></div>
            <div class="form-group" style="margin-bottom:0;"><label class="form-label">Lokasi / Kota</label><input type="text" name="location" class="form-control" value="<?php echo e(old('location',$user->location)); ?>" placeholder="Kota, Provinsi"></div>
            <div style="margin-top:16px;"><button type="submit" class="btn btn-primary btn-block"><i class="fa-solid fa-check"></i> Simpan Perubahan</button></div>
        </form>
    </div>
</div>

<!-- Ubah Password -->
<div class="sec">
    <div class="sec-hd" onclick="toggleSec('pw')"><div class="sec-ic si-b"><i class="fa-solid fa-lock"></i></div><span class="sec-label">Ubah Password</span><i class="fa-solid fa-chevron-down sec-chev" id="chev-pw"></i></div>
    <div class="sec-body" id="body-pw">
        <form method="POST" action="<?php echo e(route('profil.password')); ?>"><?php echo csrf_field(); ?>
            <div class="form-group"><label class="form-label">Password Saat Ini</label><input type="password" name="current_password" class="form-control <?php $__errorArgs = ['current_password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" placeholder="Masukkan password lama"><?php $__errorArgs = ['current_password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?><span class="invalid-feedback"><?php echo e($message); ?></span><?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?></div>
            <div class="form-group"><label class="form-label">Password Baru</label><input type="password" name="password" class="form-control <?php $__errorArgs = ['password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" placeholder="Min. 8 karakter"><?php $__errorArgs = ['password'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?><span class="invalid-feedback"><?php echo e($message); ?></span><?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?></div>
            <div class="form-group" style="margin-bottom:0;"><label class="form-label">Konfirmasi Password Baru</label><input type="password" name="password_confirmation" class="form-control" placeholder="Ulangi password baru"></div>
            <div style="margin-top:16px;"><button type="submit" class="btn btn-primary btn-block"><i class="fa-solid fa-shield-halved"></i> Ubah Password</button></div>
        </form>
    </div>
</div>

<!-- Bahasa -->
<div class="sec">
    <div class="sec-hd" onclick="toggleSec('lang')"><div class="sec-ic si-y"><i class="fa-solid fa-globe"></i></div><span class="sec-label">Bahasa / Language</span><i class="fa-solid fa-chevron-down sec-chev" id="chev-lang"></i></div>
    <div class="sec-body" id="body-lang">
        <form method="POST" action="<?php echo e(route('profil.bahasa')); ?>"><?php echo csrf_field(); ?>
            <p style="font-size:.875rem;color:var(--text-muted);margin-bottom:14px;">Pilih bahasa yang ingin Anda gunakan:</p>
            <label class="lang-opt <?php echo e($user->bahasa=='id' ? 'sel' : ''); ?>" id="lo-id" onclick="selLang('id')">
                <input type="radio" name="bahasa_r" <?php echo e($user->bahasa=='id' ? 'checked' : ''); ?>>
                <span style="font-size:1.2rem;">🇮🇩</span>
                <div><div style="font-weight:600;font-size:.875rem;">Bahasa Indonesia</div><div style="font-size:.75rem;color:var(--text-muted);">Indonesian</div></div>
            </label>
            <label class="lang-opt <?php echo e($user->bahasa=='en' ? 'sel' : ''); ?>" id="lo-en" onclick="selLang('en')">
                <input type="radio" name="bahasa_r" <?php echo e($user->bahasa=='en' ? 'checked' : ''); ?>>
                <span style="font-size:1.2rem;">🇬🇧</span>
                <div><div style="font-weight:600;font-size:.875rem;">English</div><div style="font-size:.75rem;color:var(--text-muted);">Bahasa Inggris</div></div>
            </label>
            <input type="hidden" name="bahasa" id="bahasa-val" value="<?php echo e($user->bahasa); ?>">
            <button type="submit" class="btn btn-primary btn-block" style="margin-top:4px;"><i class="fa-solid fa-check"></i> Simpan Bahasa</button>
        </form>
    </div>
</div>

<!-- Logout -->
<form method="POST" action="<?php echo e(route('logout')); ?>" onsubmit="return confirm('Yakin ingin keluar?')">
    <?php echo csrf_field(); ?>
    <button type="submit" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Keluar dari Akun</button>
</form>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('scripts'); ?>
<script>
function toggleSec(id){
    if(id==='edit'){const s=document.getElementById('sec-edit');s.style.display=s.style.display==='none'?'block':'none';return;}
    const body=document.getElementById('body-'+id),chev=document.getElementById('chev-'+id);
    const open=body.classList.toggle('open');
    body.closest('.sec').querySelector('.sec-hd').classList.toggle('open',open);
    if(chev)chev.style.transform=open?'rotate(180deg)':'';
}
function selLang(l){
    document.getElementById('bahasa-val').value=l;
    ['id','en'].forEach(x=>{const el=document.getElementById('lo-'+x);el.classList.toggle('sel',x===l);el.querySelector('input').checked=x===l;});
}
<?php if($errors->has('name')||$errors->has('email')): ?> document.getElementById('sec-edit').style.display='block'; <?php endif; ?>
<?php if($errors->has('current_password')||$errors->has('password')): ?> document.getElementById('body-pw').classList.add('open');document.getElementById('chev-pw').style.transform='rotate(180deg)'; <?php endif; ?>
</script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\kuliah\semester4\projek semster 4\cabaikuSyafik\cabaiku\resources\views/pages/profil.blade.php ENDPATH**/ ?>