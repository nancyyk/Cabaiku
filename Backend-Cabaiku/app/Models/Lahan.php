<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Lahan extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'nama_lahan', 'lokasi', 'luas', 'keterangan'];

    public function user()     { return $this->belongsTo(User::class); }
    public function deteksis() { return $this->hasMany(Deteksi::class); }
}
