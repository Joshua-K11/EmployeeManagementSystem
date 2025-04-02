<?php


use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\EmployeeController;
use App\Http\Controllers\Api\DepartmentController;
use App\Http\Controllers\Api\AnalyticsController;
use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\SalaryController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;

// Rute sederhana untuk testing
Route::get('/test', function () {
    return response()->json(['message' => 'API route is working']);
});

// Route autentikasi
Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);

// Route yang memerlukan autentikasi
Route::middleware('auth:sanctum')->group(function () {
    // Profile
    Route::get('user', [AuthController::class, 'user']);
    Route::post('logout', [AuthController::class, 'logout']);

    // Employees
    Route::apiResource('employees', EmployeeController::class);

    // Departments
    Route::apiResource('departments', DepartmentController::class);

    // Salary
    Route::get('salary/summary', [SalaryController::class, 'summary']);
    Route::get('salary/department/{id}', [SalaryController::class, 'departmentDetail']);

    // Analytics
    Route::prefix('analytics')->group(function () {
        Route::get('/', [AnalyticsController::class, 'index']);
        Route::get('demographics', [AnalyticsController::class, 'demographics']);
        Route::get('salary', [AnalyticsController::class, 'salary']);
        Route::get('turnover', [AnalyticsController::class, 'turnover']);
        Route::get('performance', [AnalyticsController::class, 'performance']);
    });

    // Attendance
    Route::get('attendances', [AttendanceController::class, 'index']);
    Route::post('attendances/check-in', [AttendanceController::class, 'checkIn']);
    Route::put('attendances/check-out/{id}', [AttendanceController::class, 'checkOut']);
});