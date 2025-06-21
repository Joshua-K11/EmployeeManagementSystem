<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Employee;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class EmployeeController extends Controller
{
    public function index(): JsonResponse
    {
        $employees = Employee::with('department')->get();
        return response()->json($employees);
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:employees',
            'position' => 'required|string|max:255',
            'department_id' => 'required|exists:departments,id',
            'salary' => 'required|numeric|min:0',
            'phone_number' => 'required|string|max:20',
            'address' => 'required|string',
            'joining_date' => 'required|date',
            'profile_image' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $employee = Employee::create($request->all());
        $employee->load('department');

        return response()->json($employee, 201);
    }

    public function show(int $id): JsonResponse
    {
        $employee = Employee::with('department')->findOrFail($id);
        return response()->json($employee);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $employee = Employee::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'name' => 'string|max:255',
            'email' => 'email|unique:employees,email,' . $id,
            'position' => 'string|max:255',
            'department_id' => 'exists:departments,id',
            'salary' => 'numeric|min:0',
            'phone_number' => 'string|max:20',
            'address' => 'string',
            'joining_date' => 'date',
            'profile_image' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $employee->update($request->all());
        $employee->load('department');

        return response()->json($employee);
    }

    public function destroy(int $id): JsonResponse
    {
        $employee = Employee::findOrFail($id);
        $employee->delete();

        return response()->json(['message' => 'Employee deleted successfully']);
    }
}
