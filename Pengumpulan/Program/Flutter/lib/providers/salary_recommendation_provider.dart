import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/salary_recommendation.dart';
import '../utils/constants.dart';

class SalaryRecommendationProvider with ChangeNotifier {
  List<SalaryRecommendation> _recommendations = [];
  bool _isLoading = false;

  List<SalaryRecommendation> get recommendations {
    return [..._recommendations];
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

  Future<void> fetchSalaryRecommendations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/salary-recommendations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<SalaryRecommendation> loadedRecommendations = [];

        for (var recommendationData in responseData) {
          loadedRecommendations.add(
            SalaryRecommendation.fromJson(recommendationData),
          );
        }

        _recommendations = loadedRecommendations;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load salary recommendations');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
