// lib/models/videojuego.dart
class Videojuego {
  String? id;
  String nombre;
  String descripcion;
  double valor;
  double valoracion;
  String? imagenUrl; // <-- Nuevo campo
  List<Map<String, dynamic>>? resenas; // Lista de reseñas
  List<Map<String, dynamic>>? ratings; // Lista de valoraciones por usuario

  Videojuego({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.valor,
    required this.valoracion,
    this.imagenUrl,
    this.resenas,
    this.ratings,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'valor': valor,
      'valoracion': valoracion,
      'imagenUrl': imagenUrl,
      'resenas': resenas,
      'ratings': ratings,
    };
  }

  factory Videojuego.fromMap(Map<String, dynamic> map, String id) {
    return Videojuego(
      id: id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      valor: (map['valor'] ?? 0).toDouble(),
      valoracion: (map['valoracion'] ?? 0).toDouble(),
      imagenUrl: map['imagenUrl'],
      resenas: (map['resenas'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList(),
      ratings: (map['ratings'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
  }
}