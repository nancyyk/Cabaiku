<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\DeteksiController;
use App\Http\Controllers\TipsController;
use App\Http\Controllers\RiwayatController;
use App\Http\Controllers\ProfilController;
use App\Http\Controllers\LahanController;

// Guest routes
Route::middleware('guest')->group(function () {
    Route::get('/',        [AuthController::class, 'showLogin'])->name('login');
    Route::get('/login',   [AuthController::class, 'showLogin']);
    Route::post('/login',  [AuthController::class, 'login'])->name('login.post');
    Route::get('/register',[AuthController::class, 'showRegister'])->name('register');
    Route::post('/register',[AuthController::class, 'register'])->name('register.post');
});

// Authenticated routes
Route::middleware('auth')->group(function () {
    Route::get('/beranda',  [DashboardController::class, 'index'])->name('beranda');

    // Deteksi
    Route::get('/deteksi',       [DeteksiController::class, 'index'])->name('deteksi');
    Route::post('/deteksi',      [DeteksiController::class, 'store'])->name('deteksi.store');
    Route::get('/deteksi/{id}',  [DeteksiController::class, 'show'])->name('deteksi.show');

    // Lahan
    Route::post('/lahan',         [LahanController::class, 'store'])->name('lahan.store');
    Route::delete('/lahan/{id}',  [LahanController::class, 'destroy'])->name('lahan.destroy');

    // Tips
    Route::get('/tips',       [TipsController::class, 'index'])->name('tips');
    Route::get('/tips/{id}',  [TipsController::class, 'show'])->name('tips.show');

    // Riwayat
    Route::get('/riwayat',          [RiwayatController::class, 'index'])->name('riwayat');
    Route::delete('/riwayat/{id}',  [RiwayatController::class, 'destroy'])->name('riwayat.destroy');

    // Profil
    Route::get('/profil',             [ProfilController::class, 'index'])->name('profil');
    Route::post('/profil/update',     [ProfilController::class, 'update'])->name('profil.update');
    Route::post('/profil/password',   [ProfilController::class, 'updatePassword'])->name('profil.password');
    Route::post('/profil/bahasa',     [ProfilController::class, 'updateBahasa'])->name('profil.bahasa');

    // Logout
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
});
