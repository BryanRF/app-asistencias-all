import '../services/config_service.dart';

/// Configuración de la aplicación
/// Usa ConfigService para obtener el host dinámicamente
class AppConfig {
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static final ConfigService _configService = ConfigService();

  /// Obtiene la URL base de la API de forma asíncrona
  static Future<String> getApiUrl() async {
    return await _configService.getApiUrl();
  }

  /// Obtiene la URL del WebSocket de forma asíncrona
  static Future<String> getWebSocketUrl() async {
    return await _configService.getWebSocketUrl();
  }

  /// Obtiene el host configurado
  static Future<String> getApiHost() async {
    return await _configService.getApiHost();
  }

  /// Establece el host de las APIs
  static Future<void> setApiHost(String host) async {
    await _configService.setApiHost(host);
  }
}

