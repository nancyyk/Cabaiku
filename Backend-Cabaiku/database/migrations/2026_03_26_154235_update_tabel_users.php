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
        Schema::table('users', function (Blueprint $table) {
            $table->string('no_wa')->nullable()->after('password');
            $table->string('lokasi')->nullable()->after('no_wa');
            $table->renameColumn('name', 'nama')->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('no_wa');
            $table->dropColumn('lokasi');
            $table->renameColumn('nama', 'name')->change();
        });
    }
};
