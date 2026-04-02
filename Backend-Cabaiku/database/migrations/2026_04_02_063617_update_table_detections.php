<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use PHPUnit\Framework\Attributes\After;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('detections', function (Blueprint $table) {
            $table->timestamp("update_at")->nullable()->after('created_at'); //
            $table->softDeletes()->after("update_at"); //
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('detections', function (Blueprint $table) {
            $table->dropColumn("update_at");
            $table->dropSoftDeletes();
        });
    }
};
