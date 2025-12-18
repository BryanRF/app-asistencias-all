import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  static const String _keyRememberDni = 'remember_dni';
  static const String _keyRememberPassword = 'remember_password';
  static const String _keyRememberMe = 'remember_me';

  Future<Map<String, dynamic>> login(String dni, String password, {bool rememberMe = false}) async {
    try {
      final response = await _api.post('/auth/login', {
        'dni': dni,
        'password': password,
      });

      if (response['access_token'] != null) {
        await _api.setToken(response['access_token']);
      }

      // Guardar credenciales si "Recordarme" está activado
      if (rememberMe) {
        await _saveCredentials(dni, password);
      } else {
        await _clearCredentials();
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveCredentials(String dni, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, true);
    await prefs.setString(_keyRememberDni, dni);
    await prefs.setString(_keyRememberPassword, password);
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, false);
    await prefs.remove(_keyRememberDni);
    await prefs.remove(_keyRememberPassword);
  }

  Future<Map<String, String>?> getRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
    
    if (rememberMe) {
      final dni = prefs.getString(_keyRememberDni);
      final password = prefs.getString(_keyRememberPassword);
      
      if (dni != null && password != null) {
        return {'dni': dni, 'password': password};
      }
    }
    
    return null;
  }

  Future<void> logout() async {
    await _api.clearToken();
    await _clearCredentials();
  }

  Future<bool> isAuthenticated() async {
    final token = await _api.getToken();
    return token != null && token.isNotEmpty;
  }
}

