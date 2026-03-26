<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DetectionsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('detections')->insert([
            [
                'user_id'     => 1, // Pastikan ID ini ada di tabel users
                'farm_id'     => 1, // Pastikan ID ini ada di tabel farms
                'image_path'  => 'uploads/detections/plant1.jpg',
                'lokasi_foto' => 'Blok A - Kebun Apel',
                'hasil'       => json_encode(['disease' => 'Leaf Rust', 'confidence' => 0.85]),
                'status'      => 'completed',
                'created_at'  => now(),
            ],
            [
                'user_id'     => 1,
                'farm_id'     => 2,
                'image_path'  => 'uploads/detections/plant2.jpg',
                'lokasi_foto' => 'Blok C - Kebun Jeruk',
                'hasil'       => 'Tanaman Sehat',
                'status'      => 'pending',
                'created_at'  => now(),
            ],
        ]);
    }
}
