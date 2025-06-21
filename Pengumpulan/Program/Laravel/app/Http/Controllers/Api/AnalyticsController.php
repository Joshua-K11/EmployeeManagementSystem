<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\EmployeeAnalyticsService;
use Illuminate\Http\JsonResponse;

class AnalyticsController extends Controller
{
    protected EmployeeAnalyticsService $analyticsService;

    public function __construct(EmployeeAnalyticsService $analyticsService)
    {
        $this->analyticsService = $analyticsService;
    }

    /**
     * Endpoint utama untuk analisis lengkap
     */
    public function index(): JsonResponse
    {
        try {
            $data = $this->analyticsService->runFullAnalysis();
            return response()->json($data);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Analytics processing failed',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Endpoint untuk analisis demografi saja
     */
    public function demographics(): JsonResponse
    {
        try {
            $employees = $this->analyticsService->collectEmployeeData();
            $departments = $this->analyticsService->collectDepartmentData();

            $demographics = $this->analyticsService->analyzeDemographics($employees, $departments);

            return response()->json($demographics);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Demographics analysis failed',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Endpoint untuk analisis gaji saja
     */
    public function salary(): JsonResponse
    {
        try {
            $employees = $this->analyticsService->collectEmployeeData();
            $departments = $this->analyticsService->collectDepartmentData();

            $salaryAnalysis = $this->analyticsService->analyzeSalaryDistribution($employees, $departments);

            return response()->json($salaryAnalysis);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Salary analysis failed',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Endpoint untuk analisis turnover saja
     */
    public function turnover(): JsonResponse
    {
        try {
            $employees = $this->analyticsService->collectEmployeeData();

            $turnoverAnalysis = $this->analyticsService->analyzeTurnoverRisk($employees);

            return response()->json($turnoverAnalysis);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Turnover analysis failed',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Endpoint untuk analisis performa saja
     */
    public function performance(): JsonResponse
    {
        try {
            $performanceAnalysis = $this->analyticsService->analyzePerformanceTrends();

            return response()->json($performanceAnalysis);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Performance analysis failed',
                'message' => $e->getMessage(),
            ], 500);
        }
    }
}
