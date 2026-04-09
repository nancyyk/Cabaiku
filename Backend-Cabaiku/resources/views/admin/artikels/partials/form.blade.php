@php
    $isEdit = $artikel !== null;
@endphp

<div class="field">
    <label>Judul</label>
    <input type="text" name="judul" value="{{ old('judul', $isEdit ? $artikel->judul : '') }}" required>
</div>

<div class="field">
    <label>Slug (opsional)</label>
    <input type="text" name="slug" value="{{ old('slug', $isEdit ? $artikel->slug : '') }}">
</div>

<div class="field">
    <label>Ringkasan</label>
    <textarea name="ringkasan">{{ old('ringkasan', $isEdit ? $artikel->ringkasan : '') }}</textarea>
</div>

<div class="field">
    <label>Konten</label>
    <textarea name="konten" required>{{ old('konten', $isEdit ? $artikel->konten : '') }}</textarea>
</div>

<div class="field">
    <label>URL Gambar</label>
    <input type="text" name="gambar" value="{{ old('gambar', $isEdit ? $artikel->gambar : '') }}">
</div>

<div class="field">
    <label>Kategori</label>
    <input type="text" name="kategori" value="{{ old('kategori', $isEdit ? $artikel->kategori : '') }}">
</div>


<div class="field">
    <label>Penulis</label>
    <input type="text" name="penulis" value="{{ old('penulis', $isEdit ? $artikel->penulis : '') }}">
</div>

<div class="field">
    <label>Published At</label>
    <input type="datetime-local" name="published_at" value="{{ old('published_at', $isEdit && $artikel->published_at ? $artikel->published_at->format('Y-m-d\\TH:i') : '') }}">
</div>

<div class="field">
    <label><input type="checkbox" name="is_published" value="1" {{ old('is_published', $isEdit ? $artikel->is_published : true) ? 'checked' : '' }}> Publish</label>
</div>
