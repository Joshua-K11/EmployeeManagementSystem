<?php

namespace App\Http\Controllers\Api; 

use App\Http\Controllers\Controller;
use App\Services\EmployeeAnalyticsService;

use App\Models\Employee;
use App\Models\Department;
use Illuminate\Http\JsonResponse; 
use Illuminate\View\View; 

class AnalyticsController extends Controller
{
    protected EmployeeAnalyticsService $analyticsService;

    public function __construct(EmployeeAnalyticsService $analyticsService)
    {
        $this->analyticsService = $analyticsService;
    }

    /**
     * Endpoint untuk analisis gaji saja
     * Mengembalikan tampilan web dengan data analisis gaji.
     * @return \Illuminate\View\View|\Illuminate\Http\JsonResponse
     */
    public function salary()
    {
        try {
            
            $employees = $this->analyticsService->collectEmployeeData();
            $departments = $this->analyticsService->collectDepartmentData();

    
            $salaryAnalysisFromService = $this->analyticsService->analyzeSalaryDistribution($employees, $departments);

            $salaryDataForView = [];

            // Rata2 gaji global
            $globalAverageSalary = 0;
            $totalEmployeesWithSalary = $employees->whereNotNull('salary')->where('salary', '>', 0)->count();
            if ($totalEmployeesWithSalary > 0) {
                $globalAverageSalary = $employees->whereNotNull('salary')->where('salary', '>', 0)->avg('salary');
            }
            $salaryDataForView['global_average_salary'] = $globalAverageSalary;

            // Gaji per departemen
            $departmentSalaries = [];
            foreach ($departments as $department) {
                $employeesInDept = $employees->where('department_id', $department->id);
                $employeesInDeptWithSalary = $employeesInDept->whereNotNull('salary')->where('salary', '>', 0);

                if ($employeesInDeptWithSalary->count() > 0) {
                    $averageSalaryDept = $employeesInDeptWithSalary->avg('salary');
                    $departmentSalaries[$department->name] = $averageSalaryDept;
                } else {
                    $departmentSalaries[$department->name] = 0; 
                }
            }
            $salaryDataForView['department_salaries'] = $departmentSalaries;

            $salaryDataForView['salary_distribution'] = $salaryAnalysisFromService['salary_distribution'] ?? [];

            
            return view('analytics.salary', ['salaryData' => $salaryDataForView]);

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Salary analysis failed',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}