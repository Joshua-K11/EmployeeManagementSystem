<?php

namespace App\Http\Controllers;

use App\Services\EmployeeAnalyticsService; 
use Illuminate\Http\Request;
use Illuminate\View\View; 

class DashboardAnalyticsController extends Controller
{
    protected EmployeeAnalyticsService $analyticsService;

    public function __construct(EmployeeAnalyticsService $analyticsService)
    {
        $this->analyticsService = $analyticsService;
    }


    public function index(): View
    {
       
        try {
            $fullAnalysisData = $this->analyticsService->runFullAnalysis();
        } catch (\Exception $e) {
            
            $fullAnalysisData = ['error' => 'Gagal memuat data analisis: ' . $e->getMessage()];
        }

        return view('analytics.index', compact('fullAnalysisData'));
    }
  
    public function demographics(): View
    {
        try {
            $employees = $this->analyticsService->collectEmployeeData();
            $departments = $this->analyticsService->collectDepartmentData();
            $demographicsData = $this->analyticsService->analyzeDemographics($employees, $departments);
        } catch (\Exception $e) {
            $demographicsData = ['error' => 'Gagal memuat data demografi: ' . $e->getMessage()];
        }
        return view('analytics.demographics', compact('demographicsData'));
    }

    public function salary(): View
    {
        try {
            $employees = $this->analyticsService->collectEmployeeData();
            $departments = $this->analyticsService->collectDepartmentData();
            $salaryData = $this->analyticsService->analyzeSalaryDistribution($employees, $departments);
        } catch (\Exception $e) {
            $salaryData = ['error' => 'Gagal memuat data gaji: ' . $e->getMessage()];
        }
        return view('analytics.salary', compact('salaryData'));
    }

}