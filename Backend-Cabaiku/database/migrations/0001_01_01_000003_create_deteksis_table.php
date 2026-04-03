<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('deteksis', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('lahan_id')->constrained()->cascadeOnDelete();
            $table->string('gambar');
            $table->string('hasil');
            $table->string('penyakit')->nullable();
            $table->enum('tingkat_keparahan', ['Ringan', 'Sedang', 'Berat'])->default('Ringan');
            $table->integer('akurasi')->default(0);
            $table->text('catatan')->nullable();
            $table->text('rekomendasi')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('deteksis');
    }
};
