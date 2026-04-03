<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Artikel extends Model
{
    use HasFactory;

    protected $fillable = [
        'judul', 'slug', 'konten', 'ringkasan',
        'gambar', 'kategori', 'waktu_baca',
        'penulis', 'is_published', 'published_at',
    ];

    protected function casts(): array
    {
        return [
            'published_at' => 'datetime',
            'is_published' => 'boolean',
        ];
    }

    public function scopePublished($query)
    {
        return $query->where('is_published', true);
    }

    public function scopeSearch($query, $keyword)
    {
        return $query->where(function ($q) use ($keyword) {
            $q->where('judul',     'like', "%{$keyword}%")
              ->orWhere('konten',   'like', "%{$keyword}%")
              ->orWhere('ringkasan','like', "%{$keyword}%")
              ->orWhere('kategori', 'like', "%{$keyword}%");
        });
    }

    public function scopeByKategori($query, $kategori)
    {
        if ($kategori && $kategori !== 'semua') {
            return $query->where('kategori', $kategori);
        }
        return $query;
    }

    public function getFormattedDateAttribute()
    {
        $tgl = $this->published_at ?? $this->created_at;
        return $tgl->translatedFormat('d F Y');
    }
}
