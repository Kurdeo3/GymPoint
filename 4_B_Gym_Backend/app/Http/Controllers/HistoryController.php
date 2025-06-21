<?php

namespace App\Http\Controllers;

use App\Models\History;
use App\Models\Bookings;
use App\Models\User;
use App\Models\PersonalTrainer; 
use App\Models\GymClass; 
use App\Models\GymEquipment; 
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class HistoryController extends Controller
{
    public function index()
    {
        try{
            $data = History::all();
            return response()->json([
                "status" => true,
                "message" => "Get Successful",
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
    public function indexSpecificByType($jenisLayanan = null)
    {
        $userId = Auth::id();
        if ($jenisLayanan) {
            $historiesData = History::where('ID_User', $userId)
                ->where('jenis_layanan', $jenisLayanan)
                ->with([
                    'booking', 
                    'booking.personalTrainer', 
                    'booking.gymClass', 
                    'booking.gymEquipment'
                ])
                ->get()
                ->map(function($history) {
                    switch($history->jenis_layanan) {
                        case 'Personal Trainer':
                            $personalTrainer = $history->booking->personalTrainer;
                            $detail = $personalTrainer ? [
                                'nama' => $personalTrainer->nama ?? 'Tidak Diketahui',
                                'harga' => $history->booking->harga ?? 0,
                                'tanggal_transaksi' => $history->booking->date ?? null
                            ] : null;
                            break;
    
                        case 'Gym Class':
                            $gymClass = $history->booking->gymClass;
                            $detail = $gymClass ? [
                                'nama_kelas' => $gymClass->nama_kelas ?? 'Tidak Diketahui',
                                'instruktur' => $gymClass->instruktur ?? 'Tidak Diketahui',
                                'harga' => $history->booking->harga ?? 0,
                                'tanggal_transaksi' => $history->booking->date ?? null
                            ] : null;
                            break;
    
                        case 'Gym Equipment':
                            $gymEquipment = $history->booking->gymEquipment;
                            $detail = $gymEquipment ? [
                                'nama_alat' => $gymEquipment->nama_alat ?? 'Tidak Diketahui',
                                'harga' => $history->booking->harga ?? 0,
                                'tanggal_transaksi' => $history->booking->date ?? null
                            ] : null;
                            break;
                    }
                    return $history;
                });

            return response()->json([
                'status' => true,
                'data' => $historiesData
            ]);
        } else {
            $historiesData = History::where('ID_User', $userId)->get();
        }

        return response()->json([
            'status' => true,
            'data' => $historiesData
        ]);
    }

    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'ID_Booking' => 'required|exists:bookings,id'
            ]);
            $booking = Bookings::findOrFail($validatedData['ID_Booking']);

            $tipeNama = null;
            if ($booking->jenis_layanan === 'Personal Trainer') {
                $personalTrainer = PersonalTrainer::find($booking->ID_PersonalTrainer);
                $tipeNama = $personalTrainer ? $personalTrainer->nama : null;
            } elseif ($booking->jenis_layanan === 'Gym Class') {
                $gymClass = GymClass::find($booking->ID_GymClass);
                $tipeNama = $gymClass ? $gymClass->nama_kelas : null;
            } elseif ($booking->jenis_layanan === 'Gym Equipment') {
                $gymEquipment = GymEquipment::find($booking->ID_Equipment);
                $tipeNama = $gymEquipment ? $gymEquipment->nama_alat : null;
            }

            $history = History::create([
                'jenis_layanan' => $booking->jenis_layanan,
                'nama_personalTrainer' => $tipeNama,
                'tanggal_booking' => $booking->date,
                'ID_User' => $booking->ID_User,
                'ID_Booking' => $booking->id
            ]);

            return response()->json([
                'status' => true,
                'message' => 'History berhasil dibuat',
                'data' => $history
            ], 200);

        } catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Gagal membuat history",
                "data" => $e->getMessage()
            ], 400);
        }
    }
}
