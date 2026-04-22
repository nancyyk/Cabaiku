<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasColumn('lahans', 'panjang')) {
            Schema::table('lahans', function (Blueprint $table) {
                $table->decimal('panjang', 10, 2)->nullable()->after('lebar');
            });
        }

        if (Schema::hasColumn('lahans', 'luas')) {
            DB::table('lahans')->update([
                'panjang' => DB::raw('luas'),
            ]);

            Schema::table('lahans', function (Blueprint $table) {
                $table->dropColumn('luas');
            });
        }
    }

    public function down(): void
    {
        if (! Schema::hasColumn('lahans', 'luas')) {
            Schema::table('lahans', function (Blueprint $table) {
                $table->decimal('luas', 10, 2)->nullable()->after('lebar');
            });
        }

        if (Schema::hasColumn('lahans', 'panjang')) {
            DB::table('lahans')->update([
                'luas' => DB::raw('panjang'),
            ]);

            Schema::table('lahans', function (Blueprint $table) {
                $table->dropColumn('panjang');
            });
        }
    }
};