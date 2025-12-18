import '../services/api_service.dart';
import '../common/dto/pagination.dto.dart';

/// Servicio para gestionar Asistencias
class AsistenciasService {
  final ApiService _api = ApiService();

  /// Obtener todas las asistencias con filtros y paginación
  Future<Map<String, dynamic>> findAll({
    PaginationDto? pagination,
    String? fechaInicio,
    String? fechaFin,
    int? horarioId,
    int? alumnoId,
    int? seccionId,
  }) async {
    final queryParams = <String, String>{};
    if (pagination != null) {
      if (pagination.page != null) {
        queryParams['page'] = pagination.page.toString();
      }
      if (pagination.limit != null) {
        queryParams['limit'] = pagination.limit.toString();
      }
    }
    if (fechaInicio != null) {
      queryParams['fechaInicio'] = fechaInicio;
    }
    if (fechaFin != null) {
      queryParams['fechaFin'] = fechaFin;
    }
    if (horarioId != null) {
      queryParams['horarioId'] = horarioId.toString();
    }
    if (alumnoId != null) {
      queryParams['alumnoId'] = alumnoId.toString();
    }
    if (seccionId != null) {
      queryParams['seccionId'] = seccionId.toString();
    }
    return await _api.get('/asistencias', queryParams: queryParams);
  }

  /// Obtener una asistencia por ID
  Future<Map<String, dynamic>> findOne(int id) async {
    return await _api.get('/asistencias/$id');
  }

  /// Obtener asistencias por horario y fecha
  Future<Map<String, dynamic>> getByHorarioAndFecha(
    int horarioId,
    String fecha,
  ) async {
    return await _api.get('/asistencias/horario/$horarioId/fecha/$fecha');
  }

  /// Crear una asistencia individual (solo PROFESOR/ADMIN)
  Future<Map<String, dynamic>> create({
    required int horarioId,
    required int alumnoId,
    required String fecha,
    required String estado,
  }) async {
    return await _api.post('/asistencias', {
      'horarioId': horarioId,
      'alumnoId': alumnoId,
      'fecha': fecha,
      'estado': estado,
    });
  }

  /// Crear múltiples asistencias (solo PROFESOR/ADMIN)
  Future<Map<String, dynamic>> createMultiple({
    required int horarioId,
    required String fecha,
    required List<Map<String, dynamic>> asistencias,
  }) async {
    return await _api.post('/asistencias/multiple', {
      'horarioId': horarioId,
      'fecha': fecha,
      'asistencias': asistencias,
    });
  }
}
