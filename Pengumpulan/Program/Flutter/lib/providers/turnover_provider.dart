import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/turnover_prediction.dart';
import '../utils/constants.dart';

class TurnoverProvider with ChangeNotifier {
  List<TurnoverPrediction> _predictions = [];
  bool _isLoading = false;

  List<TurnoverPrediction> get predictions {
    return [..._predictions];
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

  Future<void> fetchTurnoverPredictions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/turnover-predictions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<TurnoverPrediction> loadedPredictions = [];

        for (var predictionData in responseData) {
          loadedPredictions.add(TurnoverPrediction.fromJson(predictionData));
        }

        _predictions = loadedPredictions;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load turnover predictions');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
