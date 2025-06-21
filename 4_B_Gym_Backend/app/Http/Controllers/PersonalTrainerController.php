<?php

namespace App\Http\Controllers;

use App\Models\PersonalTrainer;
use Illuminate\Http\Request;

class PersonalTrainerController extends Controller
{

    public function index()
    {
        try{
            $data = PersonalTrainer::all();
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

    public function store(Request $request)
    {
        try{
            $validatedData = $request->validate([
                'nama' => 'required|string|max:255',
                'umur' => 'required|integer|',
                'jenis_kelamin' => 'required',
                'spesialisasi' => 'required|string|max:255',
                'no_telp' => 'required',
                'harga' => 'required|numeric|min:0',
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);

            if ($request->hasFile('image')) {
                $file = $request->file('image');
                $fileName = time() . '_' . $file->getClientOriginalName(); 
                $file->move(public_path('images'), $fileName); 
                $validatedData['image'] = 'images/' . $fileName; 
            }

            $data = PersonalTrainer::create($validatedData);
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


    public function show(PersonalTrainer $personalTrainer)
    {
        try{
            $data = PersonalTrainer::find($personalTrainer);
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
        try {
            $validatedData = $request->validate([
                'nama' => 'required|string|max:255',
                'umur' => 'required|integer|min:1',
                'jenis_kelamin' => 'required|in:Laki-laki,Perempuan',
                'spesialisasi' => 'required|string|max:255',
                'no_telp' => 'required|string',
                'harga' => 'required|numeric|min:0',
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);
    
            $personalTrainer = PersonalTrainer::find($id);
    
            if (!$personalTrainer) {
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
    
                if ($personalTrainer->image && file_exists(public_path($personalTrainer->image))) {
                    unlink(public_path($personalTrainer->image));
                }
            }

            $personalTrainer->update($validatedData);
            return response()->json([
                "status" => true,
                "message" => "Update successful",
                "data" => $personalTrainer
            ], 200);
        } catch (\Exception $e) {
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
            $data = PersonalTrainer::find($id);
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
