import '../services/api_service.dart';

/// Servicio para gestionar Reportes
class ReportesService {
  final ApiService _api = ApiService();

  /// Obtener reporte por alumno
  Future<Map<String, dynamic>> reportePorAlumno(
    int alumnoId, {
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final queryParams = <String, String>{};
    if (fechaInicio != null) {
      queryParams['fechaInicio'] = fechaInicio;
    }
    if (fechaFin != null) {
      queryParams['fechaFin'] = fechaFin;
    }
    return await _api.get('/reportes/alumno/$alumnoId', queryParams: queryParams);
  }

  /// Obtener reporte por sección (solo ADMIN/PROFESOR)
  Future<Map<String, dynamic>> reportePorSeccion(
    int seccionId, {
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final queryParams = <String, String>{};
    if (fechaInicio != null) {
      queryParams['fechaInicio'] = fechaInicio;
    }
    if (fechaFin != null) {
      queryParams['fechaFin'] = fechaFin;
    }
    return await _api.get('/reportes/seccion/$seccionId', queryParams: queryParams);
  }

  /// Obtener reporte por curso (solo ADMIN/PROFESOR)
  Future<Map<String, dynamic>> reportePorCurso(
    int cursoId, {
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final queryParams = <String, String>{};
    if (fechaInicio != null) {
      queryParams['fechaInicio'] = fechaInicio;
    }
    if (fechaFin != null) {
      queryParams['fechaFin'] = fechaFin;
    }
    return await _api.get('/reportes/curso/$cursoId', queryParams: queryParams);
  }
}
