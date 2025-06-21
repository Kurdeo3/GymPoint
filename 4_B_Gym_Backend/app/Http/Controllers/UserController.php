<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{

    public function register(Request $request)
    {
        try{
            $request->validate([
                'nama' => 'required|string|max:255',
                'username' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:5',
                'umur' => 'required',
                'jenis_kelamin' => 'required',
                'no_telp' => 'required',
                'profile_picture' => 'nullable|image|mimes:jpg,png,jpeg|max:2048',
            ]);

            $profilePicturePath = null;
            if ($request->hasFile('profile_picture')) {
                $profilePicturePath = $request->file('profile_picture')->store('images', 'public');
            }

            $user = User::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'username' => $request->username,
                'password' => Hash::make($request->password),
                'umur' => $request->umur,
                'jenis_kelamin' => $request->jenis_kelamin,
                'no_telp' => $request->no_telp,
                'profile_picture' => $profilePicturePath,
            ]);

            return response()->json([
                'user' => $user,
                'message' => 'User registered successfully'
            ], 201);
        } 
        catch (Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function index()
    {
        try{
            $data = User::all();
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

    public function login(Request $request)
    {
        try {
            $request->validate([
                'username' => 'required|string',
                'password' => 'required|string|min:5',
            ]);
            $user = User::where('username', $request->username)->first();

            if (!$user) {
                return response()->json(['message' => 'Username tidak tersedia'], 404);
            }

            if (!Hash::check($request->password, $user->password)) {
                return response()->json(['message' => 'Password tidak tersedia'], 401);
            }

            $token = $user->createToken('Personal Access Token')->plainTextToken;

            return response()->json([
                'detail' => $user,
                'token' => $token
            ]);
        } 
        catch (Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function loginSaatIni(Request $request)
    {
        try {
            $user = Auth::user();
            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'Tidak ada user yang sedang login'
                ], 401);
            }

            return response()->json([
                'status' => true,
                'message' => 'User  yang sedang login',
                'data' => $user
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function logout(Request $request)
    {
        try {
            //cek apakah ada usernya
            if (Auth::check()) {
                //hapus token
                $request->user()->currentAccessToken()->delete();
                //output
                return response()->json(['message' => 'Logged out successfully']);
            }
        }
        catch (Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Not logged in",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function show(string $id)
    {
        try{
            $data = User::find($id);
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

    public function update(Request $request)
    {
        try {
            $user = Auth::user();
            if (!$user) {
                return response()->json(['message' => 'User tidak ada'], 404);
            }

            $validatedData = $request->validate([
                'nama' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users,email,' . $user->id,
                'umur' => 'required',
                'jenis_kelamin' => 'required',
                'no_telp' => 'required',
            ]);
            
            if ($request->hasFile('profile_picture')) {
                if ($user->profile_picture) {
                    Storage::disk('public')->delete($user->profile_picture);
                }

                $validatedData['profile_picture'] = $request->file('profile_picture')->store('images', 'public');
            }

            $user->update($validatedData);

            return response()->json([
                'user' => $user,
                'message' => 'User updated successfully'
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

    public function destroy()
    {
        try {
            $user = Auth::user();
            if (!$user) {
                return response()->json(['message' => 'User tidak ditemukan atau tidak memiliki akses'], 401);
            }

            $user->delete();

            return response()->json(['message' => 'User berhasil di hapus.'], 200);
        }
        catch(Exception $e){
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }

    public function uploadProfilePicture(Request $request)
    {
        try {
            $request->validate([
                'profile_picture' => 'required|image|mimes:jpg,png,jpeg|max:2048',
            ]);
            $user = Auth::user();
            if (!$user) {
                return response()->json(['message' => 'User  tidak ada'], 404);
            }
    
            if ($user->profile_picture) {
                $oldFilePath = public_path($user->profile_picture);
                if (file_exists($oldFilePath)) {
                    unlink($oldFilePath);
                }
            }
            $file = $request->file('profile_picture');
            $fileName = time() . '_' . $file->getClientOriginalName(); 
            $file->move(public_path('images'), $fileName); 
    
            $user->update(['profile_picture' => 'images/' . $fileName]);
    
            return response()->json([
                'message' => 'Profile picture uploaded successfully',
                'profile_picture' => 'images/' . $fileName,
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                "status" => false,
                "message" => "Something went wrong",
                "data" => $e->getMessage()
            ], 400);
        }
    }
}
