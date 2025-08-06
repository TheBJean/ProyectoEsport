import 'package:flutter/material.dart';
import '../models/videojuego.dart';

class VideojuegoFormMobile extends StatefulWidget {
  final Videojuego? videojuego;
  final Function(Videojuego) onSave;
  final bool esAdmin;

  const VideojuegoFormMobile({
    Key? key,
    this.videojuego,
    required this.onSave,
    this.esAdmin = false,
  }) : super(key: key);

  @override
  State<VideojuegoFormMobile> createState() => _VideojuegoFormMobileState();
}

class _VideojuegoFormMobileState extends State<VideojuegoFormMobile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _valorController;
  late TextEditingController _valoracionController;
  late TextEditingController _imagenController;
  late TextEditingController _resenaController;
  late TextEditingController _autorController;
  double _valoracionSeleccionada = 0.0; // Default rating for reviews

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.videojuego?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.videojuego?.descripcion ?? '');
    _valorController = TextEditingController(
      text: widget.videojuego == null ? '' : widget.videojuego!.valor.toStringAsFixed(2)
    );
    _valoracionController = TextEditingController(
      text: widget.videojuego?.valoracion.toString() ?? '0.0'
    );
    _imagenController = TextEditingController(text: widget.videojuego?.imagenUrl ?? '');
    _resenaController = TextEditingController();
    _autorController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _valorController.dispose();
    _valoracionController.dispose();
    _imagenController.dispose();
    _resenaController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final videojuego = Videojuego(
        id: widget.videojuego?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        valor: double.parse(_valorController.text.replaceAll(',', '.')),
        valoracion: double.parse(_valoracionController.text),
        imagenUrl: _imagenController.text.isEmpty ? null : _imagenController.text,
        resenas: widget.videojuego?.resenas ?? [],
      );
      widget.onSave(videojuego);
      Navigator.of(context).pop();
    }
  }

  Future<void> _seleccionarValoracion() async {
    double valorActual = double.tryParse(_valoracionController.text) ?? 0.0;
    final valor = await showDialog<double>(
      context: context,
      builder: (context) {
        double tempValor = valorActual;
// ... existing imports ...
import 'package:flutter/material.dart';

class VideojuegoFormMobile extends StatefulWidget {
  final Videojuego? videojuego;
  final Function(Videojuego) onSave;
  final bool esAdmin;

  const VideojuegoFormMobile({
    Key? key,
    this.videojuego,
    required this.onSave,
    this.esAdmin = false,
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
                'Valoración',
                style: TextStyle(
                  color: Color(0xFF66C0F4),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2838).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
                    ),
                    child: Text(
                      '${tempValor.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC7D5E0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF66C0F4),
                      inactiveTrackColor: const Color(0xFF8F98A0),
                      thumbColor: const Color(0xFFFFD700),
                      overlayColor: const Color(0xFFFFD700).withOpacity(0.2),
                    ),
                    child: Slider(
                      value: tempValor,
                      min: 0.0,
                      max: 5.0,
                      divisions: 50,
                      onChanged: (value) {
                        setState(() {
                          tempValor = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < tempValor ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFFD700),
                        size: 24,
                      );
                    }),
                  ),
                ],
              );
            },
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
              onPressed: () => Navigator.of(context).pop(tempValor),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66C0F4),
                foregroundColor: const Color(0xFF1B2838),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (valor != null) {
      setState(() {
        _valoracionController.text = valor.toStringAsFixed(1);
      });
    }
  }

  void _agregarResena() {
    if (_resenaController.text.isNotEmpty) {
      final nuevaResena = {
        'texto': _resenaController.text,
        'autor': _autorController.text.isEmpty ? 'Anónimo' : _autorController.text,
        'fecha': DateTime.now().toIso8601String(),
        'rating': _valoracionSeleccionada, // Add user rating to the review
      };
      
      final videojuego = Videojuego(
        id: widget.videojuego?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        valor: double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0,
        valoracion: double.tryParse(_valoracionController.text) ?? 0.0,
        imagenUrl: _imagenController.text.isEmpty ? null : _imagenController.text,
        resenas: [...(widget.videojuego?.resenas ?? []), nuevaResena],
      );
      
      widget.onSave(videojuego);
      _resenaController.clear();
      _autorController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text('Reseña agregada'),
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
          const Icon(Icons.games, color: Color(0xFF66C0F4), size: 20),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              widget.videojuego == null ? 'Agregar Videojuego' : 'Editar Videojuego',
              style: const TextStyle(
                color: Color(0xFF66C0F4),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 300, // Ancho fijo para móvil
        height: MediaQuery.of(context).size.height * 0.8, // 80% de la altura
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSteamTextField(
                  controller: _nombreController,
                  label: 'Nombre',
                  icon: Icons.title,
                  validator: (v) => v == null || v.isEmpty ? 'Ingrese nombre' : null,
                ),
                const SizedBox(height: 12),
                _buildSteamTextField(
                  controller: _descripcionController,
                  label: 'Descripción',
                  icon: Icons.description,
                  maxLines: 4,
                  maxLength: 220,
                  helperText: 'Máximo 220 caracteres',
                  counterText: '${_descripcionController.text.length}/220',
                  counterStyle: TextStyle(
                    color: _descripcionController.text.length > 220 
                        ? const Color(0xFFE74C3C)
                        : const Color(0xFF8F98A0),
                    fontWeight: _descripcionController.text.length > 220  
                        ? FontWeight.bold 
                        : FontWeight.normal,
                  ),
                  errorText: _descripcionController.text.length > 220  
                      ? 'Has excedido el límite' 
                      : null,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingrese descripción';
                    if (v.length > 220) return 'La descripción no puede exceder 220 caracteres';
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                _buildSteamTextField(
                  controller: _valorController,
                  label: 'Valor',
                  icon: Icons.attach_money,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingrese valor';
                    final value = double.tryParse(v.replaceAll(',', '.'));
                    if (value == null) return 'Ingrese un número válido';
                    if (value < 0) return 'El valor no puede ser negativo';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                if (widget.esAdmin) ...[
                  // Para admin: mostrar valoración como campo de solo lectura con nota
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
                      color: const Color(0xFF1B2838).withOpacity(0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFF66C0F4), size: 18),
                              const SizedBox(width: 8),
                              const Text(
                                'Valoración Actual',
                                style: TextStyle(
                                  color: Color(0xFF8F98A0),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: _valoracionController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Valoración',
                              labelStyle: TextStyle(color: Color(0xFF8F98A0), fontSize: 12),
                              helperText: 'Esta valoración se actualiza automáticamente según las reseñas de los usuarios',
                              helperStyle: TextStyle(color: Color(0xFF8F98A0), fontSize: 10),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            style: const TextStyle(color: Color(0xFFC7D5E0), fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Para usuarios: permitir selección de valoración
                  _buildSteamTextField(
                    controller: _valoracionController,
                    label: 'Valoración',
                    icon: Icons.star,
                    readOnly: true,
                    onTap: _seleccionarValoracion,
                  ),
                ],
                const SizedBox(height: 12),
                // Campo de imagen con selector
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
                    color: const Color(0xFF1B2838).withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.image, color: Color(0xFF66C0F4), size: 18),
                            const SizedBox(width: 8),
                            const Text(
                              'Imagen del Videojuego',
                              style: TextStyle(
                                color: Color(0xFF8F98A0),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _imagenController,
                          decoration: const InputDecoration(
                            labelText: 'URL o ruta de imagen',
                            labelStyle: TextStyle(color: Color(0xFF8F98A0), fontSize: 12),
                            helperText: 'URL externa o ruta local (ej: assets/images/game.jpg)',
                            helperStyle: TextStyle(color: Color(0xFF8F98A0), fontSize: 10),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          style: const TextStyle(color: Color(0xFFC7D5E0), fontSize: 12),
                        ),
                      ),
                      if (widget.esAdmin) ...[
                        Row(
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Imágenes disponibles:',
                                  style: TextStyle(
                                    color: Color(0xFF66C0F4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (_imagenController.text.isNotEmpty)
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _imagenController.clear();
                                  });
                                },
                                icon: const Icon(Icons.clear, size: 14, color: Color(0xFFE74C3C)),
                                label: const Text(
                                  'Limpiar',
                                  style: TextStyle(fontSize: 10, color: Color(0xFFE74C3C)),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 80, // Más compacto para móvil
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _buildImageSelector(),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
                // Solo mostrar sección de reseñas si NO es admin y hay un videojuego existente
                if (!widget.esAdmin && widget.videojuego != null) ...[
                  const SizedBox(height: 16),
                  // Sección de reseñas
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2838).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.comment, color: Color(0xFF66C0F4), size: 16),
                            const SizedBox(width: 6),
                            const Text(
                              'Reseñas',
                              style: TextStyle(
                                color: Color(0xFF66C0F4),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '(${widget.videojuego?.resenas?.length ?? 0})',
                              style: const TextStyle(
                                color: Color(0xFF8F98A0),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildSteamTextField(
                          controller: _resenaController,
                          label: 'Nueva reseña',
                          icon: Icons.edit,
                          maxLines: 2,
                          helperText: 'Tu opinión sobre el videojuego',
                        ),
                        const SizedBox(height: 6),
                        _buildSteamTextField(
                          controller: _autorController,
                          label: 'Tu nombre (opcional)',
                          icon: Icons.person,
                          helperText: 'Si no lo escribes, aparecerá como "Anónimo"',
                        ),
                        const SizedBox(height: 12),
                        // Rating section for reviews
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2838).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Tu valoración:',
                                    style: TextStyle(
                                      color: Color(0xFF8F98A0),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${_valoracionSeleccionada.toStringAsFixed(1)} / 5.0',
                                    style: const TextStyle(
                                      color: Color(0xFFC7D5E0),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                                    fontSize: 10,
                                  ),
                                ),
                                child: Slider(
                                  value: _valoracionSeleccionada,
                                  min: 0.0,
                                  max: 5.0,
                                  divisions: 50, // 0.1 increments
                                  label: _valoracionSeleccionada.toStringAsFixed(1),
                                  onChanged: (value) {
                                    setState(() {
                                      _valoracionSeleccionada = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _agregarResena,
                            icon: const Icon(Icons.add_comment, size: 14),
                            label: const Text('Agregar Reseña'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9B59B6),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
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
          onPressed: _guardar,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF66C0F4),
            foregroundColor: const Color(0xFF1B2838),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Guardar'),
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

  Widget _buildImageSelector() {
    // Lista de imágenes disponibles en assets/images/
    final List<String> imagenesDisponibles = [
    'lib/assets/images/csgo.jpg'
    'lib/assets/images/lol.jpg',
    'lib/assets/images/dota2.jpg',
    'lib/assets/images/valorant.jpg',
    'lib/assets/images/overwatch.jpg',
    'lib/assets/images/fortnite.jpg',
    'lib/assets/images/pubg.jpg',
    'lib/assets/images/apex.jpg',
    'lib/assets/images/rocket_league.jpg',
    'lib/assets/images/fifa.jpg',
    'lib/assets/images/minecraft.jpg',
    'lib/assets/images/among_us.jpg',
    'lib/assets/images/fall_guys.jpg',
    'lib/assets/images/roblox.jpg',
    'lib/assets/images/gta.jpg',
    'lib/assets/images/cod.jpg',
    'lib/assets/images/rainbow_six.jpg',
  ];

    return SizedBox(
      height: 100, // Altura fija para móvil - un poco más grande
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagenesDisponibles.length,
        itemBuilder: (context, index) {
          final imagenPath = imagenesDisponibles[index];
          final isSelected = _imagenController.text == imagenPath;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _imagenController.text = imagenPath;
              });
            },
            child: Container(
              width: 60, // Más pequeño para móvil
              height: 80, // Un poco más grande en vertical
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected 
                      ? const Color(0xFF66C0F4) 
                      : const Color(0xFF66C0F4).withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                color: const Color(0xFF1B2838),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    // Imagen real o placeholder
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(
                        imagenPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Si la imagen no existe, mostrar placeholder
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color(0xFF2A475E),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.games,
                                  color: Color(0xFF66C0F4),
                                  size: 16,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'Game ${index + 1}',
                                  style: const TextStyle(
                                    color: Color(0xFF66C0F4),
                                    fontSize: 6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Overlay para mostrar selección
                    if (isSelected)
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF66C0F4).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 