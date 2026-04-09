
<?php $__env->startSection('title', 'Manajemen Artikel'); ?>

<?php $__env->startSection('content'); ?>
<div class="card">
    <div class="actions" style="justify-content:space-between;margin-bottom:12px;">
        <div class="title" style="margin-bottom:0">Daftar Artikel</div>
        <a href="<?php echo e(route('admin.artikels.create')); ?>" class="btn btn-dark" style="text-decoration:none">+ Tambah Artikel</a>
    </div>

    <table>
        <thead>
        <tr>
            <th>Judul</th>
            <th>Kategori</th>
            <th>Status</th>
            <th>Dipublish</th>
            <th>Aksi</th>
        </tr>
        </thead>
        <tbody>
        <?php $__empty_1 = true; $__currentLoopData = $artikels; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $artikel): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
            <tr>
                <td><?php echo e($artikel->judul); ?></td>
                <td><?php echo e($artikel->kategori); ?></td>
                <td><?php echo e($artikel->is_published ? 'Publish' : 'Draft'); ?></td>
                <td><?php echo e(optional($artikel->published_at)->format('d M Y H:i') ?? '-'); ?></td>
                <td>
                    <div class="actions">
                        <a href="<?php echo e(route('admin.artikels.edit', $artikel->id)); ?>" class="btn" style="text-decoration:none">Edit</a>
                        <form method="POST" action="<?php echo e(route('admin.artikels.destroy', $artikel->id)); ?>" onsubmit="return confirm('Hapus artikel ini?')">
                            <?php echo csrf_field(); ?>
                            <?php echo method_field('DELETE'); ?>
                            <button type="submit" class="btn btn-danger">Hapus</button>
                        </form>
                    </div>
                </td>
            </tr>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
            <tr><td colspan="5">Belum ada artikel.</td></tr>
        <?php endif; ?>
        </tbody>
    </table>

    <div class="pagination"><?php echo e($artikels->links()); ?></div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\kuliah\semester4\projek semster 4\Cabaiku\Backend-Cabaiku\resources\views/admin/artikels/index.blade.php ENDPATH**/ ?>