<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\PersonalTrainerController;
use App\Http\Controllers\GymClassController;
use App\Http\Controllers\GymEquipmentController;
use App\Http\Controllers\BookingsController;
use App\Http\Controllers\HistoryController;
use App\Http\Controllers\ReviewController;

Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);
Route::post('/logout', [UserController::class, 'logout']);
Route::middleware('auth:api')->group(function () {
    Route::get('/user', [UserController::class, 'index']);
    Route::get('/show/{id}', [UserController::class, 'show']);
    Route::post('/update', [UserController::class, 'update']);
    Route::delete('/delete', [UserController::class, 'destroy']);
    Route::get('/user/loginSaatIni', [UserController::class, 'loginSaatIni']);
    Route::post('/user/uploadProfilePicture', [UserController::class, 'uploadProfilePicture']);

    Route::get('/bookings', [BookingsController::class, 'index']);
    Route::post('/bookings/create', [BookingsController::class, 'store']);
    Route::get('/bookings/{id}', [BookingsController::class, 'findSpecificBooking']);

    Route::get('/history', [HistoryController::class, 'index']);
    Route::post('/history/create', [HistoryController::class, 'store']);
    Route::get('/history/{jenisLayanan}', [HistoryController::class, 'indexSpecificByType']);

    Route::resource('reviews', ReviewController::class);
});
Route::resource('personalTrainer', PersonalTrainerController::class);
Route::resource('gymClass', GymClassController::class);
Route::resource('gymEquipment', GymEquipmentController::class);

Route::post('/personalTrainer/update/{id}', [PersonalTrainerController::class, 'update']);
Route::post('/gymClass/update/{id}', [GymClassController::class, 'update']);
Route::post('/gymEquipment/update/{id}', [GymEquipmentController::class, 'update']);