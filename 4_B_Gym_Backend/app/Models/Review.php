<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Review extends Model
{
    use HasFactory;
    protected $table = "reviews";
    protected $primaryKey = "id";
    protected $fillable = [
        'ulasan',
        'rating',
        'ID_User',
        'ID_Booking'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function booking()
    {
        return $this->belongsTo(Bookings::class);
    }
}