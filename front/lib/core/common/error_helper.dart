import 'dart:io';

/// Helper para convertir errores técnicos en mensajes amigables para el usuario
class ErrorHelper {
  /// Convierte cualquier error en un mensaje amigable
  static String getFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Errores de conexión
    if (error is SocketException || 
        errorString.contains('socketexception') ||
        errorString.contains('connection refused') ||
        errorString.contains('econnrefused') ||
        errorString.contains('network is unreachable') ||
        errorString.contains('no route to host')) {
      return 'Sin conexión. Verifica tu conexión a internet e inténtalo de nuevo.';
    }
    
    // Timeout
    if (errorString.contains('timeout') || 
        errorString.contains('timed out') ||
        errorString.contains('time out')) {
      return 'La conexión tardó demasiado. Inténtalo de nuevo.';
    }
    
    // Error de host no encontrado
    if (errorString.contains('host not found') ||
        errorString.contains('failed host lookup') ||
        errorString.contains('getaddrinfo') ||
        errorString.contains('nodename nor servname')) {
      return 'No se pudo conectar al servidor. Verifica la configuración.';
    }
    
    // Errores de autenticación
    if (errorString.contains('401') || 
        errorString.contains('unauthorized') ||
        errorString.contains('credenciales')) {
      return 'Credenciales incorrectas. Verifica tu DNI y contraseña.';
    }
    
    // Usuario no encontrado o inactivo
    if (errorString.contains('usuario no encontrado') ||
        errorString.contains('user not found')) {
      return 'Usuario no encontrado. Verifica tus datos o contacta al administrador.';
    }
    
    // Sesión expirada
    if (errorString.contains('token') && 
        (errorString.contains('expired') || errorString.contains('invalid'))) {
      return 'Tu sesión ha expirado. Inicia sesión nuevamente.';
    }
    
    // Permisos
    if (errorString.contains('403') || 
        errorString.contains('forbidden') ||
        errorString.contains('permission denied')) {
      return 'No tienes permisos para realizar esta acción.';
    }
    
    // Recurso no encontrado
    if (errorString.contains('404') || 
        errorString.contains('not found')) {
      return 'La información solicitada no está disponible.';
    }
    
    // Error del servidor
    if (errorString.contains('500') || 
        errorString.contains('internal server error') ||
        errorString.contains('error interno')) {
      return 'Error en el servidor. Inténtalo más tarde.';
    }
    
    // Servidor no disponible
    if (errorString.contains('502') || 
        errorString.contains('503') ||
        errorString.contains('bad gateway') ||
        errorString.contains('service unavailable')) {
      return 'El servidor no está disponible. Inténtalo más tarde.';
    }
    
    // Datos duplicados
    if (errorString.contains('duplicate') || 
        errorString.contains('already exists') ||
        errorString.contains('ya existe')) {
      return 'Este registro ya existe en el sistema.';
    }
    
    // Validación de datos
    if (errorString.contains('validation') || 
        errorString.contains('invalid') ||
        errorString.contains('required')) {
      return 'Por favor verifica los datos ingresados.';
    }
    
    // Sin datos / lista vacía
    if (errorString.contains('empty') || 
        errorString.contains('no data') ||
        errorString.contains('no results')) {
      return 'No se encontraron datos.';
    }
    
    // Error genérico - mensaje amigable por defecto
    return 'Ocurrió un error. Inténtalo de nuevo más tarde.';
  }
  
  /// Mensajes específicos para diferentes contextos
  static String getContextualMessage(String context, dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    switch (context) {
      case 'login':
        if (errorString.contains('401') || 
            errorString.contains('unauthorized') ||
            errorString.contains('credenciales')) {
          return 'DNI o contraseña incorrectos.';
        }
        if (errorString.contains('connection') || 
            errorString.contains('socket')) {
          return 'No se pudo conectar. Verifica tu conexión a internet.';
        }
        return 'No se pudo iniciar sesión. Inténtalo de nuevo.';
        
      case 'load_data':
        if (errorString.contains('connection') || 
            errorString.contains('socket')) {
          return 'Sin conexión. Verifica tu internet.';
        }
        return 'No se pudieron cargar los datos. Desliza para reintentar.';
        
      case 'save_data':
        if (errorString.contains('connection') || 
            errorString.contains('socket')) {
          return 'Sin conexión. Los cambios no se guardaron.';
        }
        return 'No se pudo guardar. Inténtalo de nuevo.';
        
      case 'asistencias':
        if (errorString.contains('duplicate') || 
            errorString.contains('ya existe')) {
          return 'Ya se registró la asistencia para esta fecha.';
        }
        return 'Error al registrar asistencias. Inténtalo de nuevo.';
        
      default:
        return getFriendlyMessage(error);
    }
  }
}
