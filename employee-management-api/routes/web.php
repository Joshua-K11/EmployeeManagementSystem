<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\DepartmentController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\DashboardAnalyticsController; 
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardController;



Route::get('/', function () {
    return view('welcome');
});

Route::get('/dashboard', [DashboardController::class, 'index'])
    ->middleware(['auth', 'verified']) // Pastikan middleware autentikasi tetap ada
    ->name('dashboard');
// Route::get('/dashboard', function () {
//     return view('dashboard');
// })->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    Route::resource('departments', DepartmentController::class);
    Route::resource('employees', EmployeeController::class);

    
    Route::prefix('analytics')->name('analytics.')->group(function () {
        Route::get('/', [DashboardAnalyticsController::class, 'index'])->name('index');
        Route::get('/demographics', [DashboardAnalyticsController::class, 'demographics'])->name('demographics');
        Route::get('/salary', [DashboardAnalyticsController::class, 'salary'])->name('salary');
        
    });
});

require __DIR__.'/auth.php';