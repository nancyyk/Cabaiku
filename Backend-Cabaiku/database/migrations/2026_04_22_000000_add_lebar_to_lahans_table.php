<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasColumn('lahans', 'lebar')) {
            Schema::table('lahans', function (Blueprint $table) {
                $table->decimal('lebar', 10, 2)->nullable()->after('lokasi');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('lahans', 'lebar')) {
            Schema::table('lahans', function (Blueprint $table) {
                $table->dropColumn('lebar');
            });
        }
    }
};