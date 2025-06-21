<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class GymEquipment extends Model
{
    use HasFactory;
    protected $fillable = [
        'nama_alat',
        'jumlah',
        'deskripsi',
        'jenis_alat',
        'harga',
        'image',
    ];
}
