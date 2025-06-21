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
        Schema::create('gym_classes', function (Blueprint $table) {
            $table->id();
            $table->string('nama_kelas');
            $table->string('jenis_kelas');
            $table->text('deskripsi');
            $table->string('hari');
            $table->time('jam');
            $table->integer('durasi');
            $table->integer('kapasitas');
            $table->string('instruktur');
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
        Schema::dropIfExists('gym_classes');
    }
};
