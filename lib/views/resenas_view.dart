import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import '../models/usuario.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_styles.dart';
import '../widgets/empty_state.dart';

class ResenasView extends StatelessWidget { 
  //crear widgets que no cambian su estado a lo largo del tiempo.
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
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          'Reseñas - ${videojuego.nombre}',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.primary,
        elevation: 8,
        shadowColor: AppColors.primaryWithOpacity(0.3),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppStyles.backgroundGradient,
        ),
        child: resenas.isEmpty
            ? const EmptyState(
                icon: Icons.comment_outlined,
                title: 'No hay reseñas aún',
                subtitle: 'Sé el primero en dejar una reseña',
                iconSize: 48,
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
                      gradient: AppStyles.cardGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryWithOpacity(0.1),
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
                                  color: AppColors.primaryWithOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  autorResena,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successWithOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#${index + 1}',
                                  style: const TextStyle(
                                    color: AppColors.success,
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
                                      color: AppColors.errorWithOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      esAdmin ? Icons.delete_outline : Icons.delete_forever,
                                      color: AppColors.error,
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
                              color: AppColors.secondaryWithOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primaryWithOpacity(0.2)),
                            ),
                            child: Text(
                              resena['texto'] ?? '',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
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
                                color: AppColors.textSecondary,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatearFecha(resena['fecha']),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              if (esMiResena) ...[
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.purpleWithOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Tú',
                                    style: TextStyle(
                                      color: AppColors.purple,
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