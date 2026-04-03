<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Deteksi extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'lahan_id', 'gambar', 'hasil',
        'penyakit', 'tingkat_keparahan', 'akurasi',
        'catatan', 'rekomendasi',
    ];

    public function user()  { return $this->belongsTo(User::class); }
    public function lahan() { return $this->belongsTo(Lahan::class); }

    public function getIsSehatAttribute()
    {
        return $this->hasil === 'Sehat';
    }

    public function getBadgeClassAttribute()
    {
        return match($this->tingkat_keparahan) {
            'Sedang' => 'badge-sedang',
            'Berat'  => 'badge-berat',
            default  => 'badge-ringan',
        };
    }
}
