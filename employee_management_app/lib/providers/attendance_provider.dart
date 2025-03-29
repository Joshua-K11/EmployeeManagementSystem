import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import '../models/attendance.dart';
import '../utils/constants.dart';

class AttendanceProvider with ChangeNotifier {
  List<Attendance> _attendances = [];
  bool _isLoading = false;
  bool _isCheckedIn = false;
  Attendance? _todayAttendance;

  List<Attendance> get attendances {
    return [..._attendances];
  }

  bool get isLoading => _isLoading;
  bool get isCheckedIn => _isCheckedIn;
  Attendance? get todayAttendance => _todayAttendance;

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    return token;
  }

  Future<void> fetchAttendances() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/attendances'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Attendance> loadedAttendances = [];

        for (var attendanceData in responseData) {
          loadedAttendances.add(Attendance.fromJson(attendanceData));
        }

        _attendances = loadedAttendances;

        // Check if there's an attendance for today
        final today = DateTime.now().toString().split(' ')[0];
        final todayAttendances = _attendances.where((att) => att.date == today);
        if (todayAttendances.isNotEmpty) {
          _todayAttendance = todayAttendances.first;
          _isCheckedIn = true;
        } else {
          _isCheckedIn = false;
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load attendances');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> checkIn(int employeeId, String? notes) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get current location
      final position = await _determinePosition();

      final token = await _getToken();
      final now = DateTime.now();
      final date = now.toString().split(' ')[0];
      final time =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final attendanceData = {
        'employee_id': employeeId,
        'date': date,
        'check_in_time': time,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'notes': notes,
      };

      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/attendances/check-in'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(attendanceData),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final newAttendance = Attendance.fromJson(responseData);

        _attendances.add(newAttendance);
        _isCheckedIn = true;
        _todayAttendance = newAttendance;

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to check in');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> checkOut(int attendanceId, String? notes) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get current location
      final position = await _determinePosition();

      final token = await _getToken();
      final now = DateTime.now();
      final time =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final checkoutData = {
        'check_out_time': time,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'notes': notes,
      };

      final response = await http.put(
        Uri.parse('${Constants.apiUrl}/attendances/check-out/$attendanceId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(checkoutData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updatedAttendance = Attendance.fromJson(responseData);

        final index = _attendances.indexWhere((att) => att.id == attendanceId);
        if (index != -1) {
          _attendances[index] = updatedAttendance;
        }

        _todayAttendance = updatedAttendance;

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to check out');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
