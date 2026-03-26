<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FarmsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('farms')->insert([
            ['id' => "1",
            'user_id' => "1",
            'nama_lahan' => "lahan 1",
            'lokasi_lahan' => "Lokasi Farm 1",
            'luas_lahan' => "1000",],
            [
            'id' => "2",
            'user_id' => "1",
            'nama_lahan' => "lahan 2",
            'lokasi_lahan' => "Lokasi belang rumah",
            'luas_lahan' => "1000",
            ]
        ]);
    }
}

