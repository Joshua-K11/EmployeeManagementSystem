<?php

namespace App\Http\Controllers;

use App\Models\Employee;
use App\Models\Department; // Pastikan import Department
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage; // Untuk upload/delete gambar

class EmployeeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $employees = Employee::with('department')->latest()->paginate(10); // Ambil 10 per halaman
        return view('employees.index', compact('employees'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $departments = Department::all(); // Ambil semua departemen untuk dropdown
        return view('employees.create', compact('departments'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:employees,email',
            'position' => 'required|string|max:255',
            'department_id' => 'required|exists:departments,id',
            'salary' => 'required|numeric|min:0',
            'phone_number' => 'required|string|max:20',
            'address' => 'required|string',
            'joining_date' => 'required|date',
            'profile_image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048', 
        ]);

        $data = $request->except('profile_image'); 

        if ($request->hasFile('profile_image')) {
            $imagePath = $request->file('profile_image')->store('profile_images', 'public'); // Simpan di storage/app/public/profile_images
            $data['profile_image'] = $imagePath;
        }

        Employee::create($data);

        return redirect()->route('employees.index')
                         ->with('success', 'Employee created successfully.');
    }

    /**
     * Display the specified resource.
     */
    public function show(Employee $employee)
    {
        $employee->load('department');
        return view('employees.show', compact('employee'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Employee $employee)
    {
        $departments = Department::all();
        return view('employees.edit', compact('employee', 'departments'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Employee $employee)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:employees,email,' . $employee->id,
            'position' => 'required|string|max:255',
            'department_id' => 'required|exists:departments,id',
            'salary' => 'required|numeric|min:0',
            'phone_number' => 'required|string|max:20',
            'address' => 'required|string',
            'joining_date' => 'required|date',
            'profile_image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        $data = $request->except('profile_image');

        if ($request->hasFile('profile_image')) {
            // Hapus gambar lama jika ada
            if ($employee->profile_image) {
                Storage::disk('public')->delete($employee->profile_image);
            }
            $imagePath = $request->file('profile_image')->store('profile_images', 'public');
            $data['profile_image'] = $imagePath;
        }

        $employee->update($data);

        return redirect()->route('employees.index')
                         ->with('success', 'Employee updated successfully.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Employee $employee)
    {
        if ($employee->profile_image) {
            Storage::disk('public')->delete($employee->profile_image);
        }
        $employee->delete();

        return redirect()->route('employees.index')
                         ->with('success', 'Employee deleted successfully.');
    }
}