<?php

namespace App\Http\Controllers;

use App\Services\EmployeeAnalyticsService; // Pastikan ini diimpor
use Illuminate\Http\Request;
use Illuminate\View\View; // Mengimpor View

class DashboardAnalyticsController extends Controller
{
    protected EmployeeAnalyticsService $analyticsService;

    public function __construct(EmployeeAnalyticsService $analyticsService)
    {
        $this->analyticsService = $analyticsService;
    }

    /**
     * Tampilkan halaman utama Analytics di dashboard.
     */
    public function index(): View
    {
        // Panggil service untuk mendapatkan data analisis lengkap
        // Atau Anda bisa memanggil method spesifik seperti demographics(), salary(), dll.
        try {
            $fullAnalysisData = $this->analyticsService->runFullAnalysis();
        } catch (\Exception $e) {
            // Tangani error, bisa dengan menampilkan pesan error di view
            $fullAnalysisData = ['error' => 'Gagal memuat data analisis: ' . $e->getMessage()];
        }

        return view('analytics.index', compact('fullAnalysisData'));
    }

    /**
     * Tampilkan halaman Demografi saja.
     */
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

    /**
     * Tampilkan halaman Gaji saja.
     */
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