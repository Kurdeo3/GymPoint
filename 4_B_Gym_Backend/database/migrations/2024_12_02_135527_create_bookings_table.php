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
        Schema::create('bookings', function (Blueprint $table) {
            $table->id();
            $table->string('jenis_layanan');
            $table->datetime('date');
            $table->decimal('harga', 10, 2);
            $table->foreignId('ID_User')->constrained('users')->onDelete('cascade');
            $table->foreignId('ID_PersonalTrainer')->nullable()->constrained('personal_trainers')->onDelete('cascade');
            $table->foreignId('ID_GymClass')->nullable()->constrained('gym_classes')->onDelete('cascade');
            $table->foreignId('ID_Equipment')->nullable()->constrained('gym_equipment')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bookings');
    }
};
