<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">

                    {{-- 1. Pesan Selamat Datang --}}
                    <h3 class="text-3xl font-bold mb-6 text-gray-800">
                        Selamat Datang Kembali, {{ Auth::user()->name }}!
                    </h3>

                    <p class="text-gray-600 mb-8">
                        Ringkasan data
                    </p>

                    {{-- 2. Ringkasan Statistik Utama (Contoh) --}}
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div class="bg-blue-50 border border-blue-200 rounded-lg p-5 shadow-sm">
                            <h4 class="text-lg font-semibold text-blue-700 mb-2">Total Karyawan</h4>
                            {{-- Asumsi Anda mengirimkan $totalEmployees dari controller --}}
                            <p class="text-3xl font-bold text-blue-900">{{ $totalEmployees ?? 'N/A' }}</p>
                            <a href="{{ route('employees.index') }}" class="text-sm text-blue-500 hover:underline">Lihat Semua Karyawan</a>
                        </div>
                        <div class="bg-green-50 border border-green-200 rounded-lg p-5 shadow-sm">
                            <h4 class="text-lg font-semibold text-green-700 mb-2">Total Departemen</h4>
                            {{-- Asumsi Anda mengirimkan $totalDepartments dari controller --}}
                            <p class="text-3xl font-bold text-green-900">{{ $totalDepartments ?? 'N/A' }}</p>
                            <a href="{{ route('departments.index') }}" class="text-sm text-green-500 hover:underline">Lihat Semua Departemen</a>
                        </div>
                        <div class="bg-purple-50 border border-purple-200 rounded-lg p-5 shadow-sm">
                            <h4 class="text-lg font-semibold text-purple-700 mb-2">Gaji Rata-rata Global</h4>
                            {{-- Asumsi Anda mengirimkan $globalAverageSalary dari controller --}}
                            <p class="text-3xl font-bold text-purple-900">Rp {{ number_format($globalAverageSalary ?? 0, 2, ',', '.') }}</p>
                            <a href="{{ route('analytics.salary') }}" class="text-sm text-purple-500 hover:underline">Detail Analisis Gaji</a>
                        </div>
                    </div>

                    {{-- 3. Aksi Cepat / Pintasan --}}
                    <div class="mb-8">
                        <h4 class="text-xl font-semibold text-gray-800 mb-4">Aksi Cepat</h4>
                        <div class="flex flex-wrap gap-4">
                            <a href="{{ route('employees.create') }}" class="bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-lg shadow-md transition duration-200">
                                Tambah Karyawan Baru
                            </a>
                            <a href="{{ route('departments.create') }}" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-lg shadow-md transition duration-200">
                                Tambah Departemen Baru
                            </a>
                            <a href="{{ route('analytics.index') }}" class="bg-yellow-500 hover:bg-yellow-600 text-gray-800 font-bold py-2 px-4 rounded-lg shadow-md transition duration-200">
                                Lihat Semua Analisis
                            </a>
                            {{-- Contoh untuk check-in / check-out jika ada fitur absensi --}}
                            {{-- <a href="{{ route('attendances.checkIn') }}" class="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded-lg shadow-md transition duration-200">
                                Check-in Hari Ini
                            </a> --}}
                        </div>
                    </div>

                    {{-- 4. Aktivitas Terbaru / Notifikasi (Placeholder) --}}
                    <div>
                        <h4 class="text-xl font-semibold text-gray-800 mb-4">Aktivitas Terbaru</h4>
                        <ul class="list-disc list-inside text-gray-700">
                            <li>Karyawan "Budi Santoso" ditambahkan ke departemen Marketing. (2 jam lalu)</li>
                            <li>Gaji "Siti Aminah" di departemen HR diperbarui. (kemarin)</li>
                            <li>Departemen "Research & Development" dibuat. (3 hari lalu)</li>
                            <li class="text-gray-500">Tidak ada aktivitas baru lainnya.</li>
                        </ul>
                    </div>

                </div>
            </div>
        </div>
    </div>
</x-app-layout>