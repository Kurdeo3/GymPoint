<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Bookings extends Model
{
    use HasFactory;


    protected $table = "bookings";
    protected $primaryKey = "id";

    protected $fillable = [
        'jenis_layanan',
        'date',
        'harga',
        'ID_User',
        'ID_PersonalTrainer',
        'ID_GymClass',
        'ID_Equipment',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function personalTrainer()
    {
        return $this->belongsTo(PersonalTrainer::class, 'ID_PersonalTrainer', 'id');
    }

    public function gymClass()
    {
        return $this->belongsTo(GymClass::class, 'ID_GymClass', 'id');
    }

    public function gymEquipment()
    {
        return $this->belongsTo(GymEquipment::class, 'ID_Equipment', 'id');
    }
}
