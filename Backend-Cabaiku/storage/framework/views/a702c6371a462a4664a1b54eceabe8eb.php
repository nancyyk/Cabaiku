<?php $__env->startSection('title','Riwayat Deteksi'); ?>
<?php $__env->startSection('styles'); ?>
<style>
.stat-row{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:28px;}
.sb{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:18px 14px;text-align:center;box-shadow:var(--shadow-sm);}
.sb-num{font-size:2rem;font-weight:800;color:var(--text);line-height:1;margin-bottom:4px;}
.sb-num.g{color:var(--success);} .sb-num.r{color:var(--danger);}
.sb-label{font-size:.72rem;color:var(--text-muted);font-weight:500;}
.rlist{display:flex;flex-direction:column;gap:10px;margin-bottom:28px;}
.ritem{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:16px 18px;display:flex;align-items:center;gap:14px;box-shadow:var(--shadow-sm);transition:all .2s;}
.ritem:hover{box-shadow:var(--shadow);border-color:#D1D5DB;}
.ricon{width:42px;height:42px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0;}
.ricon.sehat{background:#ECFDF5;} .ricon.sakit{background:#FEF3C7;} .ricon.berat{background:#FEF2F2;}
.rcontent{flex:1;min-width:0;}
.rhasil{font-weight:700;font-size:.9rem;color:var(--text);margin-bottom:4px;}
.rmeta{display:flex;align-items:center;gap:10px;flex-wrap:wrap;}
.rmeta-item{font-size:.73rem;color:var(--text-muted);display:flex;align-items:center;gap:4px;}
.del-btn{width:34px;height:34px;border-radius:10px;background:#FEF2F2;border:1px solid #FECACA;display:flex;align-items:center;justify-content:center;color:var(--danger);cursor:pointer;font-size:.85rem;transition:all .2s;flex-shrink:0;}
.del-btn:hover{background:#FEE2E2;transform:scale(1.05);}
.empty{text-align:center;padding:60px 20px;}
</style>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('content'); ?>
<div class="page-header"><h1>🗂️ Riwayat Deteksi</h1><p>Lihat semua hasil deteksi penyakit tanaman cabai Anda</p></div>
<div class="stat-row">
    <div class="sb"><div class="sb-num"><?php echo e($totalDeteksi); ?></div><div class="sb-label">Total Deteksi</div></div>
    <div class="sb"><div class="sb-num g"><i class="fa-solid fa-circle-check" style="font-size:1.2rem;"></i> <?php echo e($tanamanSehat); ?></div><div class="sb-label">Tanaman Sehat</div></div>
    <div class="sb"><div class="sb-num r"><i class="fa-solid fa-circle-exclamation" style="font-size:1.2rem;"></i> <?php echo e($terdeteksiPenyakit); ?></div><div class="sb-label">Terdeteksi Penyakit</div></div>
</div>
<?php if($riwayats->isEmpty()): ?>
<div class="empty"><div style="font-size:3rem;margin-bottom:16px;opacity:.4;">📷</div><h3 style="font-weight:700;margin-bottom:8px;">Belum Ada Riwayat</h3><p style="color:var(--text-muted);margin-bottom:20px;">Anda belum melakukan deteksi penyakit.</p><a href="<?php echo e(route('deteksi')); ?>" class="btn btn-primary"><i class="fa-solid fa-camera"></i> Mulai Deteksi</a></div>
<?php else: ?>
<div class="rlist">
    <?php $__currentLoopData = $riwayats; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $r): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
    <?php $isS=$r->hasil==='Sehat'; $isB=$r->tingkat_keparahan==='Berat'; $ic=$isS?'sehat':($isB?'berat':'sakit'); $em=$isS?'✅':($isB?'🚨':'⚠️'); ?>
    <div class="ritem">
        <div class="ricon <?php echo e($ic); ?>"><?php echo e($em); ?></div>
        <div class="rcontent">
            <div class="rhasil"><?php echo e($r->hasil); ?></div>
            <div class="rmeta">
                <span class="badge badge-<?php echo e(strtolower($r->tingkat_keparahan)); ?>"><?php echo e($r->tingkat_keparahan); ?></span>
                <div class="rmeta-item"><i class="fa-solid fa-bullseye"></i> <?php echo e($r->akurasi); ?>%</div>
                <div class="rmeta-item"><i class="fa-regular fa-calendar"></i> <?php echo e($r->created_at->translatedFormat('d M Y')); ?></div>
                <div class="rmeta-item"><i class="fa-regular fa-clock"></i> <?php echo e($r->created_at->format('H:i')); ?></div>
                <?php if($r->lahan): ?><div class="rmeta-item"><i class="fa-solid fa-location-dot"></i> <?php echo e($r->lahan->nama_lahan); ?></div><?php endif; ?>
            </div>
        </div>
        <form method="POST" action="<?php echo e(route('riwayat.destroy',$r->id)); ?>" onsubmit="return confirm('Hapus riwayat ini?')">
            <?php echo csrf_field(); ?> <?php echo method_field('DELETE'); ?>
            <button type="submit" class="del-btn"><i class="fa-solid fa-trash"></i></button>
        </form>
    </div>
    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
</div>
<?php if($riwayats->hasPages()): ?>
<div style="display:flex;justify-content:center;gap:6px;margin-bottom:32px;">
    <?php if(!$riwayats->onFirstPage()): ?><a href="<?php echo e($riwayats->previousPageUrl()); ?>" class="btn btn-secondary btn-sm"><i class="fa-solid fa-chevron-left"></i></a><?php endif; ?>
    <span style="display:flex;align-items:center;font-size:.875rem;color:var(--text-muted);padding:0 12px;">Hal <?php echo e($riwayats->currentPage()); ?> / <?php echo e($riwayats->lastPage()); ?></span>
    <?php if($riwayats->hasMorePages()): ?><a href="<?php echo e($riwayats->nextPageUrl()); ?>" class="btn btn-secondary btn-sm"><i class="fa-solid fa-chevron-right"></i></a><?php endif; ?>
</div>
<?php endif; ?>
<?php endif; ?>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Users\lapto\Documents\SEMESTER 4\workshop laravel\uas\cabaiku_laravel12\cabaiku\resources\views/pages/riwayat.blade.php ENDPATH**/ ?>