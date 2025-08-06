import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/videojuego.dart';

class VideojuegoService {
  final CollectionReference _videojuegosRef =
      FirebaseFirestore.instance.collection('videojuegos');

  Future<void> agregarVideojuego(Videojuego videojuego) async {
    try {
      await _videojuegosRef.add(videojuego.toMap());
    } catch (e) {
      print('Error al agregar videojuego: $e');
      rethrow;
    }
  }

  Future<void> actualizarVideojuego(Videojuego videojuego) async {
    try {
      // Usar set() con merge: true para crear o actualizar
      await _videojuegosRef.doc(videojuego.id).set(videojuego.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error al actualizar videojuego: $e');
      rethrow;
    }
  }

  Future<void> eliminarVideojuego(String id) async {
    try {
      await _videojuegosRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar videojuego: $e');
      rethrow;
    }
  }

  Stream<List<Videojuego>> obtenerVideojuegos() {
    try {
      return _videojuegosRef.snapshots().map((snapshot) {
        try {
          return snapshot.docs
              .map((doc) => Videojuego.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .map((videojuego) => _calcularValoracionPromedio(videojuego)) // Calculate average rating
              .toList();
        } catch (e) {
          print('Error al procesar documentos: $e');
          return <Videojuego>[];
        }
      }).handleError((error) {
        print('Error en stream de videojuegos: $error');
        return <Videojuego>[];
      });
    } catch (e) {
      print('Error al obtener videojuegos: $e');
      return Stream.value(<Videojuego>[]);
    }
  }

  // Calculate average rating from user reviews
  Videojuego _calcularValoracionPromedio(Videojuego videojuego) {
    if (videojuego.resenas == null || videojuego.resenas!.isEmpty) {
      return videojuego; // Return original if no reviews
    }

    double sumaRatings = 0.0;
    int contadorRatings = 0;

    for (final resena in videojuego.resenas!) {
      if (resena.containsKey('rating') && resena['rating'] != null) {
        final rating = (resena['rating'] is int) 
            ? (resena['rating'] as int).toDouble() 
            : (resena['rating'] as double);
        sumaRatings += rating;
        contadorRatings++;
      }
    }

    if (contadorRatings > 0) {
      final promedio = sumaRatings / contadorRatings;
      return Videojuego(
        id: videojuego.id,
        nombre: videojuego.nombre,
        descripcion: videojuego.descripcion,
        valor: videojuego.valor,
        valoracion: double.parse(promedio.toStringAsFixed(1)), // Round to 1 decimal
        imagenUrl: videojuego.imagenUrl,
        resenas: videojuego.resenas,
      );
    }

    return videojuego; // Return original if no valid ratings
  }
}
