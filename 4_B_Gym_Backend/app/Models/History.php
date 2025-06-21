<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class History extends Model
{
    use HasFactory;
    protected $fillable = [
        'jenis_layanan',
        'nama_personalTrainer',
        'tanggal_booking',
        'ID_User',
        'ID_Booking'
    ];

    public function booking()
    {
        return $this->belongsTo(Bookings::class, 'ID_Booking', 'id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'ID_User', 'id');
    }
}
