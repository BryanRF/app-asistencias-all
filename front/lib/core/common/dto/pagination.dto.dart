/// DTO para paginación
class PaginationDto {
  final int? page;
  final int? limit;

  const PaginationDto({
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };
  }
}
