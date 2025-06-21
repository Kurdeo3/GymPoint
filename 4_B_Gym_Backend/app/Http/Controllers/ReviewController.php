<?php

namespace App\Http\Controllers;

use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index()
    {
        $reviews = Review::with(['user', 'booking'])->get();
        return response()->json($reviews);
    }

    public function show($id)
    {
        $review = Review::with(['user', 'booking'])->find($id);

        if (!$review) {
            return response()->json(['message' => 'Review not found'], 404);
        }

        return response()->json($review);
    }

    public function store(Request $request)
    {
        $request->validate([
            'ulasan' => 'required|string',
            'rating' => 'required|integer|min:1|max:5',
            'ID_Booking' => 'required|exists:bookings,id',
        ], [
            'ulasan.required' => 'Ulasan tidak boleh kosong.',
            'rating.required' => 'Rating tidak boleh kosong.',
            'rating.integer' => 'Rating harus berupa angka.',
            'rating.min' => 'Rating harus diantara 1 - 5.',
            'rating.max' => 'Rating harus diantara 1 - 5.',
            'ID_Booking.required' => 'ID_Booking tidak boleh kosong.',
            'ID_Booking.exists' => 'ID_Booking tidak ditemukan.',
        ]);

        $userId = auth()->id();

        if (!$userId) {
            return response()->json(['message' => 'Unauthenticated'], 401);
        }

        $reviewData = $request->all();
        $reviewData['ID_User'] = $userId;

        $review = Review::create($reviewData);

        return response()->json(['message' => 'Review created successfully', 'data' => $review], 201);
    }

    public function update(Request $request, $id)
{
    $review = Review::find($id);

    if (!$review) {
        return response()->json(['message' => 'Review not found'], 404);
    }

    $validatedData = $request->validate([
        'ulasan' => 'required|string',
        'rating' => 'required|integer|min:1|max:5',
        'ID_Booking' => 'required|exists:bookings,id',
    ], [
        'ulasan.required' => 'Ulasan tidak boleh kosong.',
        'rating.required' => 'Rating tidak boleh kosong.',
        'rating.integer' => 'Rating harus berupa angka.',
        'rating.min' => 'Rating harus diantara 1 - 5.',
        'rating.max' => 'Rating harus diantara 1 - 5.',
        'ID_Booking.required' => 'ID Booking tidak boleh kosong.',
        'ID_Booking.exists' => 'ID Booking tidak ditemukan.',
    ]);

    $review->ulasan = $validatedData['ulasan'];
    $review->rating = $validatedData['rating'];
    $review->ID_Booking = $validatedData['ID_Booking'];
    $review->save();

    return response()->json(['message' => 'Review updated successfully', 'data' => $review]);
}


    public function destroy($id)
    {
        $review = Review::find($id);

        if (!$review) {
            return response()->json(['message' => 'Review not found'], 404);
        }

        $review->delete();

        return response()->json(['message' => 'Review deleted successfully']);
    }
}