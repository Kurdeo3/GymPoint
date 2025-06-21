<?php

namespace App\Http\Controllers;

use App\Models\GymClass;
use Illuminate\Http\Request;

class GymClassController extends Controller
{
    public function index()
    {
        try{
            $data = GymClass::all();
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
                'nama_kelas' => 'required|string|max:255',
                'jenis_kelas' => 'required',
                'deskripsi' => 'required',
                'hari' => 'required',
                'jam' => 'required|date_format:H:i',
                'durasi' => 'required|numeric|min:0',
                'kapasitas' => 'required|numeric|min:0',
                'instruktur' => 'required',
                'harga' => 'required|numeric|min:0',
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);

            if (isset($validatedData['jam'])) {
                $validatedData['jam'] = date('H:i:s', strtotime($validatedData['jam']));
            }

            if ($request->hasFile('image')) {
                $file = $request->file('image');
                $fileName = time() . '_' . $file->getClientOriginalName(); 
                $file->move(public_path('images'), $fileName); 
                $validatedData['image'] = 'images/' . $fileName; 
            }

            $data = GymClass::create($validatedData);
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

    public function show(GymClass $gymClass)
    {
        try{
            $data = GymClass::find($gymClass);
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
                'nama_kelas' => 'sometimes|string|max:255',
                'jenis_kelas' => 'sometimes',
                'deskripsi' => 'sometimes',
                'hari' => 'sometimes|date_format:H:i',
                'jam' => 'sometimes',
                'durasi' => 'sometimes|numeric|min:0',
                'kapasitas' => 'sometimes|numeric|min:0',
                'instruktur' => 'sometimes',
                'harga' => 'sometimes|numeric|min:0',
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);

            $data = GymClass::find($id);

            if (!$data) {
                return response()->json([
                    "status" => false,
                    "message" => "Data not found"
                ], 404);
            }

            if (isset($validatedData['jam'])) {
                $validatedData['jam'] = date('H:i:s', strtotime($validatedData['jam']));
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
            $data = GymClass::find($id);
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
