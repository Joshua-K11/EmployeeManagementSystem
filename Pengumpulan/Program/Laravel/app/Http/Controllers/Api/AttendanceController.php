<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\Employee;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class AttendanceController extends Controller
{
    public function index(): JsonResponse
    {
        $user = Auth::user();
        $employee = Employee::where('email', $user->email)->first();

        if (!$employee) {
            return response()->json(['message' => 'Employee not found'], 404);
        }

        $attendances = Attendance::where('employee_id', $employee->id)
            ->orderBy('date', 'desc')
            ->take(30)
            ->get()
            ->map(function ($attendance) use ($employee) {
                return [
                    'id' => $attendance->id,
                    'employee_id' => $attendance->employee_id,
                    'employee_name' => $employee->name,
                    'date' => $attendance->date->format('Y-m-d'),
                    'check_in_time' => $attendance->check_in_time,
                    'check_out_time' => $attendance->check_out_time,
                    'status' => $attendance->status,
                    'latitude' => $attendance->latitude,
                    'longitude' => $attendance->longitude,
                    'notes' => $attendance->notes,
                ];
            });

        return response()->json($attendances);
    }

    public function checkIn(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'employee_id' => 'required|exists:employees,id',
            'date' => 'required|date',
            'check_in_time' => 'required',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Check if already checked in today
        $existingAttendance = Attendance::where('employee_id', $request->employee_id)
            ->where('date', $request->date)
            ->first();

        if ($existingAttendance) {
            return response()->json([
                'message' => 'Already checked in for today'
            ], 400);
        }

        // Determine status (on time or late)
        $checkInTime = \Carbon\Carbon::createFromFormat('H:i', $request->check_in_time);
        $startTime = \Carbon\Carbon::createFromFormat('H:i', '09:00'); // Work start time

        $status = $checkInTime->lt($startTime) ? 'Present' : 'Late';

        $attendance = Attendance::create([
            'employee_id' => $request->employee_id,
            'date' => $request->date,
            'check_in_time' => $request->check_in_time,
            'status' => $status,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'notes' => $request->notes,
        ]);

        $employee = Employee::find($request->employee_id);

        return response()->json([
            'id' => $attendance->id,
            'employee_id' => $attendance->employee_id,
            'employee_name' => $employee->name,
            'date' => $attendance->date->format('Y-m-d'),
            'check_in_time' => $attendance->check_in_time,
            'check_out_time' => $attendance->check_out_time,
            'status' => $attendance->status,
            'latitude' => $attendance->latitude,
            'longitude' => $attendance->longitude,
            'notes' => $attendance->notes,
        ], 201);
    }

    public function checkOut(Request $request, int $id): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'check_out_time' => 'required',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $attendance = Attendance::findOrFail($id);

        $attendance->update([
            'check_out_time' => $request->check_out_time,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'notes' => $request->has('notes') ? $request->notes : $attendance->notes,
        ]);

        $employee = Employee::find($attendance->employee_id);

        return response()->json([
            'id' => $attendance->id,
            'employee_id' => $attendance->employee_id,
            'employee_name' => $employee->name,
            'date' => $attendance->date->format('Y-m-d'),
            'check_in_time' => $attendance->check_in_time,
            'check_out_time' => $attendance->check_out_time,
            'status' => $attendance->status,
            'latitude' => $attendance->latitude,
            'longitude' => $attendance->longitude,
            'notes' => $attendance->notes,
        ]);
    }
}
