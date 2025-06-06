<?php

namespace App\Http\Controllers;

use App\Models\Employee;   // Import model Employee
use App\Models\Department;  // Import model Department
use Illuminate\Http\Request;
use Illuminate\View\View; // Import View

class DashboardController extends Controller
{
    /**
     * Tampilkan dashboard dengan data ringkasan.
     * @return \Illuminate\View\View
     */
    public function index(): View
    {
        // Mendapatkan data statistik untuk dashboard
        $totalEmployees = Employee::count();
        $totalDepartments = Department::count();
        
        // Hitung rata-rata gaji global, filter karyawan dengan gaji valid (> 0)
        $globalAverageSalary = Employee::whereNotNull('salary')->where('salary', '>', 0)->avg('salary');

        // Kirim data ke view 'dashboard.blade.php'
        return view('dashboard', [
            'totalEmployees' => $totalEmployees,
            'totalDepartments' => $totalDepartments,
            'globalAverageSalary' => $globalAverageSalary,
            // Anda bisa menambahkan data lain di sini jika diperlukan
        ]);
    }
}