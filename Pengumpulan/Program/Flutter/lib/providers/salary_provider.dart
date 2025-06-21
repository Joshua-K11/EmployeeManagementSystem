import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/salary_summary.dart';
import '../utils/constants.dart';

class SalaryProvider with ChangeNotifier {
  List<SalarySummary> _salarySummaries = [];
  SalaryDetail? _selectedDepartmentDetail;
  bool _isLoading = false;

  List<SalarySummary> get salarySummaries {
    return [..._salarySummaries];
  }

  SalaryDetail? get selectedDepartmentDetail {
    return _selectedDepartmentDetail;
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

  Future<void> fetchSalarySummaries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/salary/summary'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<SalarySummary> loadedSummaries = [];

        for (var summaryData in responseData) {
          loadedSummaries.add(SalarySummary.fromJson(summaryData));
        }

        _salarySummaries = loadedSummaries;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load salary summaries');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchDepartmentSalaryDetail(int departmentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/salary/department/$departmentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _selectedDepartmentDetail = SalaryDetail.fromJson(responseData);

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load department salary detail');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
