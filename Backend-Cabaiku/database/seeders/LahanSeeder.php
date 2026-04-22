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

        Lahan::create(['user_id' => $user->id, 'nama_lahan' => 'Lahan Utama Blok A', 'lokasi' => 'Brebes Selatan, Jawa Tengah', 'lebar' => 20, 'panjang' => 30, 'keterangan' => 'Lahan utama untuk cabai rawit merah']);
        Lahan::create(['user_id' => $user->id, 'nama_lahan' => 'Lahan Blok B',       'lokasi' => 'Bumiayu, Brebes',             'lebar' => 12, 'panjang' => 18, 'keterangan' => 'Lahan percobaan varietas baru']);
    }
}
