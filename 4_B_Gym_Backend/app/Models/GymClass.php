<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class GymClass extends Model
{
    use HasFactory;
    protected $fillable = [
        'nama_kelas',
        'jenis_kelas',
        'deskripsi',
        'hari',
        'jam',
        'durasi',
        'kapasitas',
        'instruktur',
        'harga',
        'image',
    ];
}
