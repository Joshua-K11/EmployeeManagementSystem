<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Dashboard Analisis Karyawan') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">
                    <h3 class="text-2xl font-bold text-gray-900 mb-6">{{ __('Ringkasan Analisis Karyawan') }}</h3>

                    @isset($fullAnalysisData['error'])
                        <p class="text-red-600 mb-4">{{ $fullAnalysisData['error'] }}</p>
                    @else
                        {{-- Tampilkan Total Karyawan (jika ada di data) --}}
                        @if(isset($fullAnalysisData['total_employees']))
                            <div class="mb-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
                                <p class="text-lg font-semibold text-blue-800">Total Karyawan: <span class="text-2xl">{{ $fullAnalysisData['total_employees'] }}</span></p>
                            </div>
                        @endif

                        {{-- Bagian Karyawan per Departemen --}}
                        @if(isset($fullAnalysisData['employees_by_department']) && is_array($fullAnalysisData['employees_by_department']))
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Karyawan per Departemen</h4>
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow-sm">
                                        <thead>
                                            <tr class="bg-gray-100">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Departemen</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jumlah Karyawan</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @foreach($fullAnalysisData['employees_by_department'] as $departmentName => $count)
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $departmentName }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $count }}</td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @endif

                        {{-- Bagian Karyawan per Masa Kerja (Tenure) --}}
                        @if(isset($fullAnalysisData['employees_by_tenure']) && is_array($fullAnalysisData['employees_by_tenure']))
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Karyawan per Masa Kerja</h4>
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow-sm">
                                        <thead>
                                            <tr class="bg-gray-100">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Masa Kerja</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jumlah Karyawan</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @foreach($fullAnalysisData['employees_by_tenure'] as $tenureRange => $count)
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $tenureRange }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $count }}</td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @endif

                        {{-- Bagian Distribusi Gaji --}}
                        @if(isset($fullAnalysisData['salary_distribution']) && is_array($fullAnalysisData['salary_distribution']))
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Distribusi Gaji</h4>
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow-sm">
                                        <thead>
                                            <tr class="bg-gray-100">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Rentang Gaji</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Persentase (%)</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @foreach($fullAnalysisData['salary_distribution'] as $range => $percentage)
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $range }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ number_format($percentage, 2) }}%</td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @endif

                        {{-- Bagian Resiko Turnover --}}
                        @if(isset($fullAnalysisData['turnover_risk']) && is_array($fullAnalysisData['turnover_risk']))
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Resiko Turnover (Nama Karyawan: Skor Resiko)</h4>
                                <ul class="list-disc list-inside bg-gray-50 p-4 border border-gray-200 rounded-lg">
                                    @foreach($fullAnalysisData['turnover_risk'] as $employeeName => $riskScore)
                                        <li class="mb-1 text-sm text-gray-900">{{ $employeeName }}: {{ number_format($riskScore * 100, 2) }}%</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        {{-- Tambahkan bagian lain sesuai dengan output runFullAnalysis Anda --}}

                    @endisset

                    <div class="mt-6 flex space-x-4">
                        <a href="{{ route('analytics.demographics') }}" class="inline-flex items-center px-4 py-2 bg-gray-800 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 active:bg-gray-900 focus:outline-none focus:border-gray-900 focus:ring ring-gray-300 disabled:opacity-25 transition ease-in-out duration-150">
                            Lihat Demografi Detail
                        </a>
                        <a href="{{ route('analytics.salary') }}" class="inline-flex items-center px-4 py-2 bg-gray-800 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 active:bg-gray-900 focus:outline-none focus:border-gray-900 focus:ring ring-gray-300 disabled:opacity-25 transition ease-in-out duration-150">
                            Lihat Gaji Detail
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>