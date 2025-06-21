import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/employee.dart';
import '../utils/constants.dart';

// lib/providers/employee_provider.dart
// Add this to your EmployeeProvider class:

class EmployeeProvider with ChangeNotifier {
  List<Employee> _employees = [];
  bool _isLoading = false;
  String? _searchQuery;
  int? _filterDepartmentId;

  List<Employee> get employees {
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      return _employees.where((employee) => 
        employee.name.toLowerCase().contains(_searchQuery!.toLowerCase()) ||
        employee.email.toLowerCase().contains(_searchQuery!.toLowerCase())
      ).toList();
    }
    
    if (_filterDepartmentId != null) {
      return _employees.where((employee) => 
        employee.departmentId == _filterDepartmentId
      ).toList();
    }
    
    return [..._employees];
  }

  // Add this getter for the filter
  int? get filterDepartmentId => _filterDepartmentId;

  bool get isLoading => _isLoading;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterDepartment(int? departmentId) {
    _filterDepartmentId = departmentId;
    notifyListeners();
  }

  // Rest of your provider implementation...


  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    return token;
  }

  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/employees'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Employee> loadedEmployees = [];

        for (var employeeData in responseData) {
          loadedEmployees.add(Employee.fromJson(employeeData));
        }

        _employees = loadedEmployees;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load employees');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addEmployee(Employee employee) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/employees'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(employee.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final newEmployee = Employee.fromJson(responseData);

        _employees.add(newEmployee);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to add employee');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateEmployee(int id, Employee updatedEmployee) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('${Constants.apiUrl}/employees/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedEmployee.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final updated = Employee.fromJson(responseData);

        final employeeIndex = _employees.indexWhere((emp) => emp.id == id);
        if (employeeIndex >= 0) {
          _employees[employeeIndex] = updated;
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to update employee');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteEmployee(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('${Constants.apiUrl}/employees/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _employees.removeWhere((employee) => employee.id == id);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to delete employee');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Employee findById(int id) {
    return _employees.firstWhere((employee) => employee.id == id);
  }
}
