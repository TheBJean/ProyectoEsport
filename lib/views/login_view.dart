import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import 'admin_view.dart';
import 'usuario_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isRegistro = false;

  @override
  void initState() {
    super.initState();
    _inicializarUsuarios();
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _inicializarUsuarios() async {
    await _authService.inicializarUsuarios();
  }

  Future<void> _autenticar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final usuario = await _authService.autenticar(
          _usuarioController.text,
          _passwordController.text,
        );

        if (usuario != null) {
          _navegarSegunRol(usuario);
        } else {
          _mostrarError('Usuario o contraseña incorrectos');
        }
      } catch (e) {
        _mostrarError('Error en la autenticación: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final exito = await _authService.registrar(
          _usuarioController.text,
          _passwordController.text,
        );

        if (exito) {
          _mostrarMensaje('Usuario registrado exitosamente');
          setState(() {
            _isRegistro = false;
          });
        } else {
          _mostrarError('El usuario ya existe');
        }
      } catch (e) {
        _mostrarError('Error en el registro: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navegarSegunRol(Usuario usuario) {
    if (usuario.rol == 'admin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AdminView(usuario: usuario),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UsuarioView(usuario: usuario),
        ),
      );
    }
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B2838), Color(0xFF2A475E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icono
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF66C0F4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: const Color(0xFF66C0F4).withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.games,
                      size: 60,
                      color: Color(0xFF66C0F4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Título
                  Text(
                    'Catálogo E-Sports',
                    style: const TextStyle(
                      color: Color(0xFF66C0F4),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isRegistro ? 'Crear cuenta' : 'Iniciar sesión',
                    style: const TextStyle(
                      color: Color(0xFF8F98A0),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Formulario
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2251),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF66C0F4).withOpacity(0.3),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildSteamTextField(
                            controller: _usuarioController,
                            label: 'Usuario',
                            icon: Icons.person,
                            validator: (v) => v == null || v.isEmpty ? 'Ingrese usuario' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildSteamTextField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            icon: Icons.lock,
                            isPassword: true,
                            validator: (v) => v == null || v.isEmpty ? 'Ingrese contraseña' : null,
                          ),
                          const SizedBox(height: 24),
                          
                          // Botón principal
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : (_isRegistro ? _registrar : _autenticar),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF66C0F4),
                                foregroundColor: const Color(0xFF1B2838),
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF1B2838),
                                      ),
                                    )
                                  : Text(
                                      _isRegistro ? 'Registrarse' : 'Iniciar Sesión',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Botón alternativo
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isRegistro = !_isRegistro;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF8F98A0),
                            ),
                            child: Text(
                              _isRegistro
                                  ? '¿Ya tienes cuenta? Inicia sesión'
                                  : '¿No tienes cuenta? Regístrate',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Información de usuarios por defecto
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2838).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF66C0F4).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Usuarios por defecto:',
                          style: TextStyle(
                            color: Color(0xFF66C0F4),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Admin: usuario=admin, password=password123',
                          style: TextStyle(
                            color: Color(0xFF8F98A0),
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          'Usuario: usuario=usuario, password=password123',
                          style: TextStyle(
                            color: Color(0xFF8F98A0),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSteamTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF66C0F4).withOpacity(0.3)),
        color: const Color(0xFF1B2838).withOpacity(0.5),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF8F98A0)),
          prefixIcon: Icon(icon, color: const Color(0xFF66C0F4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
        style: const TextStyle(color: Color(0xFFC7D5E0)),
        validator: validator,
      ),
    );
  }
} 