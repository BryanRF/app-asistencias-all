import '../services/api_service.dart';
import '../common/dto/pagination.dto.dart';

/// Servicio para gestionar Turnos
class TurnosService {
  final ApiService _api = ApiService();

  /// Obtener todos los turnos con paginación
  Future<Map<String, dynamic>> findAll({PaginationDto? pagination}) async {
    final queryParams = <String, String>{};
    if (pagination != null) {
      if (pagination.page != null) {
        queryParams['page'] = pagination.page.toString();
      }
      if (pagination.limit != null) {
        queryParams['limit'] = pagination.limit.toString();
      }
    }
    return await _api.get('/turnos', queryParams: queryParams);
  }

  /// Obtener un turno por ID
  Future<Map<String, dynamic>> findOne(int id) async {
    return await _api.get('/turnos/$id');
  }

  /// Crear un nuevo turno (solo ADMIN/PROFESOR)
  Future<Map<String, dynamic>> create({
    required String nombre,
    String? descripcion,
  }) async {
    return await _api.post('/turnos', {
      'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
    });
  }
}
