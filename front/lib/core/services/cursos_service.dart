import '../services/api_service.dart';
import '../common/dto/pagination.dto.dart';

/// Servicio para gestionar Cursos
class CursosService {
  final ApiService _api = ApiService();

  /// Obtener todos los cursos con paginación
  Future<Map<String, dynamic>> findAll({
    PaginationDto? pagination,
    int? gradoId,
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
    if (gradoId != null) {
      queryParams['gradoId'] = gradoId.toString();
    }
    return await _api.get('/cursos', queryParams: queryParams);
  }

  /// Obtener un curso por ID
  Future<Map<String, dynamic>> findOne(int id) async {
    return await _api.get('/cursos/$id');
  }

  /// Crear un nuevo curso (solo ADMIN/PROFESOR)
  Future<Map<String, dynamic>> create({
    required String nombre,
    required int gradoId,
    String? descripcion,
  }) async {
    return await _api.post('/cursos', {
      'nombre': nombre,
      'gradoId': gradoId,
      if (descripcion != null) 'descripcion': descripcion,
    });
  }
}
