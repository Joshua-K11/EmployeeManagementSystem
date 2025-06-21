<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Analisis Gaji Karyawan') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">
                    <h3 class="text-2xl font-bold mb-6">{{ __('Detail Analisis Gaji') }}</h3>

                    @isset($salaryData['error'])
                        <p class="text-red-600 mb-4">{{ $salaryData['error'] }}</p>
                    @else
                        {{-- Rata-rata Gaji Global --}}
                        @if(isset($salaryData['global_average_salary']))
                            <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                                <p class="text-lg font-semibold text-green-800">Rata-rata Gaji Global: <span class="text-2xl">Rp {{ number_format($salaryData['global_average_salary'], 2, ',', '.') }}</span></p>
                            </div>
                        @endif

                        {{-- Rata-rata Gaji per Departemen --}}
                        @if(isset($salaryData['department_salaries']) && is_array($salaryData['department_salaries']))
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Rata-rata Gaji per Departemen</h4>
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow-sm">
                                        <thead>
                                            <tr class="bg-gray-100">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Departemen</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Rata-rata Gaji</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @forelse($salaryData['department_salaries'] as $deptName => $avgSalary)
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                                        {{ $deptName }}
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                                        Rp {{ number_format($avgSalary, 2, ',', '.') }}
                                                    </td>
                                                </tr>
                                            @empty
                                                <tr>
                                                    <td colspan="2" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                                        Tidak ada data gaji per departemen.
                                                    </td>
                                                </tr>
                                            @endforelse
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @else
                            <p class="text-gray-600 mb-4">Tidak ada data rata-rata gaji per departemen yang tersedia.</p>
                        @endif

                        {{-- Anda bisa menambahkan bagian lain dari analisis gaji di sini, misalnya detail per karyawan --}}
                        {{-- Contoh: Daftar Karyawan dan Gaji Masing-masing --}}
                        @if(isset($salaryData['employees_with_salaries']) && is_array($salaryData['employees_with_salaries']) && count($salaryData['employees_with_salaries']) > 0)
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Daftar Gaji Karyawan</h4>
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow-sm">
                                        <thead>
                                            <tr class="bg-gray-100">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Karyawan</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Posisi</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Departemen</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Gaji</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @foreach($salaryData['employees_with_salaries'] as $employee)
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ $employee['name'] }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">{{ $employee['position'] }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">{{ $employee['department_name'] }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">Rp {{ number_format($employee['salary'], 2, ',', '.') }}</td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @elseif(isset($salaryData['employees_with_salaries']) && count($salaryData['employees_with_salaries']) == 0)
                            <p class="text-gray-600 mb-4">Tidak ada data karyawan untuk ditampilkan.</p>
                        @endif

                    @endisset
                </div>
            </div>
        </div>
    </div>
</x-app-layout>