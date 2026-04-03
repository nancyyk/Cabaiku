<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'name'       => 'Budi Santoso',
            'email'      => 'budi@cabaiku.com',
            'password'   => Hash::make('password'),
            'phone'      => '081234567890',
            'location'   => 'Brebes, Jawa Tengah',
            'bahasa'     => 'id',
            'created_at' => now()->subDays(68),
            'updated_at' => now()->subDays(68),
        ]);
    }
}
