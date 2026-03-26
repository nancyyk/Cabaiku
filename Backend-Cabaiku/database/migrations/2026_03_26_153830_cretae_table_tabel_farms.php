<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
            Schema::create('farms', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')
                ->constrained('users')
                  ->onDelete('cascade'); // jika user dihapus, farm ikut terhapus

            $table->string('nama_lahan');
            $table->string('lokasi_lahan');
            $table->float('luas_lahan')->nullable(); // dalam satuan hektar atau m²
            $table->timestamp('created_at')->useCurrent();

            // Index untuk performa
            $table->index('user_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('farms');
    }
};
