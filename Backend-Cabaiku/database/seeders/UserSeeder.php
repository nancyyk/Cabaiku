<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate([
            'email' => 'admin@cabaiku.com',
        ], [
            'name'       => 'Admin Cabaiku',
            'password'   => Hash::make('admin12345'),
            'phone'      => '081111111111',
            'location'   => 'Kantor Cabaiku',
            'bahasa'     => 'id',
            'is_admin'   => true,
            'created_at' => now()->subDays(120),
            'updated_at' => now()->subDays(120),
        ]);

        User::updateOrCreate([
            'email' => 'budi@cabaiku.com',
        ], [
            'name'       => 'Budi Santoso',
            'password'   => Hash::make('password'),
            'phone'      => '081234567890',
            'location'   => 'Brebes, Jawa Tengah',
            'bahasa'     => 'id',
            'is_admin'   => false,
            'created_at' => now()->subDays(68),
            'updated_at' => now()->subDays(68),
        ]);
    }
}
