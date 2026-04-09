
<?php $__env->startSection('title', 'Tambah Artikel'); ?>

<?php $__env->startSection('content'); ?>
<div class="card">
    <div class="title">Tambah Artikel</div>
    <form method="POST" action="<?php echo e(route('admin.artikels.store')); ?>">
        <?php echo csrf_field(); ?>
        <?php echo $__env->make('admin.artikels.partials.form', ['artikel' => null], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
        <button type="submit" class="btn btn-dark">Simpan Artikel</button>
    </form>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\kuliah\semester4\projek semster 4\Cabaiku\Backend-Cabaiku\resources\views/admin/artikels/create.blade.php ENDPATH**/ ?>