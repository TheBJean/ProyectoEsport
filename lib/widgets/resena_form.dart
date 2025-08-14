import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import 'app_colors.dart';
import 'app_styles.dart';
import 'steam_text_field.dart';
import 'steam_snackbar.dart';

class ResenaForm extends StatefulWidget {
  final Videojuego videojuego;
  final Function(Videojuego) onSave;
  final String? nombreUsuario;

  const ResenaForm({
    Key? key,
    required this.videojuego,
    required this.onSave,
    this.nombreUsuario,
  }) : super(key: key);

  @override
  State<ResenaForm> createState() => _ResenaFormState();
}

class _ResenaFormState extends State<ResenaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _resenaController;
  late TextEditingController _autorController;

  @override
  void initState() {
    super.initState();
    _resenaController = TextEditingController();
    _autorController = TextEditingController(text: widget.nombreUsuario ?? '');
  }

  @override
  void dispose() {
    _resenaController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  void _agregarResena() {
    if (_formKey.currentState!.validate()) {
      final nuevaResena = {
        'texto': _resenaController.text,
        'autor': _autorController.text.isNotEmpty ? _autorController.text : 'Anónimo',
        'fecha': DateTime.now().toIso8601String(),
      };

      final videojuego = Videojuego(
        id: widget.videojuego.id,
        nombre: widget.videojuego.nombre,
        descripcion: widget.videojuego.descripcion,
        valor: widget.videojuego.valor,
        valoracion: widget.videojuego.valoracion,
        imagenUrl: widget.videojuego.imagenUrl,
        resenas: [...(widget.videojuego.resenas ?? []), nuevaResena],
        ratings: widget.videojuego.ratings,
      );
      
      widget.onSave(videojuego);
      _resenaController.clear();
      
      SteamSnackBar.showSuccess(context, 'Reseña agregada exitosamente');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          const Icon(Icons.comment, color: AppColors.primary, size: 20),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Agregar Reseña',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del videojuego (solo lectura)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryWithOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryWithOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.games, color: AppColors.primary, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.videojuego.nombre,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.videojuego.descripcion,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Campo de reseña
              SteamTextField(
                controller: _resenaController,
                label: 'Tu reseña',
                icon: Icons.edit,
                maxLines: 3,
                maxLength: 200,
                helperText: 'Comparte tu opinión sobre este videojuego',
                counterText: ' ${_resenaController.text.length}/200',
                counterStyle: TextStyle(
                  color: _resenaController.text.length > 200 
                      ? AppColors.error
                      : AppColors.textSecondary,
                  fontWeight: _resenaController.text.length > 200 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                ),
                errorText: _resenaController.text.length > 200 
                    ? 'Has excedido el límite' 
                    : null,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa tu reseña';
                  if (v.length > 200) return 'La reseña no puede exceder 200 caracteres';
                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
              // Campo de autor
              SteamTextField(
                controller: _autorController,
                label: 'Tu nombre (opcional)',
                icon: Icons.person,
                helperText: 'Si no lo escribes, aparecerá como "Anónimo"',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: AppStyles.textButtonStyle,
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _agregarResena,
          style: AppStyles.purpleButtonStyle,
          child: const Text('Agregar Reseña'),
        ),
      ],
    );
  }


} 