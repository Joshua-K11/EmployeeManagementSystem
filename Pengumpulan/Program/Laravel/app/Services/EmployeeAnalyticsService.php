<?php

namespace App\Services;

use App\Models\Employee;
use App\Models\Department;
use Carbon\Carbon;
use Illuminate\Support\Collection;

class EmployeeAnalyticsService
{
    /**
     * Menjalankan analisis terstruktur lengkap
     */
    public function runFullAnalysis(): array
    {
        // Tahap 1: Pengumpulan data
        $employees = $this->collectEmployeeData();
        $departments = $this->collectDepartmentData();

        // Tahap 2: Analisis demografi
        $demographicsAnalysis = $this->analyzeDemographics($employees, $departments);

        // Tahap 3: Analisis gaji
        $salaryAnalysis = $this->analyzeSalaryDistribution($employees, $departments);

        // Tahap 4: Prediksi turnover
        $turnoverAnalysis = $this->analyzeTurnoverRisk($employees);

        // Tahap 5: Analisis performa
        $performanceAnalysis = $this->analyzePerformanceTrends();

        // Tahap 6: Integrasi hasil
        return array_merge(
            $demographicsAnalysis,
            $salaryAnalysis,
            $turnoverAnalysis,
            $performanceAnalysis
        );
    }

    /**
     * Tahap 1: Pengumpulan data karyawan
     */
    public function collectEmployeeData(): Collection
    {
        return Employee::with('department')->get();
    }

    /**
     * Tahap 1: Pengumpulan data departemen
     */
    public function collectDepartmentData(): Collection
    {
        return Department::withCount('employees')->get();
    }

    /**
     * Tahap 2: Analisis demografi
     */
    public function analyzeDemographics(Collection $employees, Collection $departments): array
    {
        // Distribusi departemen
        $employeesByDepartment = $departments->pluck('employees_count', 'name')->toArray();

        // Analisis masa kerja
        $now = Carbon::now();
        $employeesByTenure = [
            'Less than 1 year' => 0,
            '1-3 years' => 0,
            '3-5 years' => 0,
            '5+ years' => 0,
        ];

        foreach ($employees as $employee) {
            $joiningDate = Carbon::parse($employee->joining_date);
            $years = $joiningDate->diffInYears($now);

            if ($years < 1) {
                $employeesByTenure['Less than 1 year']++;
            } elseif ($years < 3) {
                $employeesByTenure['1-3 years']++;
            } elseif ($years < 5) {
                $employeesByTenure['3-5 years']++;
            } else {
                $employeesByTenure['5+ years']++;
            }
        }

        return [
            'employees_by_department' => $employeesByDepartment,
            'employees_by_tenure' => $employeesByTenure,
        ];
    }

    /**
     * Tahap 3: Analisis gaji
     */
    public function analyzeSalaryDistribution(Collection $employees, Collection $departments): array
    {
        // Distribusi rentang gaji
        $salaryRanges = [
            '0-5M' => 0,
            '5M-10M' => 0,
            '10M-15M' => 0,
            '15M-20M' => 0,
            '20M+' => 0,
        ];

        $totalEmployees = $employees->count();

        foreach ($employees as $employee) {
            $salary = $employee->salary;
            if ($salary < 5000000) {
                $salaryRanges['0-5M']++;
            } elseif ($salary < 10000000) {
                $salaryRanges['5M-10M']++;
            } elseif ($salary < 15000000) {
                $salaryRanges['10M-15M']++;
            } elseif ($salary < 20000000) {
                $salaryRanges['15M-20M']++;
            } else {
                $salaryRanges['20M+']++;
            }
        }

        // Konversi ke persentase
        $salaryDistribution = [];
        if ($totalEmployees > 0) {
            foreach ($salaryRanges as $range => $count) {
                $salaryDistribution[$range] = ($count / $totalEmployees) * 100;
            }
        }

        return [
            'salary_distribution' => $salaryDistribution,
        ];
    }

    /**
     * Tahap 4: Analisis risiko turnover
     */
    public function analyzeTurnoverRisk(Collection $employees): array
    {
        $now = Carbon::now();
        $turnoverRisk = [];

        foreach ($employees as $employee) {
            // Hitung faktor risiko
            $joiningDate = Carbon::parse($employee->joining_date);
            $tenureInYears = $joiningDate->diffInYears($now);

            // Implementasi algoritma risiko
            $riskFactor = 0;

            // Faktor masa kerja
            if ($tenureInYears < 1) {
                $riskFactor += 0.4;
            } elseif ($tenureInYears < 2) {
                $riskFactor += 0.3;
            } elseif ($tenureInYears < 3) {
                $riskFactor += 0.2;
            } else {
                $riskFactor += 0.1;
            }

            // Faktor gaji
            if ($employee->salary < 5000000) {
                $riskFactor += 0.4;
            } elseif ($employee->salary < 10000000) {
                $riskFactor += 0.3;
            } elseif ($employee->salary < 15000000) {
                $riskFactor += 0.2;
            } else {
                $riskFactor += 0.1;
            }

            // Normalisasi skor (0-1)
            $riskFactor = $riskFactor / 0.8;
            $riskFactor = min($riskFactor, 1.0);

            $turnoverRisk[$employee->name] = $riskFactor;
        }

        // Sortir dan ambil 5 tertinggi
        arsort($turnoverRisk);
        $highRiskEmployees = array_slice($turnoverRisk, 0, 5, true);

        return [
            'turnover_risk' => $highRiskEmployees,
        ];
    }

    /**
     * Tahap 5: Analisis performa
     */
    public function analyzePerformanceTrends(): array
    {
        // Data contoh (dummy)
        $performanceTrend = [
            ['month' => 'Jan', 'score' => 78],
            ['month' => 'Feb', 'score' => 82],
            ['month' => 'Mar', 'score' => 81],
            ['month' => 'Apr', 'score' => 85],
            ['month' => 'May', 'score' => 84],
            ['month' => 'Jun', 'score' => 87],
        ];

        return [
            'performance_trend' => $performanceTrend,
        ];
    }
}
