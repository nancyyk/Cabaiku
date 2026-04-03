<?php

namespace Database\Seeders;

use App\Models\Lahan;
use App\Models\User;
use Illuminate\Database\Seeder;

class LahanSeeder extends Seeder
{
    public function run(): void
    {
        $user = User::where('email', 'budi@cabaiku.com')->first();
        if (!$user) return;

        Lahan::create(['user_id' => $user->id, 'nama_lahan' => 'Lahan Utama Blok A', 'lokasi' => 'Brebes Selatan, Jawa Tengah', 'luas' => 0.5,  'keterangan' => 'Lahan utama untuk cabai rawit merah']);
        Lahan::create(['user_id' => $user->id, 'nama_lahan' => 'Lahan Blok B',       'lokasi' => 'Bumiayu, Brebes',             'luas' => 0.25, 'keterangan' => 'Lahan percobaan varietas baru']);
    }
}
