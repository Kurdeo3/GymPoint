<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class PersonalTrainer extends Model
{
    use HasFactory;
    protected $fillable = [
        'nama',
        'umur',
        'jenis_kelamin',
        'spesialisasi',
        'no_telp',
        'harga',
        'image',
    ];
}
