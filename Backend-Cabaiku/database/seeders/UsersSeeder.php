<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        for($id = 1; $id <= 5; $id++) {
            DB::table('users')->insert([
                'nama' => "Ujicoba$id",
                'email' => "ujicoba$id@gmail.com",
                'password' => bcrypt('ujicoba'),
                'no_wa' => "123$id",
                'lokasi' => "Lokasi$id"
            ]);
        }
    }
}
