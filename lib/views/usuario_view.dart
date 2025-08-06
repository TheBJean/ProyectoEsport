import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import '../models/usuario.dart';
import '../services/videojuegos_services.dart';
import '../widgets/resena_form.dart';
import '../widgets/resenas_view.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/star_rating_widget.dart';
import 'login_view.dart';

class UsuarioView extends StatefulWidget {
  final Usuario usuario;

  const UsuarioView({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  @override
  State<UsuarioView> createState() => _UsuarioViewState();
}

class _UsuarioViewState extends State<UsuarioView> {
  final VideojuegoService _service = VideojuegoService();
  List<Videojuego> _videojuegos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarVideojuegos();
  }

  Future<void> _cargarVideojuegos() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final videojuegosStream = _service.obtenerVideojuegos();
      await for (final videojuegos in videojuegosStream) {
        setState(() {
          _videojuegos = videojuegos;
          _isLoading = false;
        });
        break;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _mostrarError('Error al cargar videojuegos: $e');
    }
  }

  void _mostrarFormularioResena(Videojuego videojuego) {
    showDialog(
      context: context,
      builder: (context) => ResenaForm(
        videojuego: videojuego,
        onSave: _guardarVideojuegoConResena,
        nombreUsuario: widget.usuario.usuario,
      ),
    );
  }

  Future<void> _guardarVideojuegoConResena(Videojuego videojuego) async {
    try {
      await _service.actualizarVideojuego(videojuego);
      _cargarVideojuegos();
      _mostrarMensaje('Reseña agregada exitosamente');
    } catch (e) {
      _mostrarError('Error al guardar reseña: $e');
    }
  }

  void _mostrarInfoValoracion(Videojuego videojuego) {
    showDialog(
      context: context,
      builder: (context) {
        final double dialogWidth = MediaQuery.of(context).size.width * 0.95 < 320
            ? MediaQuery.of(context).size.width * 0.95
            : 320;
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2251),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFD700), size: 20),
              const SizedBox(width: 6),
              const Text(
                'Valoración del Videojuego',
                style: TextStyle(
                  color: Color(0xFF66C0F4),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: dialogWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  videojuego.nombre,
                  style: const TextStyle(
                    color: Color(0xFFC7D5E0),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                StarRatingWidget(




































































































































                  rating: videojuego.valoracion,
                ),
                const SizedBox(height: 8),
                Text(
                  '${videojuego.valoracion.toStringAsFixed(1)} / 5.0',
                  style: const TextStyle(
                    color: Color(0xFFC7D5E0),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Esta valoración se calcula como el promedio de todas las reseñas de usuarios.',
                  style: const TextStyle(
                    color: Color(0xFF8F98A0),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Para valorar este juego, agrega una reseña usando el botón de comentarios.',
                  style: const TextStyle(
                    color: Color(0xFF66C0F4),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66C0F4),
                foregroundColor: const Color(0xFF1B2838),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarMiResena(Videojuego videojuego, int indexResena) {
    final resena = videojuego.resenas![indexResena];
    final autorResena = resena['autor'] ?? 'Anónimo';
    final miUsuario = widget.usuario.usuario;

    // Solo permitir eliminar si es mi reseña
    if (autorResena != miUsuario) {
      _mostrarError('Solo puedes eliminar tus propias reseñas');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Eliminar Mi Reseña',
        message: '¿Estás seguro de que quieres eliminar tu reseña?',
        confirmText: 'Eliminar',
        onConfirm: () => _confirmarEliminacionMiResena(videojuego, indexResena),
      ),
    );
  }

  Future<void> _confirmarEliminacionMiResena(Videojuego videojuego, int indexResena) async {
    try {
      if (videojuego.resenas != null && videojuego.resenas!.isNotEmpty) {
        videojuego.resenas!.removeAt(indexResena);
        await _service.actualizarVideojuego(videojuego);
        _cargarVideojuegos();
        _mostrarMensaje('Tu reseña ha sido eliminada');
      }
    } catch (e) {
      _mostrarError('Error al eliminar reseña: $e');
    }
  }

  void _verResenas(Videojuego videojuego) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResenasView(
          videojuego: videojuego,
          esAdmin: false,
          onEliminarResena: (index) => _eliminarMiResena(videojuego, index),
          usuarioActual: widget.usuario,
        ),
      ),
    );
  }

  void _cerrarSesion() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: const Color(0xFF5C7E10),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: const Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2838),
      appBar: AppBar(
        title: const Text(
          'Usuario - Catálogo E-Sports',
          style: TextStyle(
            color: Color(0xFF66C0F4),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.8,
          ),
        ),
        backgroundColor: const Color(0xFF171A21),
        centerTitle: true,
        elevation: 4,
        shadowColor: const Color(0xFF66C0F4).withOpacity(0.3),
        toolbarHeight: 48,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF66C0F4)),
            onPressed: _cerrarSesion,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF66C0F4),
              ),
            )
          : _videojuegos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.games,
                        size: 64,
                        color: const Color(0xFF66C0F4).withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay videojuegos',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFC7D5E0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'No hay videojuegos disponibles',
                        style: TextStyle(
                          color: Color(0xFF8F98A0),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarVideojuegos,
                  color: const Color(0xFF66C0F4),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B2838), Color(0xFF2A475E)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(4.0),
                      itemCount: _videojuegos.length,
                      itemBuilder: (context, index) {
                        final videojuego = _videojuegos[index];
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2A475E), Color(0xFF1B2838)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF66C0F4).withOpacity(0.15),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        videojuego.nombre,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFC7D5E0),
                                          letterSpacing: 0.5,
                                          shadows: [Shadow(color: Color(0xFF66C0F4), blurRadius: 2)],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.add_comment, color: Color(0xFF9B59B6), size: 18),
                                          onPressed: () => _mostrarFormularioResena(videojuego),
                                          tooltip: 'Agregar reseña',
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.visibility, color: Color(0xFF66C0F4), size: 18),
                                          onPressed: () => _verResenas(videojuego),
                                          tooltip: 'Ver reseñas',
                                          padding: const EdgeInsets.all(4),
                                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (videojuego.imagenUrl != null && videojuego.imagenUrl!.isNotEmpty)
                                  Container(
                                    height: 100, // Un poco más grande en vertical
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: videojuego.imagenUrl!.startsWith('http')
                                          ? Image.network(
                                              videojuego.imagenUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: const Color(0xFF1B2838),
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    color: Color(0xFF8F98A0),
                                                    size: 24,
                                                  ),
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              videojuego.imagenUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: const Color(0xFF1B2838),
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    color: Color(0xFF8F98A0),
                                                    size: 24,
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B2838).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    videojuego.descripcion,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8F98A0),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF5C7E10), Color(0xFF4A6B0A)],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF5C7E10).withOpacity(0.3),
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '\$${videojuego.valor.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _mostrarInfoValoracion(videojuego),
                                          child: StarRatingWidget(
                                            rating: videojuego.valoracion,
                                            size: 16,
                                            interactive: false,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          videojuego.valoracion.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFC7D5E0),
                                          ),
                                        ),
                                        if (videojuego.resenas != null && videojuego.resenas!.isNotEmpty) ...[
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () => _verResenas(videojuego),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF66C0F4).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.comment, color: Color(0xFF66C0F4), size: 10),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    '${videojuego.resenas!.length}',
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF66C0F4),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
} 