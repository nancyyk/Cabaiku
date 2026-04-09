
<?php $__env->startSection('title', 'Dashboard Admin'); ?>

<?php $__env->startSection('content'); ?>
<div class="grid">
    <div class="stat"><div>Total User Terdaftar</div><div class="n"><?php echo e($totalUsers); ?></div></div>
    <div class="stat"><div>Total Artikel</div><div class="n"><?php echo e($totalArticles); ?></div></div>
</div>

<div class="card">
    <div class="title">Daftar User & Waktu Daftar</div>
    <table>
        <thead>
            <tr>
                <th>Nama</th>
                <th>Email</th>
                <th>Terdaftar Pada</th>
            </tr>
        </thead>
        <tbody>
            <?php $__empty_1 = true; $__currentLoopData = $users; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $user): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                <tr>
                    <td><?php echo e($user->name); ?></td>
                    <td><?php echo e($user->email); ?></td>
                    <td><?php echo e($user->created_at->format('d M Y H:i')); ?></td>
                </tr>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                <tr><td colspan="3">Belum ada user terdaftar.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
    <div class="pagination"><?php echo e($users->links()); ?></div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\kuliah\semester4\projek semster 4\Cabaiku\Backend-Cabaiku\resources\views/admin/dashboard.blade.php ENDPATH**/ ?>