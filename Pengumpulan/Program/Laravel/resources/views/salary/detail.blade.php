@extends('layouts.app')

@section('content')
<div class="container">
    <h2>Detail Gaji - {{ $detail['department_name'] }}</h2>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>Nama</th>
                <th>Posisi</th>
                <th>Gaji</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($detail['employees'] as $emp)
                <tr>
                    <td>{{ $emp['name'] }}</td>
                    <td>{{ $emp['position'] }}</td>
                    <td>Rp{{ number_format($emp['salary'], 0, ',', '.') }}</td>
                </tr>
            @endforeach
        </tbody>
        <tfoot>
            <tr class="table-success">
                <th colspan="2">Total Gaji</th>
                <th>Rp{{ number_format($detail['total_salary'], 0, ',', '.') }}</th>
            </tr>
        </tfoot>
    </table>

    <a href="{{ route('salary.summary') }}" class="btn btn-secondary">← Kembali</a>
</div>
@endsection
