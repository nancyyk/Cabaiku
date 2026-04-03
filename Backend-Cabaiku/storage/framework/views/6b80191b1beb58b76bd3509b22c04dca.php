<?php $__env->startSection('title','Deteksi Penyakit'); ?>
<?php $__env->startSection('styles'); ?>
<style>
.upload-zone{border:2.5px dashed var(--border);border-radius:var(--radius-lg);padding:44px 24px;text-align:center;transition:all .25s;cursor:pointer;background:var(--surface);position:relative;overflow:hidden;}
.upload-zone:hover,.upload-zone.dragover{border-color:var(--primary);background:var(--primary-bg);}
.upload-zone input[type="file"]{position:absolute;inset:0;opacity:0;cursor:pointer;width:100%;height:100%;}
.upload-icon{width:68px;height:68px;border-radius:20px;background:linear-gradient(135deg,var(--primary-bg),#FECDD3);display:flex;align-items:center;justify-content:center;font-size:1.8rem;margin:0 auto 14px;box-shadow:0 4px 16px rgba(192,57,43,.2);}
.upload-title{font-weight:700;font-size:1rem;color:var(--text);margin-bottom:6px;}
.upload-sub{font-size:.83rem;color:var(--text-muted);margin-bottom:12px;}
.upload-fmt{font-size:.76rem;color:var(--text-light);}
.preview-wrap{position:relative;}
.preview-img{width:100%;max-height:280px;object-fit:cover;border-radius:var(--radius);border:2px solid var(--primary-light);}
.remove-preview{position:absolute;top:10px;right:10px;width:32px;height:32px;background:rgba(0,0,0,.6);border-radius:50%;border:none;color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:.875rem;transition:all .2s;}
.remove-preview:hover{background:rgba(192,57,43,.9);}
.tips-box{background:linear-gradient(135deg,#EFF6FF,#DBEAFE);border:1px solid #93C5FD;border-radius:var(--radius);padding:18px 20px;margin-top:20px;}
.tips-box-title{font-size:.875rem;font-weight:700;color:#1E40AF;margin-bottom:12px;display:flex;align-items:center;gap:8px;}
.tip-item{display:flex;align-items:flex-start;gap:8px;margin-bottom:8px;font-size:.83rem;color:#1E3A8A;}
.tip-item:last-child{margin-bottom:0;}
.tip-dot{width:6px;height:6px;border-radius:50%;background:#3B82F6;flex-shrink:0;margin-top:5px;}
.lahan-opt{display:flex;align-items:center;gap:14px;padding:14px 16px;border-radius:12px;border:1.5px solid var(--border);background:var(--surface);cursor:pointer;transition:all .2s;margin-bottom:8px;}
.lahan-opt:hover,.lahan-opt.sel{border-color:var(--primary);background:var(--primary-bg);}
.lahan-opt input[type="radio"]{accent-color:var(--primary);width:18px;height:18px;flex-shrink:0;}
.lahan-opt-icon{width:36px;height:36px;border-radius:10px;background:#ECFDF5;display:flex;align-items:center;justify-content:center;color:#059669;flex-shrink:0;}
.lahan-opt-name{font-weight:600;font-size:.875rem;}
.lahan-opt-sub{font-size:.73rem;color:var(--text-muted);}
</style>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('content'); ?>
<div class="page-header">
    <h1>🔬 Deteksi Penyakit Cabai</h1>
    <p>Upload foto tanaman cabai untuk mendeteksi penyakit secara otomatis</p>
</div>

<?php if($lahans->isEmpty()): ?>
<div class="card"><div class="card-body" style="text-align:center;padding:36px;">
    <div style="font-size:2.5rem;margin-bottom:12px;">🌿</div>
    <div style="font-weight:700;margin-bottom:8px;">Belum Ada Lahan Terdaftar</div>
    <p style="font-size:.875rem;color:var(--text-muted);margin-bottom:20px;">Silakan tambahkan lahan terlebih dahulu di halaman Beranda.</p>
    <a href="<?php echo e(route('beranda')); ?>" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Tambah Lahan</a>
</div></div>
<?php else: ?>
<form method="POST" action="<?php echo e(route('deteksi.store')); ?>" enctype="multipart/form-data" id="deteksi-form">
    <?php echo csrf_field(); ?>
    <!-- Pilih Lahan -->
    <div class="card" style="margin-bottom:20px;">
        <div class="card-header"><span class="card-title"><i class="fa-solid fa-map-location-dot" style="color:var(--primary);margin-right:8px;"></i>Pilih Lahan</span></div>
        <div class="card-body">
            <p style="font-size:.83rem;color:var(--text-muted);margin-bottom:14px;">Pilih lahan yang akan dilakukan deteksi</p>
            <?php $__errorArgs = ['lahan_id'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?><div style="background:#FEF2F2;border:1px solid #FECACA;color:#991B1B;padding:10px 14px;border-radius:8px;font-size:.83rem;margin-bottom:12px;"><i class="fa-solid fa-circle-exclamation"></i> <?php echo e($message); ?></div><?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
            <?php $__currentLoopData = $lahans; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $lahan): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <label class="lahan-opt <?php echo e(old('lahan_id')==$lahan->id ? 'sel' : ''); ?>" id="lo-<?php echo e($lahan->id); ?>">
                <input type="radio" name="lahan_id" value="<?php echo e($lahan->id); ?>" <?php echo e(old('lahan_id')==$lahan->id ? 'checked' : ''); ?> onchange="selLahan(<?php echo e($lahan->id); ?>)">
                <div class="lahan-opt-icon"><i class="fa-solid fa-leaf"></i></div>
                <div style="flex:1;">
                    <div class="lahan-opt-name"><?php echo e($lahan->nama_lahan); ?></div>
                    <div class="lahan-opt-sub"><i class="fa-solid fa-location-dot"></i> <?php echo e($lahan->lokasi); ?><?php echo e($lahan->luas ? ' · '.$lahan->luas.' Ha' : ''); ?></div>
                </div>
                <i class="fa-solid fa-circle-check" style="color:var(--primary);opacity:<?php echo e(old('lahan_id')==$lahan->id ? 1 : 0); ?>;" id="chk-<?php echo e($lahan->id); ?>"></i>
            </label>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </div>
    </div>

    <!-- Upload Gambar -->
    <div class="card" style="margin-bottom:20px;">
        <div class="card-header"><span class="card-title"><i class="fa-solid fa-image" style="color:var(--primary);margin-right:8px;"></i>Upload Foto Tanaman</span></div>
        <div class="card-body">
            <?php $__errorArgs = ['gambar'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?><div style="background:#FEF2F2;border:1px solid #FECACA;color:#991B1B;padding:10px 14px;border-radius:8px;font-size:.83rem;margin-bottom:12px;"><i class="fa-solid fa-circle-exclamation"></i> <?php echo e($message); ?></div><?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
            <div id="upload-area">
                <div class="upload-zone" id="drop-zone" onclick="document.getElementById('gambar-inp').click()">
                    <input type="file" name="gambar" id="gambar-inp" accept="image/jpg,image/jpeg,image/png,image/webp" onchange="previewImg(this)">
                    <div class="upload-icon">📷</div>
                    <div class="upload-title">Klik atau seret foto di sini</div>
                    <div class="upload-sub">Upload foto bagian tanaman yang ingin dideteksi</div>
                    <div class="upload-fmt">Format: JPG, JPEG, PNG, WEBP · Maks. 5MB</div>
                </div>
            </div>
            <div id="preview-area" style="display:none;" class="preview-wrap">
                <img id="preview-img" src="" alt="Preview" class="preview-img">
                <button type="button" class="remove-preview" onclick="removePreview()"><i class="fa-solid fa-xmark"></i></button>
            </div>
        </div>
    </div>

    <!-- Catatan -->
    <div class="card" style="margin-bottom:20px;">
        <div class="card-body">
            <div class="form-group" style="margin-bottom:0;">
                <label class="form-label"><i class="fa-solid fa-note-sticky" style="color:var(--text-muted);margin-right:6px;"></i>Catatan (Opsional)</label>
                <textarea name="catatan" class="form-control" placeholder="cth: Daun mulai menguning sejak 3 hari lalu..."><?php echo e(old('catatan')); ?></textarea>
            </div>
        </div>
    </div>

    <div class="tips-box">
        <div class="tips-box-title"><i class="fa-solid fa-circle-info"></i> Tips Foto Terbaik</div>
        <div class="tip-item"><div class="tip-dot"></div><span>Ambil foto dengan pencahayaan yang cukup, hindari bayangan</span></div>
        <div class="tip-item"><div class="tip-dot"></div><span>Fokuskan pada bagian tanaman yang menunjukkan gejala</span></div>
        <div class="tip-item"><div class="tip-dot"></div><span>Pastikan foto tidak buram atau terlalu gelap</span></div>
        <div class="tip-item"><div class="tip-dot"></div><span>Ambil dari jarak 20-30 cm untuk detail yang jelas</span></div>
    </div>

    <div style="margin-top:20px;margin-bottom:12px;">
        <button type="submit" class="btn btn-primary btn-block btn-lg" id="submit-btn">
            <i class="fa-solid fa-magnifying-glass"></i> Mulai Deteksi Sekarang
        </button>
    </div>
</form>
<?php endif; ?>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('scripts'); ?>
<script>
function previewImg(input){if(input.files&&input.files[0]){const r=new FileReader();r.onload=e=>{document.getElementById('preview-img').src=e.target.result;document.getElementById('upload-area').style.display='none';document.getElementById('preview-area').style.display='block';};r.readAsDataURL(input.files[0]);}}
function removePreview(){document.getElementById('gambar-inp').value='';document.getElementById('upload-area').style.display='block';document.getElementById('preview-area').style.display='none';}
function selLahan(id){document.querySelectorAll('.lahan-opt').forEach(c=>c.classList.remove('sel'));document.querySelectorAll('[id^="chk-"]').forEach(i=>i.style.opacity='0');document.getElementById('lo-'+id).classList.add('sel');document.getElementById('chk-'+id).style.opacity='1';}
const dz=document.getElementById('drop-zone');
if(dz){dz.addEventListener('dragover',e=>{e.preventDefault();dz.classList.add('dragover');});dz.addEventListener('dragleave',()=>dz.classList.remove('dragover'));dz.addEventListener('drop',e=>{e.preventDefault();dz.classList.remove('dragover');const f=e.dataTransfer.files;if(f.length>0){document.getElementById('gambar-inp').files=f;previewImg(document.getElementById('gambar-inp'));}});}
document.getElementById('deteksi-form')?.addEventListener('submit',function(){const btn=document.getElementById('submit-btn');btn.innerHTML='<i class="fa-solid fa-spinner fa-spin"></i> Sedang Menganalisis...';btn.disabled=true;});
</script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Users\lapto\Documents\SEMESTER 4\workshop laravel\uas\cabaiku_laravel12\cabaiku\resources\views\pages\deteksi.blade.php ENDPATH**/ ?>