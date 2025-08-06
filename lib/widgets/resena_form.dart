import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import 'star_rating_widget.dart';

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
  double _rating = 0.0; // Default rating

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
        'rating': _rating, // Add user rating to the review
      };

      final videojuego = Videojuego(
        id: widget.videojuego.id,
        nombre: widget.videojuego.nombre,
        descripcion: widget.videojuego.descripcion,
        valor: widget.videojuego.valor,
        valoracion: widget.videojuego.valoracion,
        imagenUrl: widget.videojuego.imagenUrl,
        resenas: [...(widget.videojuego.resenas ?? []), nuevaResena],
      );
      
      widget.onSave(videojuego);
      _resenaController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text('Reseña agregada exitosamente'),
            ],
          ),
          backgroundColor: const Color(0xFF5C7E10),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(8),
          duration: const Duration(seconds: 2),
        ),
      );
      
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1F2251),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          const Icon(Icons.comment, color: Color(0xFF66C0F4), size: 20),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Agregar Reseña',
              style: const TextStyle(
                color: Color(0xFF66C0F4),
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
                  color: const Color(0xFF1B2838).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.games, color: Color(0xFF66C0F4), size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.videojuego.nombre,
                            style: const TextStyle(
                              color: Color(0xFFC7D5E0),
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
                        color: Color(0xFF8F98A0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Campo de reseña
              _buildSteamTextField(
                controller: _resenaController,
                label: 'Tu reseña',
                icon: Icons.edit,
                maxLines: 3,
                maxLength: 200,
                helperText: 'Comparte tu opinión sobre este videojuego',
                counterText: '${_resenaController.text.length}/200',
                counterStyle: TextStyle(
                  color: _resenaController.text.length > 200 
                      ? const Color(0xFFE74C3C)
                      : const Color(0xFF8F98A0),
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
              _buildSteamTextField(
                controller: _autorController,
                label: 'Tu nombre (opcional)',
                icon: Icons.person,
                helperText: 'Si no lo escribes, aparecerá como "Anónimo"',
              ),
              const SizedBox(height: 16),
              // Sección de valoración
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2838).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          'Tu valoración',
                          style: TextStyle(
                            color: Color(0xFF66C0F4),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Star rating widget
                    Center(
                      child: StarRatingWidget(
                        rating: _rating,
                        size: 32,
                        interactive: true,
                        onRatingChanged: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Slider for precise rating
                    Column(
                      children: [
                        Text(
                          'Valoración exacta: ${_rating.toStringAsFixed(1)} / 5.0',
                          style: const TextStyle(
                            color: Color(0xFFC7D5E0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFFFFD700),
                            inactiveTrackColor: const Color(0xFF8F98A0).withOpacity(0.3),
                            thumbColor: const Color(0xFFFFD700),
                            overlayColor: const Color(0xFFFFD700).withOpacity(0.2),
                            valueIndicatorColor: const Color(0xFF1B2838),
                            valueIndicatorTextStyle: const TextStyle(
                              color: Color(0xFFC7D5E0),
                              fontSize: 12,
                            ),
                          ),
                          child: Slider(
                            value: _rating,
                            min: 0.0,
                            max: 5.0,
                            divisions: 50, // 0.1 increments
                            label: _rating.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                _rating = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF8F98A0),
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _agregarResena,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9B59B6),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Agregar Reseña'),
        ),
      ],
    );
  }

  Widget _buildSteamTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int? maxLines,
    int? maxLength,
    String? helperText,
    String? counterText,
    TextStyle? counterStyle,
    String? errorText,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
        color: const Color(0xFF1B2838).withOpacity(0.5),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF8F98A0), fontSize: 12),
          prefixIcon: Icon(icon, color: const Color(0xFF66C0F4), size: 18),
          helperText: helperText,
          helperStyle: const TextStyle(color: Color(0xFF8F98A0), fontSize: 10),
          counterText: counterText,
          counterStyle: counterStyle,
          errorText: errorText,
          errorStyle: const TextStyle(color: Color(0xFFE74C3C), fontSize: 10),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
        style: const TextStyle(color: Color(0xFFC7D5E0), fontSize: 12),
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
} 