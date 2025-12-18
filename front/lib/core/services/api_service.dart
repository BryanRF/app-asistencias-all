import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final apiUrl = await AppConfig.getApiUrl();
      var uri = Uri.parse('$apiUrl$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      ).timeout(AppConfig.connectTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en GET: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final apiUrl = await AppConfig.getApiUrl();
      final response = await http.post(
        Uri.parse('$apiUrl$endpoint'),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      ).timeout(AppConfig.connectTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en POST: $e');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final apiUrl = await AppConfig.getApiUrl();
      final response = await http.put(
        Uri.parse('$apiUrl$endpoint'),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      ).timeout(AppConfig.connectTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en PUT: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final apiUrl = await AppConfig.getApiUrl();
      final response = await http.delete(
        Uri.parse('$apiUrl$endpoint'),
        headers: await _getHeaders(),
      ).timeout(AppConfig.connectTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en DELETE: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Error en la petición');
    }
  }
}

