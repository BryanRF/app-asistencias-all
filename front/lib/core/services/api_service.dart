import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  
  /// Logging helper para requests
  void _logRequest(String method, String url, Map<String, String> headers, {String? body}) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📤 REQUEST [$method]');
    debugPrint('📍 URL: $url');
    debugPrint('📋 Headers: ${jsonEncode(headers)}');
    if (body != null) {
      debugPrint('📦 Body: $body');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
  
  /// Logging helper para responses
  void _logResponse(http.Response response) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📥 RESPONSE');
    debugPrint('🔢 Status Code: ${response.statusCode}');
    debugPrint('📋 Headers: ${response.headers}');
    debugPrint('📦 Body: ${response.body}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
  
  /// Logging helper para errores
  void _logError(String method, String url, dynamic error, {StackTrace? stackTrace}) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('❌ ERROR [$method]');
    debugPrint('📍 URL: $url');
    debugPrint('💥 Error: $error');
    if (stackTrace != null) {
      debugPrint('📚 StackTrace: $stackTrace');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

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

      final headers = await _getHeaders();
      _logRequest('GET', uri.toString(), headers);

      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(AppConfig.connectTimeout);

      _logResponse(response);
      return _handleResponse(response);
    } catch (e, stackTrace) {
      final apiUrl = await AppConfig.getApiUrl();
      _logError('GET', '$apiUrl$endpoint', e, stackTrace: stackTrace);
      throw Exception('Error en GET: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final apiUrl = await AppConfig.getApiUrl();
      final url = '$apiUrl$endpoint';
      final headers = await _getHeaders();
      final body = jsonEncode(data);
      
      _logRequest('POST', url, headers, body: body);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(AppConfig.connectTimeout);

      _logResponse(response);
      return _handleResponse(response);
    } catch (e, stackTrace) {
      final apiUrl = await AppConfig.getApiUrl();
      _logError('POST', '$apiUrl$endpoint', e, stackTrace: stackTrace);
      throw Exception('Error en POST: $e');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final apiUrl = await AppConfig.getApiUrl();
      final url = '$apiUrl$endpoint';
      final headers = await _getHeaders();
      final body = jsonEncode(data);
      
      _logRequest('PUT', url, headers, body: body);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(AppConfig.connectTimeout);

      _logResponse(response);
      return _handleResponse(response);
    } catch (e, stackTrace) {
      final apiUrl = await AppConfig.getApiUrl();
      _logError('PUT', '$apiUrl$endpoint', e, stackTrace: stackTrace);
      throw Exception('Error en PUT: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final apiUrl = await AppConfig.getApiUrl();
      final url = '$apiUrl$endpoint';
      final headers = await _getHeaders();
      
      _logRequest('DELETE', url, headers);

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      ).timeout(AppConfig.connectTimeout);

      _logResponse(response);
      return _handleResponse(response);
    } catch (e, stackTrace) {
      final apiUrl = await AppConfig.getApiUrl();
      _logError('DELETE', '$apiUrl$endpoint', e, stackTrace: stackTrace);
      throw Exception('Error en DELETE: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('⚠️ Error al parsear JSON de respuesta: $e');
        debugPrint('📦 Body recibido: ${response.body}');
        return {};
      }
    } else {
      try {
        final error = jsonDecode(response.body);
        final errorMessage = error['message'] ?? 'Error en la petición';
        debugPrint('❌ Error en respuesta: Status ${response.statusCode} - $errorMessage');
        throw Exception(errorMessage);
      } catch (e) {
        if (e is Exception && e.toString().contains('Error en respuesta')) {
          rethrow;
        }
        debugPrint('❌ Error al parsear respuesta de error: $e');
        debugPrint('📦 Body recibido: ${response.body}');
        throw Exception('Error en la petición (Status: ${response.statusCode})');
      }
    }
  }
}

