import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import '../widgets/steam_text_field.dart';
import '../widgets/steam_snackbar.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_styles.dart';
import 'admin_view.dart';
import 'usuario_view.dart';

class LoginView extends StatefulWidget {
// Esto permite que la interfaz se actualice cuando los datos o variables internas cambian.
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
  bool _mostrarPassword = false;

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
    SteamSnackBar.showSuccess(context, mensaje);
  }

  void _mostrarError(String mensaje) {
    SteamSnackBar.showError(context, mensaje);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppStyles.backgroundGradient,
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
                      color: AppColors.primaryWithOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.primaryWithOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.games,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Título
                  Text(
                    'Catálogo E-Sports',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isRegistro ? 'Crear cuenta' : 'Iniciar sesión',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Formulario
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.dialogBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryWithOpacity(0.3),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SteamTextField(
                            controller: _usuarioController,
                            label: 'Usuario',
                            icon: Icons.person,
                            validator: (v) => v == null || v.isEmpty ? 'Ingrese usuario' : null,
                          ),
                          const SizedBox(height: 16),
                          SteamTextField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            icon: Icons.lock,
                            isPassword: true,
                            mostrarPassword: _mostrarPassword,
                            onTogglePassword: () {
                              setState(() {
                                _mostrarPassword = !_mostrarPassword;
                              });
                            },
                            validator: (v) => v == null || v.isEmpty ? 'Ingrese contraseña' : null,
                          ),
                          const SizedBox(height: 24),
                          
                          // Botón principal
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : (_isRegistro ? _registrar : _autenticar),
                              style: AppStyles.primaryButtonStyle.copyWith(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.secondary,
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
                            style: AppStyles.textButtonStyle,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}