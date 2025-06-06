<?php

namespace App\Http\Controllers\Api; // Pastikan namespace ini benar

use App\Http\Controllers\Controller;
use App\Services\EmployeeAnalyticsService;
// Penting: Import model Employee dan Department karena kita akan menggunakannya di sini
use App\Models\Employee;
use App\Models\Department;
use Illuminate\Http\JsonResponse; // Hapus atau ganti ke View jika ini untuk tampilan web
use Illuminate\View\View; // Import ini jika Anda ingin mengembalikan view

class AnalyticsController extends Controller
{
    protected EmployeeAnalyticsService $analyticsService;

    public function __construct(EmployeeAnalyticsService $analyticsService)
    {
        $this->analyticsService = $analyticsService;
    }

    // ... (metode lain seperti index, demographics, turnover, performance) ...

    /**
     * Endpoint untuk analisis gaji saja
     * Mengembalikan tampilan web dengan data analisis gaji.
     * @return \Illuminate\View\View|\Illuminate\Http\JsonResponse
     */
    public function salary() // Hapus `: JsonResponse` jika ini untuk tampilan web
    {
        try {
            // Ambil data dasar karyawan dan departemen dari service
            // Ini akan digunakan untuk perhitungan manual di controller
            $employees = $this->analyticsService->collectEmployeeData();
            $departments = $this->analyticsService->collectDepartmentData();

            // Dapatkan hasil analisis gaji yang sudah ada dari service
            // Saat ini ini hanya 'salary_distribution'
            $salaryAnalysisFromService = $this->analyticsService->analyzeSalaryDistribution($employees, $departments);

            // --- MULAI PERHITUNGAN RATA-RATA GAJI DI CONTROLLER ---
            $salaryDataForView = [];

            // 1. Hitung Rata-rata Gaji Global
            $globalAverageSalary = 0;
            $totalEmployeesWithSalary = $employees->whereNotNull('salary')->where('salary', '>', 0)->count();
            if ($totalEmployeesWithSalary > 0) {
                $globalAverageSalary = $employees->whereNotNull('salary')->where('salary', '>', 0)->avg('salary');
            }
            $salaryDataForView['global_average_salary'] = $globalAverageSalary;

            // 2. Hitung Rata-rata Gaji per Departemen
            $departmentSalaries = [];
            foreach ($departments as $department) {
                $employeesInDept = $employees->where('department_id', $department->id);
                $employeesInDeptWithSalary = $employeesInDept->whereNotNull('salary')->where('salary', '>', 0);

                if ($employeesInDeptWithSalary->count() > 0) {
                    $averageSalaryDept = $employeesInDeptWithSalary->avg('salary');
                    $departmentSalaries[$department->name] = $averageSalaryDept;
                } else {
                    $departmentSalaries[$department->name] = 0; // Jika tidak ada karyawan atau gaji valid
                }
            }
            $salaryDataForView['department_salaries'] = $departmentSalaries;

            // 3. Tambahkan hasil 'salary_distribution' dari service
            $salaryDataForView['salary_distribution'] = $salaryAnalysisFromService['salary_distribution'] ?? [];


            // --- DEBUGGING: UNCOMMENT BARIS INI UNTUK MELIHAT DATA AKHIR ---
            // dd($salaryDataForView);

            // Karena Anda menggunakan Blade view, Anda perlu mengembalikan view, bukan JsonResponse.
            // Pastikan rute '/analytics/salary' ada di 'routes/web.php'
            return view('analytics.salary', ['salaryData' => $salaryDataForView]);

        } catch (\Exception $e) {
            // Jika ini route API, tetap kembalikan JsonResponse
            return response()->json([
                'error' => 'Salary analysis failed',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}