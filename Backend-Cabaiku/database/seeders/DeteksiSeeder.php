<?php

namespace Database\Seeders;

use App\Models\Deteksi;
use App\Models\Lahan;
use App\Models\User;
use Illuminate\Database\Seeder;

class DeteksiSeeder extends Seeder
{
    public function run(): void
    {
        $user  = User::where('email', 'budi@cabaiku.com')->first();
        $lahan = Lahan::where('user_id', $user->id)->first();
        if (!$user || !$lahan) return;

        $data = [
            ['hasil' => 'Sehat',                     'penyakit' => null,                      'tingkat' => 'Ringan', 'akurasi' => 95, 'hari' => 20, 'rek' => 'Tanaman dalam kondisi sehat. Pertahankan perawatan rutin.'],
            ['hasil' => 'Bercak Daun (Leaf Spot)',   'penyakit' => 'Cercospora capsici',      'tingkat' => 'Sedang', 'akurasi' => 87, 'hari' => 21, 'rek' => 'Aplikasikan fungisida mankozeb. Buang daun terinfeksi.'],
            ['hasil' => 'Sehat',                     'penyakit' => null,                      'tingkat' => 'Ringan', 'akurasi' => 92, 'hari' => 22, 'rek' => 'Tanaman dalam kondisi sehat. Pertahankan perawatan rutin.'],
            ['hasil' => 'Keriting Daun (Leaf Curl)', 'penyakit' => 'Virus CMV',               'tingkat' => 'Sedang', 'akurasi' => 84, 'hari' => 23, 'rek' => 'Kendalikan kutu daun dengan insektisida sistemik.'],
            ['hasil' => 'Antraknosa',                'penyakit' => 'Colletotrichum acutatum', 'tingkat' => 'Berat',  'akurasi' => 89, 'hari' => 24, 'rek' => 'Semprot fungisida azoksistrobin. Perbaiki drainase lahan.'],
            ['hasil' => 'Sehat',                     'penyakit' => null,                      'tingkat' => 'Ringan', 'akurasi' => 94, 'hari' => 25, 'rek' => 'Tanaman dalam kondisi sehat. Pertahankan perawatan rutin.'],
        ];

        foreach ($data as $d) {
            Deteksi::create([
                'user_id'           => $user->id,
                'lahan_id'          => $lahan->id,
                'gambar'            => 'deteksi/dummy.jpg',
                'hasil'             => $d['hasil'],
                'penyakit'          => $d['penyakit'],
                'tingkat_keparahan' => $d['tingkat'],
                'akurasi'           => $d['akurasi'],
                'catatan'           => 'Deteksi rutin',
                'rekomendasi'       => $d['rek'],
                'created_at'        => now()->subDays($d['hari']),
                'updated_at'        => now()->subDays($d['hari']),
            ]);
        }
    }
}
