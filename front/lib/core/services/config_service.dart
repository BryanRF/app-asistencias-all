import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para gestionar la configuración de la aplicación
/// Maneja el host de las APIs de forma dinámica
class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  static const String _keyApiHost = 'api_host';
  static const String _defaultHost = 'http://192.168.101.11:3000';
  static const String _localhostHost = 'http://localhost:3000';

  String? _cachedHost;

  /// Verifica si la aplicación está ejecutándose en modo debug y en desktop
  bool _isDebugDesktop() {
    if (!kDebugMode) return false;
    
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (e) {
      // Si hay error al detectar la plataforma, retornar false
      return false;
    }
  }

  /// Obtiene el host por defecto según el entorno
  String _getDefaultHost() {
    if (_isDebugDesktop()) {
      return _localhostHost;
    }
    return _defaultHost;
  }

  /// Obtiene el host configurado o el host por defecto
  Future<String> getApiHost() async {
    if (_cachedHost != null) {
      return _cachedHost!;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedHost = prefs.getString(_keyApiHost);
    
    // Si no hay host guardado, usar el host por defecto según el entorno
    _cachedHost = savedHost ?? _getDefaultHost();
    return _cachedHost!;
  }

  /// Establece el host de las APIs
  Future<void> setApiHost(String host) async {
    // Validar formato básico de URL
    if (!_isValidUrl(host)) {
      throw ArgumentError('URL inválida. Debe tener el formato: http://host:puerto o https://host:puerto');
    }

    // Normalizar la URL (agregar http:// si no tiene protocolo)
    String normalizedHost = host.trim();
    if (!normalizedHost.startsWith('http://') && !normalizedHost.startsWith('https://')) {
      normalizedHost = 'http://$normalizedHost';
    }

    // Remover barra final si existe
    if (normalizedHost.endsWith('/')) {
      normalizedHost = normalizedHost.substring(0, normalizedHost.length - 1);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiHost, normalizedHost);
    _cachedHost = normalizedHost;
  }

  /// Valida si una URL tiene un formato válido
  bool _isValidUrl(String url) {
    if (url.trim().isEmpty) return false;
    
    final trimmedUrl = url.trim();
    
    // Permitir localhost, IPs, y dominios con o sin protocolo
    // Ejemplos válidos:
    // - localhost:3000
    // - 192.168.1.1:3000
    // - http://localhost:3000
    // - https://api.example.com
    // - api.example.com:3000
    
    final patterns = [
      // localhost con puerto opcional
      r'^localhost(:\d+)?$',
      // IP con puerto opcional
      r'^(\d{1,3}\.){3}\d{1,3}(:\d+)?$',
      // Dominio con puerto opcional
      r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}(:\d+)?$',
      // Con protocolo http/https
      r'^https?://(localhost|(\d{1,3}\.){3}\d{1,3}|([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,})(:\d+)?(/.*)?$',
    ];
    
    for (final pattern in patterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(trimmedUrl)) {
        return true;
      }
    }
    
    return false;
  }

  /// Obtiene la URL base de la API
  Future<String> getApiUrl() async {
    return await getApiHost();
  }

  /// Obtiene la URL del WebSocket
  Future<String> getWebSocketUrl() async {
    final host = await getApiHost();
    // Convertir http:// a ws:// y https:// a wss://
    if (host.startsWith('https://')) {
      return host.replaceFirst('https://', 'wss://');
    } else if (host.startsWith('http://')) {
      return host.replaceFirst('http://', 'ws://');
    }
    return 'ws://$host';
  }

  /// Limpia la configuración guardada
  Future<void> clearConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyApiHost);
    _cachedHost = null;
  }

  /// Resetea al host por defecto según el entorno
  Future<void> resetToDefault() async {
    await setApiHost(_getDefaultHost());
  }
}
