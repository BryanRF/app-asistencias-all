import '../services/api_service.dart';
import '../common/dto/pagination.dto.dart';

/// Servicio para gestionar Secciones
class SeccionesService {
  final ApiService _api = ApiService();

  /// Obtener todas las secciones con paginación
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
    return await _api.get('/secciones', queryParams: queryParams);
  }

  /// Obtener una sección por ID
  Future<Map<String, dynamic>> findOne(int id) async {
    return await _api.get('/secciones/$id');
  }

  /// Crear una nueva sección (solo ADMIN/PROFESOR)
  Future<Map<String, dynamic>> create({
    required String nombre,
    required int gradoId,
    String? descripcion,
  }) async {
    return await _api.post('/secciones', {
      'nombre': nombre,
      'gradoId': gradoId,
      if (descripcion != null) 'descripcion': descripcion,
    });
  }
}
