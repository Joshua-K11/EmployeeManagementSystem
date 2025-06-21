<?php

namespace Database\Seeders;

use App\Models\Employee;
use Illuminate\Database\Seeder;
use Carbon\Carbon;

class EmployeeSeeder extends Seeder
{
    public function run(): void
    {
        $employees = [
            // Human Resources (ID: 1)
            [
                'name' => 'Budi Santoso',
                'email' => 'budi.santoso@example.com',
                'position' => 'HR Manager',
                'department_id' => 1,
                'salary' => 18000000,
                'phone_number' => '081234567890',
                'address' => 'Jl. Merdeka No. 123, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(5)->format('Y-m-d'),
            ],
            [
                'name' => 'Siti Rahma',
                'email' => 'siti.rahma@example.com',
                'position' => 'HR Specialist',
                'department_id' => 1,
                'salary' => 8500000,
                'phone_number' => '081234567891',
                'address' => 'Jl. Gatot Subroto No. 45, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(2)->subMonths(3)->format('Y-m-d'),
            ],
            [
                'name' => 'Dewi Lestari',
                'email' => 'dewi.lestari@example.com',
                'position' => 'Recruitment Officer',
                'department_id' => 1,
                'salary' => 7000000,
                'phone_number' => '081234567892',
                'address' => 'Jl. Sudirman No. 78, Jakarta Pusat',
                'joining_date' => Carbon::now()->subMonths(8)->format('Y-m-d'),
            ],

            // Finance (ID: 2)
            [
                'name' => 'Agus Wijaya',
                'email' => 'agus.wijaya@example.com',
                'position' => 'Finance Director',
                'department_id' => 2,
                'salary' => 25000000,
                'phone_number' => '081234567893',
                'address' => 'Jl. Kuningan No. 56, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(7)->format('Y-m-d'),
            ],
            [
                'name' => 'Maya Sari',
                'email' => 'maya.sari@example.com',
                'position' => 'Senior Accountant',
                'department_id' => 2,
                'salary' => 13500000,
                'phone_number' => '081234567894',
                'address' => 'Jl. Tebet Raya No. 101, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(4)->subMonths(2)->format('Y-m-d'),
            ],
            [
                'name' => 'Reza Gunawan',
                'email' => 'reza.gunawan@example.com',
                'position' => 'Financial Analyst',
                'department_id' => 2,
                'salary' => 11000000,
                'phone_number' => '081234567895',
                'address' => 'Jl. Kemang No. 88, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(1)->subMonths(7)->format('Y-m-d'),
            ],

            // IT (ID: 3)
            [
                'name' => 'Andi Prasetyo',
                'email' => 'andi.prasetyo@example.com',
                'position' => 'IT Manager',
                'department_id' => 3,
                'salary' => 22000000,
                'phone_number' => '081234567896',
                'address' => 'Jl. Casablanca No. 33, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(4)->subMonths(6)->format('Y-m-d'),
            ],
            [
                'name' => 'Dian Kusuma',
                'email' => 'dian.kusuma@example.com',
                'position' => 'Senior Developer',
                'department_id' => 3,
                'salary' => 17500000,
                'phone_number' => '081234567897',
                'address' => 'Jl. Rasuna Said No. 12, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(3)->format('Y-m-d'),
            ],
            [
                'name' => 'Bambang Hermawan',
                'email' => 'bambang.hermawan@example.com',
                'position' => 'Network Administrator',
                'department_id' => 3,
                'salary' => 12000000,
                'phone_number' => '081234567898',
                'address' => 'Jl. Menteng Raya No. 55, Jakarta Pusat',
                'joining_date' => Carbon::now()->subYears(2)->subMonths(8)->format('Y-m-d'),
            ],
            [
                'name' => 'Nina Anggraini',
                'email' => 'nina.anggraini@example.com',
                'position' => 'Web Developer',
                'department_id' => 3,
                'salary' => 9500000,
                'phone_number' => '081234567899',
                'address' => 'Jl. Cikini No. 67, Jakarta Pusat',
                'joining_date' => Carbon::now()->subYears(1)->format('Y-m-d'),
            ],
            [
                'name' => 'Faisal Rahman',
                'email' => 'faisal.rahman@example.com',
                'position' => 'Junior Developer',
                'department_id' => 3,
                'salary' => 7000000,
                'phone_number' => '081234567800',
                'address' => 'Jl. Panglima Polim No. 22, Jakarta Selatan',
                'joining_date' => Carbon::now()->subMonths(6)->format('Y-m-d'),
            ],

            // Marketing (ID: 4)
            [
                'name' => 'Ratna Dewi',
                'email' => 'ratna.dewi@example.com',
                'position' => 'Marketing Director',
                'department_id' => 4,
                'salary' => 21000000,
                'phone_number' => '081234567801',
                'address' => 'Jl. Thamrin No. 44, Jakarta Pusat',
                'joining_date' => Carbon::now()->subYears(6)->format('Y-m-d'),
            ],
            [
                'name' => 'Hendra Surya',
                'email' => 'hendra.surya@example.com',
                'position' => 'Digital Marketing Specialist',
                'department_id' => 4,
                'salary' => 11500000,
                'phone_number' => '081234567802',
                'address' => 'Jl. Senopati No. 74, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(2)->subMonths(5)->format('Y-m-d'),
            ],
            [
                'name' => 'Indah Pertiwi',
                'email' => 'indah.pertiwi@example.com',
                'position' => 'Content Creator',
                'department_id' => 4,
                'salary' => 8000000,
                'phone_number' => '081234567803',
                'address' => 'Jl. Wijaya No. 29, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(1)->subMonths(3)->format('Y-m-d'),
            ],

            // Sales (ID: 5)
            [
                'name' => 'Joko Susilo',
                'email' => 'joko.susilo@example.com',
                'position' => 'Sales Manager',
                'department_id' => 5,
                'salary' => 19000000,
                'phone_number' => '081234567804',
                'address' => 'Jl. Prapanca No. 15, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(5)->subMonths(2)->format('Y-m-d'),
            ],
            [
                'name' => 'Lina Mariana',
                'email' => 'lina.mariana@example.com',
                'position' => 'Sales Executive',
                'department_id' => 5,
                'salary' => 9000000,
                'phone_number' => '081234567805',
                'address' => 'Jl. Fatmawati No. 61, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(2)->format('Y-m-d'),
            ],
            [
                'name' => 'Budi Rahardjo',
                'email' => 'budi.rahardjo@example.com',
                'position' => 'Sales Representative',
                'department_id' => 5,
                'salary' => 6500000,
                'phone_number' => '081234567806',
                'address' => 'Jl. Simatupang No. 34, Jakarta Selatan',
                'joining_date' => Carbon::now()->subMonths(9)->format('Y-m-d'),
            ],

            // Operations (ID: 6)
            [
                'name' => 'Wati Susanti',
                'email' => 'wati.susanti@example.com',
                'position' => 'Operations Director',
                'department_id' => 6,
                'salary' => 24000000,
                'phone_number' => '081234567807',
                'address' => 'Jl. Antasari No. 82, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(8)->format('Y-m-d'),
            ],
            [
                'name' => 'Dedi Kurniawan',
                'email' => 'dedi.kurniawan@example.com',
                'position' => 'Operations Manager',
                'department_id' => 6,
                'salary' => 15000000,
                'phone_number' => '081234567808',
                'address' => 'Jl. Melawai No. 53, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(3)->subMonths(7)->format('Y-m-d'),
            ],
            [
                'name' => 'Rina Febriani',
                'email' => 'rina.febriani@example.com',
                'position' => 'Quality Control Officer',
                'department_id' => 6,
                'salary' => 8500000,
                'phone_number' => '081234567809',
                'address' => 'Jl. Cipete No. 27, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(1)->subMonths(11)->format('Y-m-d'),
            ],

            // R&D (ID: 7)
            [
                'name' => 'Gunawan Santoso',
                'email' => 'gunawan.santoso@example.com',
                'position' => 'R&D Director',
                'department_id' => 7,
                'salary' => 27000000,
                'phone_number' => '081234567810',
                'address' => 'Jl. Brawijaya No. 39, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(6)->subMonths(8)->format('Y-m-d'),
            ],
            [
                'name' => 'Sri Yulianti',
                'email' => 'sri.yulianti@example.com',
                'position' => 'Senior Researcher',
                'department_id' => 7,
                'salary' => 16000000,
                'phone_number' => '081234567811',
                'address' => 'Jl. Radio Dalam No. 75, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(4)->subMonths(3)->format('Y-m-d'),
            ],
            [
                'name' => 'Tono Supriyadi',
                'email' => 'tono.supriyadi@example.com',
                'position' => 'Product Developer',
                'department_id' => 7,
                'salary' => 12500000,
                'phone_number' => '081234567812',
                'address' => 'Jl. Gandaria No. 49, Jakarta Selatan',
                'joining_date' => Carbon::now()->subYears(2)->subMonths(6)->format('Y-m-d'),
            ],
            [
                'name' => 'Anita Pratiwi',
                'email' => 'anita.pratiwi@example.com',
                'position' => 'Research Assistant',
                'department_id' => 7,
                'salary' => 7500000,
                'phone_number' => '081234567813',
                'address' => 'Jl. Kebayoran Baru No. 17, Jakarta Selatan',
                'joining_date' => Carbon::now()->subMonths(5)->format('Y-m-d'),
            ],
        ];

        foreach ($employees as $employee) {
            Employee::create($employee);
        }
    }
}
