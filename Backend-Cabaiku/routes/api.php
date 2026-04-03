<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ArtikelController;
use App\Http\Controllers\Api\DeteksiController;
use App\Http\Controllers\Api\LahanController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/artikels', [ArtikelController::class, 'index']);
Route::get('/artikels/{artikel}', [ArtikelController::class, 'show']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/logout-all', [AuthController::class, 'logoutAll']);

    Route::apiResource('lahans', LahanController::class);
    Route::apiResource('deteksis', DeteksiController::class);

    Route::post('/artikels', [ArtikelController::class, 'store']);
    Route::put('/artikels/{artikel}', [ArtikelController::class, 'update']);
    Route::patch('/artikels/{artikel}', [ArtikelController::class, 'update']);
    Route::delete('/artikels/{artikel}', [ArtikelController::class, 'destroy']);
});
