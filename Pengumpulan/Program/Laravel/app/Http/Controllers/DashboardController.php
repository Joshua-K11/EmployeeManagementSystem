<?php

namespace App\Http\Controllers;

use App\Models\Employee;   
use App\Models\Department;  
use Illuminate\Http\Request;
use Illuminate\View\View; 

class DashboardController extends Controller
{
    /**
     * Tampilkan dashboard dengan data ringkasan.
     * @return \Illuminate\View\View
     */
    public function index(): View
    {
        
        $totalEmployees = Employee::count();
        $totalDepartments = Department::count();
        
        
        $globalAverageSalary = Employee::whereNotNull('salary')->where('salary', '>', 0)->avg('salary');

       
        return view('dashboard', [
            'totalEmployees' => $totalEmployees,
            'totalDepartments' => $totalDepartments,
            'globalAverageSalary' => $globalAverageSalary,
            
        ]);
    }
}