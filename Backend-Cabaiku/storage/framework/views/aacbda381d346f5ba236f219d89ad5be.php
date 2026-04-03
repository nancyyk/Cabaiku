<?php $__env->startSection('title','Tips & Artikel'); ?>
<?php $__env->startSection('styles'); ?>
<style>
.search-wrap{position:relative;margin-bottom:20px;}
.search-icon{position:absolute;left:16px;top:50%;transform:translateY(-50%);color:var(--text-muted);font-size:.95rem;}
.search-inp{width:100%;padding:13px 44px 13px 44px;border:1.5px solid var(--border);border-radius:14px;font-family:var(--font-body);font-size:.9rem;background:var(--surface);color:var(--text);outline:none;transition:all .2s;}
.search-inp:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(192,57,43,.1);}
.search-clear{position:absolute;right:14px;top:50%;transform:translateY(-50%);background:var(--surface3);border:none;border-radius:50%;width:26px;height:26px;cursor:pointer;color:var(--text-muted);font-size:.8rem;display:none;align-items:center;justify-content:center;}
.search-clear.show{display:flex;}
.filter-tags{display:flex;gap:8px;margin-bottom:24px;flex-wrap:wrap;}
.ftag{padding:7px 16px;border-radius:20px;font-size:.8rem;font-weight:600;border:1.5px solid var(--border);background:var(--surface);color:var(--text-muted);text-decoration:none;transition:all .2s;cursor:pointer;white-space:nowrap;}
.ftag:hover{border-color:var(--primary);color:var(--primary);}
.ftag.active{background:var(--primary);border-color:var(--primary);color:#fff;}
.ag{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:18px;margin-bottom:28px;}
.ac{background:var(--surface);border-radius:var(--radius-lg);border:1px solid var(--border);overflow:hidden;box-shadow:var(--shadow-sm);transition:all .25s;text-decoration:none;display:block;}
.ac:hover{transform:translateY(-4px);box-shadow:var(--shadow);border-color:transparent;}
.ac-img-wrap{height:180px;overflow:hidden;position:relative;}
.ac-img{width:100%;height:100%;object-fit:cover;transition:transform .4s;}
.ac:hover .ac-img{transform:scale(1.05);}
.ac-kat{position:absolute;top:12px;left:12px;background:rgba(255,255,255,.9);backdrop-filter:blur(8px);color:var(--primary);font-size:.7rem;font-weight:700;padding:4px 10px;border-radius:20px;}
.ac-body{padding:18px;}
.ac-meta{display:flex;align-items:center;gap:12px;margin-bottom:10px;}
.ac-meta-item{display:flex;align-items:center;gap:5px;font-size:.74rem;color:var(--text-muted);}
.ac-judul{font-weight:700;font-size:.95rem;color:var(--text);margin-bottom:8px;line-height:1.4;}
.ac-ring{font-size:.79rem;color:var(--text-muted);line-height:1.55;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;margin-bottom:14px;}
.ac-footer{display:flex;align-items:center;justify-content:space-between;}
.ac-date{font-size:.7rem;color:var(--text-light);}
.ac-more{font-size:.77rem;color:var(--primary);font-weight:600;}
.empty{text-align:center;padding:60px 20px;}
.empty-icon{font-size:3rem;margin-bottom:12px;opacity:.5;}
@media(max-width:600px){.ag{grid-template-columns:1fr;}}
</style>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('content'); ?>
<div class="page-header"><h1>📖 Tips & Artikel</h1><p>Panduan lengkap merawat dan membudidayakan tanaman cabai</p></div>

<form method="GET" action="<?php echo e(route('tips')); ?>" id="filter-form">
    <div class="search-wrap">
        <i class="fa-solid fa-magnifying-glass search-icon"></i>
        <input type="text" name="q" class="search-inp" id="search-inp" placeholder="Cari artikel, tips, atau panduan..." value="<?php echo e(request('q')); ?>" oninput="toggleClear(this)">
        <button type="button" class="search-clear <?php echo e(request('q') ? 'show' : ''); ?>" id="clear-btn" onclick="clearSearch()"><i class="fa-solid fa-xmark"></i></button>
        <input type="hidden" name="kategori" value="<?php echo e(request('kategori')); ?>">
    </div>
</form>

<div class="filter-tags">
    <a href="<?php echo e(route('tips', ['q'=>request('q')])); ?>" class="ftag <?php echo e(!request('kategori') ? 'active' : ''); ?>">Semua</a>
    <?php $__currentLoopData = $kategoris; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $k): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
    <a href="<?php echo e(route('tips', ['q'=>request('q'),'kategori'=>$k])); ?>" class="ftag <?php echo e(request('kategori')==$k ? 'active' : ''); ?>"><?php echo e($k); ?></a>
    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
</div>

<?php if(request('q')): ?><div style="font-size:.83rem;color:var(--text-muted);margin-bottom:16px;">Hasil: <strong style="color:var(--text);">"<?php echo e(request('q')); ?>"</strong> — <strong><?php echo e($artikels->total()); ?></strong> artikel <a href="<?php echo e(route('tips')); ?>" style="color:var(--primary);margin-left:8px;">Hapus filter</a></div><?php endif; ?>

<?php if($artikels->isEmpty()): ?>
<div class="empty"><div class="empty-icon">📭</div><h3 style="font-weight:700;margin-bottom:8px;">Artikel Tidak Ditemukan</h3><p style="color:var(--text-muted);">Coba kata kunci lain atau hapus filter.</p><a href="<?php echo e(route('tips')); ?>" class="btn btn-primary" style="margin-top:16px;">Lihat Semua</a></div>
<?php else: ?>
<div class="ag">
    <?php $__currentLoopData = $artikels; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $ar): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
    <a href="<?php echo e(route('tips.show',$ar->id)); ?>" class="ac">
        <div class="ac-img-wrap">
            <img src="<?php echo e($ar->gambar ?? 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=600'); ?>" alt="<?php echo e($ar->judul); ?>" class="ac-img">
            <span class="ac-kat"><?php echo e($ar->kategori); ?></span>
        </div>
        <div class="ac-body">
            <div class="ac-meta">
                <div class="ac-meta-item"><i class="fa-regular fa-clock"></i> <?php echo e($ar->waktu_baca); ?> menit</div>
                <div class="ac-meta-item"><i class="fa-regular fa-user"></i> <?php echo e($ar->penulis); ?></div>
            </div>
            <div class="ac-judul"><?php echo e($ar->judul); ?></div>
            <div class="ac-ring"><?php echo e($ar->ringkasan); ?></div>
            <div class="ac-footer">
                <span class="ac-date"><?php echo e($ar->formatted_date); ?></span>
                <span class="ac-more">Baca Selengkapnya →</span>
            </div>
        </div>
    </a>
    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
</div>
<?php if($artikels->hasPages()): ?>
<div style="display:flex;justify-content:center;gap:6px;margin-bottom:32px;">
    <?php if(!$artikels->onFirstPage()): ?><a href="<?php echo e($artikels->previousPageUrl()); ?>" class="btn btn-secondary btn-sm"><i class="fa-solid fa-chevron-left"></i></a><?php endif; ?>
    <span style="display:flex;align-items:center;font-size:.875rem;color:var(--text-muted);padding:0 12px;">Hal <?php echo e($artikels->currentPage()); ?> / <?php echo e($artikels->lastPage()); ?></span>
    <?php if($artikels->hasMorePages()): ?><a href="<?php echo e($artikels->nextPageUrl()); ?>" class="btn btn-secondary btn-sm"><i class="fa-solid fa-chevron-right"></i></a><?php endif; ?>
</div>
<?php endif; ?>
<?php endif; ?>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('scripts'); ?>
<script>
function toggleClear(inp){document.getElementById('clear-btn').classList.toggle('show',inp.value.length>0);}
function clearSearch(){document.getElementById('search-inp').value='';document.getElementById('clear-btn').classList.remove('show');document.getElementById('filter-form').submit();}
let t;document.getElementById('search-inp')?.addEventListener('input',function(){clearTimeout(t);t=setTimeout(()=>document.getElementById('filter-form').submit(),600);});
</script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Users\lapto\Documents\SEMESTER 4\workshop laravel\uas\cabaiku_laravel12\cabaiku\resources\views\pages\tips.blade.php ENDPATH**/ ?>