<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Employee;
use App\Models\Department;
use Illuminate\Http\JsonResponse;

class SalaryController extends Controller
{
    public function summary(): JsonResponse
    {
        $departments = Department::withCount('employees')->get();
        $summaries = [];

        foreach ($departments as $department) {
            $employees = Employee::where('department_id', $department->id)->get();

            if ($employees->count() > 0) {
                $totalSalary = $employees->sum('salary');
                $avgSalary = $employees->count() > 0 ? $totalSalary / $employees->count() : 0;

                $summaries[] = [
                    'department_id' => $department->id,
                    'department_name' => $department->name,
                    'employee_count' => $department->employees_count,
                    'total_salary' => $totalSalary,
                    'average_salary' => $avgSalary,
                ];
            }
        }

        return response()->json($summaries);
    }

    public function departmentDetail(int $id): JsonResponse
    {
        $department = Department::findOrFail($id);
        $employees = Employee::where('department_id', $id)->get();

        if ($employees->count() === 0) {
            return response()->json([
                'message' => 'No employees found in this department'
            ], 404);
        }

        $totalSalary = $employees->sum('salary');

        $employeeSalaries = $employees->map(function ($employee) {
            return [
                'id' => $employee->id,
                'name' => $employee->name,
                'position' => $employee->position,
                'salary' => $employee->salary,
            ];
        });

        return response()->json([
            'department_id' => $department->id,
            'department_name' => $department->name,
            'employees' => $employeeSalaries,
            'total_salary' => $totalSalary,
        ]);
    }
}
