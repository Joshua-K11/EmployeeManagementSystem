<?php

namespace Database\Seeders;

use App\Models\Department;
use Illuminate\Database\Seeder;

class DepartmentSeeder extends Seeder
{
    public function run(): void
    {
        $departments = [
            [
                'name' => 'Human Resources',
                'description' => 'Mengelola sumber daya manusia dan urusan kepegawaian'
            ],
            [
                'name' => 'Finance',
                'description' => 'Mengelola keuangan, penggajian, dan akuntansi perusahaan'
            ],
            [
                'name' => 'Information Technology',
                'description' => 'Mengelola infrastruktur IT dan pengembangan sistem'
            ],
            [
                'name' => 'Marketing',
                'description' => 'Mengelola strategi pemasaran dan promosi'
            ],
            [
                'name' => 'Sales',
                'description' => 'Mengelola penjualan dan hubungan dengan klien'
            ],
            [
                'name' => 'Operations',
                'description' => 'Mengelola operasional perusahaan sehari-hari'
            ],
            [
                'name' => 'Research & Development',
                'description' => 'Meneliti dan mengembangkan produk dan teknologi baru'
            ],
        ];

        foreach ($departments as $department) {
            Department::create($department);
        }
    }
}
