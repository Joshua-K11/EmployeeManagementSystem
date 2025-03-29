import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/department.dart';
import '../utils/constants.dart';

class DepartmentProvider with ChangeNotifier {
  List<Department> _departments = [];
  bool _isLoading = false;

  List<Department> get departments {
    return [..._departments];
  }

  bool get isLoading => _isLoading;

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    return token;
  }

  Future<void> fetchDepartments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/departments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Department> loadedDepartments = [];

        for (var departmentData in responseData) {
          loadedDepartments.add(Department.fromJson(departmentData));
        }

        _departments = loadedDepartments;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load departments');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addDepartment(Department department) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/departments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(department.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final newDepartment = Department.fromJson(responseData);

        _departments.add(newDepartment);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to add department');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateDepartment(int id, Department updatedDepartment) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('${Constants.apiUrl}/departments/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedDepartment.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final updated = Department.fromJson(responseData);

        final departmentIndex = _departments.indexWhere(
          (dept) => dept.id == id,
        );
        if (departmentIndex >= 0) {
          _departments[departmentIndex] = updated;
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to update department');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteDepartment(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('${Constants.apiUrl}/departments/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _departments.removeWhere((department) => department.id == id);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to delete department');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Department findById(int id) {
    return _departments.firstWhere((department) => department.id == id);
  }
}
