import '../services/api_service.dart';
import '../common/dto/pagination.dto.dart';

/// Servicio para gestionar Grados
class GradosService {
  final ApiService _api = ApiService();

  /// Obtener todos los grados con paginación
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
    return await _api.get('/grados', queryParams: queryParams);
  }

  /// Obtener un grado por ID
  Future<Map<String, dynamic>> findOne(int id) async {
    return await _api.get('/grados/$id');
  }

  /// Crear un nuevo grado (solo ADMIN/PROFESOR)
  Future<Map<String, dynamic>> create({
    required String nombre,
    String? descripcion,
  }) async {
    return await _api.post('/grados', {
      'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
    });
  }
}
