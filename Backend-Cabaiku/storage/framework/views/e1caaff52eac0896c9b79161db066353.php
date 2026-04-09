<?php
    $isEdit = $artikel !== null;
?>

<div class="field">
    <label>Judul</label>
    <input type="text" name="judul" value="<?php echo e(old('judul', $isEdit ? $artikel->judul : '')); ?>" required>
</div>

<div class="field">
    <label>Slug (opsional)</label>
    <input type="text" name="slug" value="<?php echo e(old('slug', $isEdit ? $artikel->slug : '')); ?>">
</div>

<div class="field">
    <label>Ringkasan</label>
    <textarea name="ringkasan"><?php echo e(old('ringkasan', $isEdit ? $artikel->ringkasan : '')); ?></textarea>
</div>

<div class="field">
    <label>Konten</label>
    <textarea name="konten" required><?php echo e(old('konten', $isEdit ? $artikel->konten : '')); ?></textarea>
</div>

<div class="field">
    <label>URL Gambar</label>
    <input type="text" name="gambar" value="<?php echo e(old('gambar', $isEdit ? $artikel->gambar : '')); ?>">
</div>

<div class="field">
    <label>Kategori</label>
    <input type="text" name="kategori" value="<?php echo e(old('kategori', $isEdit ? $artikel->kategori : '')); ?>">
</div>


<div class="field">
    <label>Penulis</label>
    <input type="text" name="penulis" value="<?php echo e(old('penulis', $isEdit ? $artikel->penulis : '')); ?>">
</div>

<div class="field">
    <label>Published At</label>
    <input type="datetime-local" name="published_at" value="<?php echo e(old('published_at', $isEdit && $artikel->published_at ? $artikel->published_at->format('Y-m-d\\TH:i') : '')); ?>">
</div>

<div class="field">
    <label><input type="checkbox" name="is_published" value="1" <?php echo e(old('is_published', $isEdit ? $artikel->is_published : true) ? 'checked' : ''); ?>> Publish</label>
</div>
<?php /**PATH D:\kuliah\semester4\projek semster 4\Cabaiku\Backend-Cabaiku\resources\views/admin/artikels/partials/form.blade.php ENDPATH**/ ?>