class Usuario {
  String? id;
  String usuario;
  String password;
  String rol; // 'admin' o 'usuario'

  Usuario({
    this.id,
    required this.usuario,
    required this.password,
    required this.rol,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'password': password,
      'rol': rol,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      usuario: map['usuario'] ?? '',
      password: map['password'] ?? '',
      rol: map['rol'] ?? 'usuario',
    );
  }
} 