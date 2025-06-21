<?php

namespace App\Http\Controllers;

use App\Models\Employee;
use App\Models\Department; 
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage; 

class EmployeeController extends Controller
{
   
    public function index()
    {
        $employees = Employee::with('department')->latest()->paginate(10); 
        return view('employees.index', compact('employees'));
    }

   
    public function create()
    {
        $departments = Department::all(); 
        return view('employees.create', compact('departments'));
    }

   
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
            $imagePath = $request->file('profile_image')->store('profile_images', 'public'); 
        }

        Employee::create($data);

        return redirect()->route('employees.index')
                         ->with('success', 'Employee created successfully.');
    }

   
    public function show(Employee $employee)
    {
        $employee->load('department');
        return view('employees.show', compact('employee'));
    }


    public function edit(Employee $employee)
    {
        $departments = Department::all();
        return view('employees.edit', compact('employee', 'departments'));
    }

    
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
            //Hapus gambar lama klo ada
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