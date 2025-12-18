import '../services/api_service.dart';
import '../common/dto/pagination.dto.dart';

/// Servicio para gestionar Horarios
class HorariosService {
  final ApiService _api = ApiService();

  /// Obtener todos los horarios con paginación y filtros
  Future<Map<String, dynamic>> findAll({
    PaginationDto? pagination,
    int? profesorId,
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
    if (profesorId != null) {
      queryParams['profesorId'] = profesorId.toString();
    }
    if (seccionId != null) {
      queryParams['seccionId'] = seccionId.toString();
    }
    return await _api.get('/horarios', queryParams: queryParams);
  }

  /// Obtener horarios por profesor
  Future<Map<String, dynamic>> findByProfesor(int profesorId) async {
    return await _api.get('/horarios/profesor/$profesorId');
  }

  /// Obtener un horario por ID
  Future<Map<String, dynamic>> findOne(int id) async {
    return await _api.get('/horarios/$id');
  }

  /// Obtener alumnos de un horario
  Future<Map<String, dynamic>> getAlumnosByHorario(int horarioId) async {
    return await _api.get('/horarios/$horarioId/alumnos');
  }

  /// Crear un nuevo horario (solo ADMIN/PROFESOR)
  Future<Map<String, dynamic>> create({
    required int cursoId,
    required int seccionId,
    required int turnoId,
    required int profesorId,
    required int diaSemana,
    required String horaInicio,
    required String horaFin,
  }) async {
    return await _api.post('/horarios', {
      'cursoId': cursoId,
      'seccionId': seccionId,
      'turnoId': turnoId,
      'profesorId': profesorId,
      'diaSemana': diaSemana,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
    });
  }
}
