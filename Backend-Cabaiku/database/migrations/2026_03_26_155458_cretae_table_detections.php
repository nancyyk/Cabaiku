<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('detections', function (Blueprint $table) {
            $table->id();
            
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->onDelete('cascade');

            $table->foreignId('farm_id')
                  ->constrained('farms')
                  ->onDelete('cascade');

            $table->string('image_path');           // path foto yang diupload
            $table->string('lokasi_foto')->nullable();
            $table->json('hasil');                  // hasil deteksi AI (JSON)
            $table->string('status')->default('pending'); // pending, success, failed, dll
            
            $table->timestamp('created_at')->useCurrent();

            // Index untuk mempercepat query
            $table->index(['user_id', 'farm_id']);
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('detections');
    }
};