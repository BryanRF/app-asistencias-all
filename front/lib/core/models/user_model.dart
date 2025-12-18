class UserModel {
  final int id;
  final String dni;
  final String nombres;
  final String apellidos;
  final String? email;
  final String rol;

  UserModel({
    required this.id,
    required this.dni,
    required this.nombres,
    required this.apellidos,
    this.email,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      dni: json['dni'] as String,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      email: json['email'] as String?,
      rol: json['rol'] as String,
    );
  }

  String get nombreCompleto => '$nombres $apellidos';
  
  bool get isAlumno => rol == 'ALUMNO';
  bool get isProfesor => rol == 'PROFESOR';
  bool get isAdmin => rol == 'ADMIN';
}

