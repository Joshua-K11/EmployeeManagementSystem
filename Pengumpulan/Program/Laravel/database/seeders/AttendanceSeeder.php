<?php

namespace Database\Seeders;

use App\Models\Attendance;
use App\Models\Employee;
use Illuminate\Database\Seeder;
use Carbon\Carbon;

class AttendanceSeeder extends Seeder
{
    public function run(): void
    {
        // Dapatkan semua ID karyawan
        $employeeIds = Employee::pluck('id')->toArray();

        // Buat data dummy untuk 10 hari terakhir (simulasi 2 minggu kerja)
        $startDate = Carbon::now()->subDays(9);

        for ($day = 0; $day <= 9; $day++) {
            $currentDate = (clone $startDate)->addDays($day);

            // Lewati hari Sabtu dan Minggu
            if ($currentDate->isWeekend()) {
                continue;
            }

            // Untuk setiap karyawan, buat data kehadiran
            foreach ($employeeIds as $employeeId) {
                // Acak untuk mensimulasikan kehadiran (90% hadir, 5% terlambat, 5% absen)
                $rand = rand(1, 100);

                if ($rand <= 90) { // Hadir
                    // Waktu check-in acak antara 07:30 - 09:00
                    $checkInHour = rand(7, 8);
                    $checkInMinute = rand(30, 59);
                    if ($checkInHour == 8 && $checkInMinute > 30) {
                        $status = 'Late';
                    } else {
                        $status = 'Present';
                    }

                    $checkInTime = sprintf('%02d:%02d', $checkInHour, $checkInMinute);

                    // Waktu check-out acak antara 16:30 - 18:30
                    $checkOutHour = rand(16, 18);
                    $checkOutMinute = rand(30, 59);
                    $checkOutTime = sprintf('%02d:%02d', $checkOutHour, $checkOutMinute);

                    // Lokasi acak (area kantor)
                    $latitude = -6.2 + (rand(-10, 10) / 1000);
                    $longitude = 106.8 + (rand(-10, 10) / 1000);

                    // 30% kemungkinan ada catatan
                    $notes = null;
                    if (rand(1, 100) <= 30) {
                        $noteOptions = [
                            'Meeting dengan klien siang ini',
                            'WFH setengah hari',
                            'Izin keluar kantor untuk dokter',
                            'Training internal',
                            'Presentasi proyek',
                            'Kerja lembur',
                        ];
                        $notes = $noteOptions[array_rand($noteOptions)];
                    }

                    Attendance::create([
                        'employee_id' => $employeeId,
                        'date' => $currentDate->format('Y-m-d'),
                        'check_in_time' => $checkInTime,
                        'check_out_time' => $checkOutTime,
                        'status' => $status,
                        'latitude' => $latitude,
                        'longitude' => $longitude,
                        'notes' => $notes,
                    ]);
                } elseif ($rand <= 95) { // Terlambat
                    // Waktu check-in acak antara 09:01 - 10:30
                    $checkInHour = rand(9, 10);
                    $checkInMinute = rand(1, 30);

                    $checkInTime = sprintf('%02d:%02d', $checkInHour, $checkInMinute);

                    // Waktu check-out acak antara 17:00 - 19:00
                    $checkOutHour = rand(17, 19);
                    $checkOutMinute = rand(0, 59);
                    $checkOutTime = sprintf('%02d:%02d', $checkOutHour, $checkOutMinute);

                    // Lokasi acak (area kantor)
                    $latitude = -6.2 + (rand(-10, 10) / 1000);
                    $longitude = 106.8 + (rand(-10, 10) / 1000);

                    // 80% kemungkinan ada catatan untuk keterlambatan
                    $notes = null;
                    if (rand(1, 100) <= 80) {
                        $noteOptions = [
                            'Terlambat karena macet',
                            'Ada keadaan darurat keluarga',
                            'Transportasi umum bermasalah',
                            'Terlambat bangun',
                            'Ban bocor dalam perjalanan',
                        ];
                        $notes = $noteOptions[array_rand($noteOptions)];
                    }

                    Attendance::create([
                        'employee_id' => $employeeId,
                        'date' => $currentDate->format('Y-m-d'),
                        'check_in_time' => $checkInTime,
                        'check_out_time' => $checkOutTime,
                        'status' => 'Late',
                        'latitude' => $latitude,
                        'longitude' => $longitude,
                        'notes' => $notes,
                    ]);
                } else { // Absen
                    // 90% kemungkinan ada catatan untuk absen
                    $notes = null;
                    if (rand(1, 100) <= 90) {
                        $noteOptions = [
                            'Sakit',
                            'Cuti tahunan',
                            'Izin keperluan keluarga',
                            'Dinas luar kota',
                            'Cuti melahirkan',
                            'Cuti pernikahan',
                        ];
                        $notes = $noteOptions[array_rand($noteOptions)];
                    }

                    Attendance::create([
                        'employee_id' => $employeeId,
                        'date' => $currentDate->format('Y-m-d'),
                        'check_in_time' => null,
                        'check_out_time' => null,
                        'status' => 'Absent',
                        'latitude' => null,
                        'longitude' => null,
                        'notes' => $notes,
                    ]);
                }
            }
        }
    }
}
