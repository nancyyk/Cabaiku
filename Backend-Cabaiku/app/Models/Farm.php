<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Farm extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'user_id',
        'nama_lahan',
        'lokasi_lahan',
        'luas_lahan',
    ];

    public function owner()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
