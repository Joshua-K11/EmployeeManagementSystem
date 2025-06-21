@extends('layouts.app')

@section('content')
<div class="container">
    <h2>Ringkasan Gaji per Departemen</h2>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Departemen</th>
                <th>Jumlah Karyawan</th>
                <th>Total Gaji</th>
                <th>Rata-rata Gaji</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($summaries as $item)
                <tr>
                    <td>{{ $item['department_name'] }}</td>
                    <td>{{ $item['employee_count'] }}</td>
                    <td>Rp{{ number_format($item['total_salary'], 0, ',', '.') }}</td>
                    <td>Rp{{ number_format($item['average_salary'], 0, ',', '.') }}</td>
                    <td>
                        <a href="{{ route('salary.detail', $item['department_id']) }}" class="btn btn-sm btn-info">Lihat Detail</a>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
