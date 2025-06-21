<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Analisis Demografi Karyawan') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">
                    <h3 class="text-2xl font-bold mb-6">{{ __('Detail Demografi Karyawan') }}</h3>

                    @isset($demographicsData['error'])
                        <p class="text-red-600 mb-4">{{ $demographicsData['error'] }}</p>
                    @else
                        {{-- Karyawan Berdasarkan Jenis Kelamin --}}
                        @if(isset($demographicsData['employees_by_gender']) && is_array($demographicsData['employees_by_gender']))
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Karyawan Berdasarkan Jenis Kelamin</h4>
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow-sm">
                                        <thead>
                                            <tr class="bg-gray-100">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jenis Kelamin</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jumlah</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @foreach($demographicsData['employees_by_gender'] as $gender => $count)
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $gender }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $count }}</td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @endif

                        {{-- Karyawan Berdasarkan Kelompok Usia --}}
                        @if(isset($demographicsData['employees_by_age_group']) && is_array($demographicsData['employees_by_age_group']))
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Karyawan Berdasarkan Kelompok Usia</h4>
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow-sm">
                                        <thead>
                                            <tr class="bg-gray-100">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Rentang Usia</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jumlah</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @foreach($demographicsData['employees_by_age_group'] as $ageGroup => $count)
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $ageGroup }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $count }}</td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @endif

                        {{-- Karyawan Berdasarkan Departemen (Jika Anda mengirim data ini secara terpisah di demografi) --}}
                        @if(isset($demographicsData['employees_by_department']) && is_array($demographicsData['employees_by_department']))
                            <div class="mb-8">
                                <h4 class="text-xl font-semibold text-gray-800 mb-3">Karyawan Berdasarkan Departemen</h4>
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white border border-gray-200 rounded-lg shadow-sm">
                                        <thead>
                                            <tr class="bg-gray-100">
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Departemen</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jumlah</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @foreach($demographicsData['employees_by_department'] as $deptName => $count)
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $deptName }}</td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $count }}</td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @endif

                    @endisset

                    <div class="mt-6">
                        <a href="{{ route('analytics.index') }}" class="inline-flex items-center px-4 py-2 bg-gray-800 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 active:bg-gray-900 focus:outline-none focus:border-gray-900 focus:ring ring-gray-300 disabled:opacity-25 transition ease-in-out duration-150">
                            Kembali ke Ringkasan Analisis
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>