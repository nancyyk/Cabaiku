<?php $__env->startSection('title', $artikel->judul); ?>
<?php $__env->startSection('styles'); ?>
<style>
.art-hero{width:100%;height:260px;object-fit:cover;border-radius:var(--radius-lg);margin-bottom:24px;}
.art-meta{display:flex;flex-wrap:wrap;align-items:center;gap:12px;margin-bottom:16px;}
.art-meta-item{display:flex;align-items:center;gap:6px;font-size:.79rem;color:var(--text-muted);}
.art-title{font-family:var(--font-display);font-size:1.7rem;font-weight:700;line-height:1.25;margin-bottom:20px;color:var(--text);}
.art-summary{background:var(--primary-bg);border-left:3px solid var(--primary);padding:14px 18px;border-radius:0 var(--radius-sm) var(--radius-sm) 0;margin-bottom:22px;font-size:.875rem;line-height:1.6;font-style:italic;}
.art-content{font-size:.9rem;line-height:1.8;color:var(--text);}
.art-content h2{font-family:var(--font-display);font-size:1.2rem;font-weight:700;margin:24px 0 10px;}
.art-content p{margin-bottom:14px;}
.art-content strong{font-weight:700;}
.rel-sec{margin-top:36px;margin-bottom:32px;}
.rel-title{font-family:var(--font-display);font-size:1.1rem;font-weight:700;margin-bottom:16px;}
.rel-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(190px,1fr));gap:14px;}
.rel-card{background:var(--surface);border-radius:var(--radius);border:1px solid var(--border);overflow:hidden;text-decoration:none;display:block;transition:all .2s;}
.rel-card:hover{transform:translateY(-2px);box-shadow:var(--shadow);}
.rel-img{width:100%;height:110px;object-fit:cover;}
.rel-body{padding:12px;}
.rel-kat{font-size:.7rem;color:var(--primary);font-weight:700;margin-bottom:4px;}
.rel-judul{font-size:.82rem;font-weight:700;color:var(--text);line-height:1.3;}
</style>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('content'); ?>
<div style="display:flex;align-items:center;gap:12px;margin-bottom:24px;">
    <a href="<?php echo e(route('tips')); ?>" class="btn btn-secondary btn-sm"><i class="fa-solid fa-arrow-left"></i> Kembali</a>
    <span class="badge badge-primary"><?php echo e($artikel->kategori); ?></span>
</div>
<img src="<?php echo e($artikel->gambar ?? 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=800'); ?>" alt="<?php echo e($artikel->judul); ?>" class="art-hero">
<div class="art-meta">
    <div class="art-meta-item"><i class="fa-solid fa-tag"></i> <?php echo e($artikel->kategori); ?></div>
    <div class="art-meta-item"><i class="fa-regular fa-clock"></i> <?php echo e($artikel->waktu_baca); ?> menit baca</div>
    <div class="art-meta-item"><i class="fa-regular fa-user"></i> <?php echo e($artikel->penulis); ?></div>
    <div class="art-meta-item"><i class="fa-regular fa-calendar"></i> <?php echo e($artikel->formatted_date); ?></div>
</div>
<h1 class="art-title"><?php echo e($artikel->judul); ?></h1>
<?php if($artikel->ringkasan): ?><div class="art-summary"><?php echo e($artikel->ringkasan); ?></div><?php endif; ?>
<div class="art-content"><?php echo $artikel->konten; ?></div>
<?php if($related->isNotEmpty()): ?>
<div class="rel-sec">
    <div class="rel-title">📌 Artikel Terkait</div>
    <div class="rel-grid">
        <?php $__currentLoopData = $related; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $r): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
        <a href="<?php echo e(route('tips.show',$r->id)); ?>" class="rel-card">
            <img src="<?php echo e($r->gambar ?? 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=400'); ?>" alt="<?php echo e($r->judul); ?>" class="rel-img">
            <div class="rel-body"><div class="rel-kat"><?php echo e($r->kategori); ?></div><div class="rel-judul"><?php echo e($r->judul); ?></div></div>
        </a>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    </div>
</div>
<?php endif; ?>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Users\lapto\Documents\SEMESTER 4\workshop laravel\uas\cabaiku_laravel12\cabaiku\resources\views\pages\tips-detail.blade.php ENDPATH**/ ?>