<?php

namespace App\Http\Controllers;

use App\Models\GymEquipment;
use Illuminate\Http\Request;

class GymEquipmentController extends Controller
{
    public function index()
    {
        try{
            $data = GymEquipment::all();
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
                'nama_alat' => 'required|string|max:255',
                'jumlah' => 'required|numeric|min:0',
                'deskripsi' => 'required',
                'jenis_alat' => 'required',
                'harga' => 'required|numeric|min:0',
                'image' => 'nullable|image|mimes:jpeg,jpg,gif,png|max:2048',
            ]);

            if ($request->hasFile('image')) {
                $file = $request->file('image');
                $fileName = time() . '_' . $file->getClientOriginalName(); 
                $file->move(public_path('images'), $fileName); 
                $validatedData['image'] = 'images/' . $fileName; 
            }

            $data = GymEquipment::create($validatedData);
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


    public function show(GymEquipment $gymEquipment)
    {
        try{
            $data = GymEquipment::find($gymEquipment);
            return response()->json([
                "status" => true,
                "message" => "Get successful",
                "data" => $data
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


    public function update(Request $request, $id)
    {
        try{
            $validatedData = $request->validate([
                'nama_alat' => 'sometimes|string|max:255',
                'jumlah' => 'sometimes|numeric|min:0',
                'deskripsi' => 'sometimes',
                'jenis_alat' => 'sometimes',
                'harga' => 'sometimes|numeric|min:0',
                'image' => 'nullable|image|mimes:jpeg,jpg,gif|max:2048',
            ]);

            $data = GymEquipment::find($id);

            if (!$data) {
                return response()->json([
                    "status" => false,
                    "message" => "Data not found"
                ], 404);
            }

            if ($request->hasFile('image')) {
                $file = $request->file('image');
                $fileName = time() . '_' . $file->getClientOriginalName();
                $file->move(public_path('images'), $fileName);
                $validatedData['image'] = 'images/' . $fileName;
    
                if ($data->image && file_exists(public_path($data->image))) {
                    unlink(public_path($data->image));
                }
            }

            $data->update($validatedData);
            return response()->json([
                "status" => true,
                "message" => "Update successful",
                "data" => $data
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


    public function destroy($id)
    {
        try{
            $data = GymEquipment::find($id);
            $data->delete();
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
}
