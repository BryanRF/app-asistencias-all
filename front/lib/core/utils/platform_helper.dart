import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
// Import condicional: usa platform_helper_io.dart en desktop, platform_helper_stub.dart en web
import 'platform_helper_stub.dart' if (dart.library.io) 'platform_helper_io.dart' as platform;

/// Helper para detectar la plataforma de forma compatible con web y desktop
class PlatformHelper {
  /// Verifica si la aplicación está ejecutándose en modo debug y en desktop/web
  /// 
  /// Retorna true si:
  /// - Está en modo debug Y
  /// - Es web O es una plataforma desktop nativa (Windows, Linux, macOS)
  static bool isDebugDesktop() {
    if (!kDebugMode) return false;
    
    // Si es web, considerarlo como desktop para desarrollo
    if (kIsWeb) return true;
    
    // Para plataformas nativas, verificar si es desktop
    return platform.PlatformStub.isWindows || 
           platform.PlatformStub.isLinux || 
           platform.PlatformStub.isMacOS;
  }
}
