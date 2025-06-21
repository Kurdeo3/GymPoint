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
        Schema::create('gym_equipment', function (Blueprint $table) {
            $table->id();
            $table->string('nama_alat');
            $table->integer('jumlah');
            $table->text('deskripsi');
            $table->string('jenis_alat');
            $table->decimal('harga', 10, 2);
            $table->string('image')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('gym_equipment');
    }
};
