import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuth => _user != null;

  /// Fungsi **Login**
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      // Debugging: Print response dari API Laravel
      print('Response from API: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Pastikan token tersedia dalam respons API
        if (responseData.containsKey('token') &&
            responseData['token'] != null) {
          _user = User.fromJson(responseData);

          // Simpan token ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', _user!.token);

          _isLoading = false;
          notifyListeners();
        } else {
          throw Exception('Token tidak ditemukan dalam respons API');
        }
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Fungsi **Register**
  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      print('Response from API (Register): ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // Pastikan token tersedia
        if (responseData.containsKey('token') &&
            responseData['token'] != null) {
          _user = User.fromJson(responseData);

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', _user!.token);

          _isLoading = false;
          notifyListeners();
        } else {
          throw Exception('Token tidak ditemukan dalam respons API');
        }
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception(responseData['message'] ?? 'Registration failed');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// **Coba Auto Login**
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return false;
    }

    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${Constants.apiUrl}/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response from API (AutoLogin): ${response.body}');

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        _user = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          token: token!,
        );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  /// **Logout**
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    notifyListeners();
  }
}
