import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import '../models/usuario.dart';
import '../services/videojuegos_services.dart';
import 'resenas_view.dart';
import '../widgets/videojuego_form_mobile.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/steam_app_bar.dart';
import '../widgets/steam_snackbar.dart';
import '../widgets/videojuego_card.dart';
import '../widgets/action_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_styles.dart';
import 'login_view.dart';

class AdminView extends StatefulWidget {
// crear widgets que sí pueden cambiar su estado durante la ejecución.
  final Usuario usuario;

  const AdminView({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
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

  void _mostrarFormularioVideojuego({Videojuego? videojuego}) {
    showDialog(
      context: context,
      builder: (context) => VideojuegoFormMobile(
        videojuego: videojuego,
        onSave: _guardarVideojuego,
        esAdmin: true,
      ),
    );
  }

  Future<void> _guardarVideojuego(Videojuego videojuego) async {
    try {
      if (videojuego.id == null) {
        await _service.agregarVideojuego(videojuego);
        _mostrarMensaje('Videojuego agregado exitosamente');
      } else {
        await _service.actualizarVideojuego(videojuego);
        _mostrarMensaje('Videojuego actualizado exitosamente');
      }
      _cargarVideojuegos();
    } catch (e) {
      _mostrarError('Error al guardar videojuego: $e');
    }
  }

  void _eliminarVideojuego(Videojuego videojuego) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Eliminar Videojuego',
        message: '¿Estás seguro de que quieres eliminar "${videojuego.nombre}"?',
        confirmText: 'Eliminar',
        onConfirm: () => _confirmarEliminacion(videojuego),
      ),
    );
  }

  Future<void> _confirmarEliminacion(Videojuego videojuego) async {
    try {
      await _service.eliminarVideojuego(videojuego.id!);
      _cargarVideojuegos();
      _mostrarMensaje('Videojuego eliminado exitosamente');
    } catch (e) {
      _mostrarError('Error al eliminar videojuego: $e');
    }
  }

  void _verResenas(Videojuego videojuego) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResenasView(
          videojuego: videojuego,
          esAdmin: true,
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
    SteamSnackBar.showSuccess(context, mensaje);
  }

  void _mostrarError(String mensaje) {
    SteamSnackBar.showError(context, mensaje);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: SteamAppBar(
        title: 'Admin - Catálogo E-Sports',
        onLogout: _cerrarSesion,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _videojuegos.isEmpty
              ? const EmptyState(
                  title: 'No hay videojuegos',
                  subtitle: 'Agrega tu primer videojuego',
                )
              : RefreshIndicator(
                  onRefresh: _cargarVideojuegos,
                  color: AppColors.primary,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: AppStyles.backgroundGradient,
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(4.0),
                      itemCount: _videojuegos.length,
                      itemBuilder: (context, index) {
                        final videojuego = _videojuegos[index];
                        return VideojuegoCard(
                          videojuego: videojuego,
                          actionButtons: [
                            ActionButtons.edit(
                              onPressed: () => _mostrarFormularioVideojuego(videojuego: videojuego),
                            ),
                            ActionButtons.delete(
                              onPressed: () => _eliminarVideojuego(videojuego),
                            ),
                            ActionButtons.view(
                              onPressed: () => _verResenas(videojuego),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () => _mostrarFormularioVideojuego(),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.secondary,
          elevation: 8,
          mini: true,
          child: const Icon(Icons.add, size: 20),
        ),
      ),
    );
  }
} 