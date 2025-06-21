<?php

namespace App\Http\Controllers;

use App\Models\Bookings;
use App\Models\User;
use App\Models\GymEquipment;
use App\Models\GymClass;
use App\Models\PersonalTrainer;
use App\Models\History;
use App\Http\Controllers\HistoryController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class BookingsController extends Controller
{
    public function index()
    {
        try{
            $data = Bookings::all();
            return response()->json([
                "status" => true,
                "message" => "Get Successfu",
                "data" => $data
            ],200);
        }
        catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }


    public function store(Request $request)
    {
        try{
            $validatedData = $request->validate([
                'jenis_layanan' => 'required|string|max:255',
                'date' => 'required|date',
                'ID_PersonalTrainer' => 'nullable',
                'ID_GymClass' => 'nullable',
                'ID_Equipment' => 'nullable',
            ]);

            $userId = Auth::id();
            $harga = 0;

            if ($validatedData['jenis_layanan'] === 'Personal Trainer') {
                if (empty($validatedData['ID_PersonalTrainer'])) {
                    return response()->json(['message' => 'ID Personal Trainer harus diisi'], 403);
                }
                $pt = PersonalTrainer::find($validatedData['ID_PersonalTrainer']);
                if (!$pt) {
                    return response()->json(['message' => 'Personal Trainer tidak ditemukan'], 403);
                }
                if (!empty($validatedData['ID_GymClass']) || !empty($validatedData['ID_Equipment'])) {
                    return response()->json(['message' => 'Hanya satu jenis layanan yang dapat dipilih'], 403);
                }
                $harga = $pt->harga;
            } elseif ($validatedData['jenis_layanan'] === 'Gym Class') {
                if (empty($validatedData['ID_GymClass'])) {
                    return response()->json(['message' => 'ID Gym Class harus diisi'], 403);
                }
                $gymClass = GymClass::find($validatedData['ID_GymClass']);
                if (!$gymClass) {
                    return response()->json(['message' => 'Gym Class tidak ditemukan'], 403);
                }
                if (!empty($validatedData['ID_PersonalTrainer']) || !empty($validatedData['ID_Equipment'])) {
                    return response()->json(['message' => 'Hanya satu jenis layanan yang dapat dipilih'], 403);
                }
                $harga = $gymClass->harga;
            } elseif ($validatedData['jenis_layanan'] === 'Gym Equipment') {
                if (empty($validatedData['ID_Equipment'])) {
                    return response()->json(['message' => 'ID Equipment harus diisi'], 403);
                }
                $gymEquipment = GymEquipment::find($validatedData['ID_Equipment']);
                if (!$gymEquipment) {
                    return response()->json(['message' => 'Gym Equipment tidak ditemukan'], 403);
                }
                if (!empty($validatedData['ID_PersonalTrainer']) || ! empty($validatedData['ID_GymClass'])) {
                    return response()->json(['message' => 'Hanya satu jenis layanan yang dapat dipilih'], 403);
                }
                $harga = $gymEquipment->harga;
            }

            $data = Bookings::create([
                'jenis_layanan' => $validatedData['jenis_layanan'],
                'date' => $validatedData['date'],
                'harga' => $harga,
                'ID_User' => $userId,
                'ID_PersonalTrainer' => $validatedData['ID_PersonalTrainer'] ?? null,
                'ID_GymClass' => $validatedData['ID_GymClass'] ?? null,
                'ID_Equipment' => $validatedData['ID_Equipment'] ?? null,
            ]);

            return response()->json([
                "status" => true,
                "message" => "Data berhasil ditambahkan",
                "data" => $data
            ], 200);
        }
        catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Data gagal ditambahkan",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function findSpecificBooking($id)
    {
        try{
            $booking = Bookings::find($id);

            $outputBooking = [
                'date' => $booking->date,
                'harga' => $booking->harga,
            ];

            if($booking->jenis_layanan === 'Personal Trainer') {
                $personalTrainer = PersonalTrainer::find($booking->ID_PersonalTrainer);
                if($personalTrainer) {
                    $outputBooking['nama'] = $personalTrainer->nama;
                }else{
                    $outputBooking['nama'] = 'Personal Trainer tidak ditemukan';
                }
            } else if($booking->jenis_layanan === 'Gym Class') {
                $gymClass = GymClass::find($booking->ID_GymClass);
                if($gymClass) {
                    $outputBooking['nama_kelas'] = $gymClass->nama_kelas;
                    $outputBooking['instruktur'] = $gymClass->instruktur;
                }else{
                    $outputBooking['nama_kelas'] = 'Gym Class tidak ditemukan';
                    $outputBooking['instruktur'] = 'Instruktur Gym Class tidak ditemukan';
                }
            } else if($booking->jenis_layanan === 'Gym Equipment') {
                $gymEquipment = GymEquipment::find($booking->ID_Equipment);
                if($gymEquipment) {
                    $outputBooking['nama_alat'] = $gymEquipment->nama_alat;
                }else{
                    $outputBooking['nama_alat'] = 'Gym Equipment tidak ditemukan';
                }
            }

            return response()->json([
                "status" => true,
                "message" => "Data berhasil ditambahkan",
                "data" => $outputBooking
            ], 200);

        }
        catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function show(Bookings $bookings)
    {
        
    }

    public function update(Request $request, Bookings $bookings)
    {
        
    }


    public function destroy(Bookings $bookings)
    {
        
    }
}
