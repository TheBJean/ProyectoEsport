import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import '../models/usuario.dart';

class ResenasView extends StatelessWidget {
  final Videojuego videojuego;
  final bool esAdmin;
  final Function(int)? onEliminarResena;
  final Usuario? usuarioActual;

  const ResenasView({
    Key? key,
    required this.videojuego,
    this.esAdmin = false,
    this.onEliminarResena,
    this.usuarioActual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resenas = videojuego.resenas ?? [];
    
    return Scaffold(
      backgroundColor: const Color(0xFF1B2838),
      appBar: AppBar(
        title: Text(
          'Reseñas - ${videojuego.nombre}',
          style: const TextStyle(
            color: Color(0xFF66C0F4),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFF171A21),
        foregroundColor: const Color(0xFF66C0F4),
        elevation: 8,
        shadowColor: const Color(0xFF66C0F4).withOpacity(0.3),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B2838), Color(0xFF2A475E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: resenas.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 48,
                      color: const Color(0xFF66C0F4).withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No hay reseñas aún',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFC7D5E0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sé el primero en dejar una reseña',
                      style: TextStyle(
                        color: Color(0xFF8F98A0),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: resenas.length,
                itemBuilder: (context, index) {
                  final resena = resenas[index];
                  final autorResena = resena['autor'] ?? 'Anónimo';
                  final esMiResena = usuarioActual != null && autorResena == usuarioActual!.usuario;
                  final puedeEliminar = esAdmin || esMiResena;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2A475E), Color(0xFF1B2838)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF66C0F4).withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF66C0F4).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF66C0F4),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  autorResena,
                                  style: const TextStyle(
                                    color: Color(0xFF66C0F4),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5C7E10).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#${index + 1}',
                                  style: const TextStyle(
                                    color: Color(0xFF5C7E10),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (puedeEliminar && onEliminarResena != null) ...[
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => onEliminarResena!(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE74C3C).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      esAdmin ? Icons.delete_outline : Icons.delete_forever,
                                      color: const Color(0xFFE74C3C),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B2838).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.2)),
                            ),
                            child: Text(
                              resena['texto'] ?? '',
                              style: const TextStyle(
                                color: Color(0xFFC7D5E0),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Color(0xFF8F98A0),
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatearFecha(resena['fecha']),
                                style: const TextStyle(
                                  color: Color(0xFF8F98A0),
                                  fontSize: 12,
                                ),
                              ),
                              if (esMiResena) ...[
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9B59B6).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Tú',
                                    style: TextStyle(
                                      color: Color(0xFF9B59B6),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null) return 'Fecha desconocida';
    
    try {
      final dateTime = DateTime.parse(fecha);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays > 0) {
        return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'Ahora mismo';
      }
    } catch (e) {
      return 'Fecha desconocida';
    }
  }
} 