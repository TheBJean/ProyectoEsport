import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class AuthService {
  final CollectionReference _usuariosRef =
      FirebaseFirestore.instance.collection('usuarios');
  final CollectionReference _adminsRef =
      FirebaseFirestore.instance.collection('administradores');

  // Inicializar usuarios por defecto
  Future<void> inicializarUsuarios() async {
    try {
      // Verificar si ya existen usuarios
      final snapshot = await _usuariosRef.get();
      if (snapshot.docs.isEmpty) {
        // Crear usuario normal
        await _usuariosRef.add({
          'usuario': 'usuario',
          'password': 'password123',
          'rol': 'usuario',
        });
      }

      // Verificar si ya existen administradores
      final adminSnapshot = await _adminsRef.get();
      if (adminSnapshot.docs.isEmpty) {
        // Crear administrador por defecto
        await _adminsRef.add({
          'usuario': 'admin',
          'password': 'password123',
          'rol': 'admin',
        });
      }
    } catch (e) {
      print('Error inicializando usuarios: $e');
    }
  }

  // Autenticar usuario
  Future<Usuario?> autenticar(String usuario, String password) async {
    try {
      // Primero verificar si es administrador
      final adminQuery = await _adminsRef
          .where('usuario', isEqualTo: usuario)
          .where('password', isEqualTo: password)
          .get();

      if (adminQuery.docs.isNotEmpty) {
        final doc = adminQuery.docs.first;
        return Usuario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }

      // Si no es admin, verificar si es usuario normal
      final userQuery = await _usuariosRef
          .where('usuario', isEqualTo: usuario)
          .where('password', isEqualTo: password)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final doc = userQuery.docs.first;
        return Usuario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }

      return null;
    } catch (e) {
      print('Error en autenticación: $e');
      return null;
    }
  }

  // Registrar nuevo usuario
  Future<bool> registrar(String usuario, String password) async {
    try {
      // Verificar si el usuario ya existe en usuarios
      final userQuery = await _usuariosRef
          .where('usuario', isEqualTo: usuario)
          .get();

      if (userQuery.docs.isNotEmpty) {
        return false; // Usuario ya existe
      }

      // Verificar si el usuario ya existe en administradores
      final adminQuery = await _adminsRef
          .where('usuario', isEqualTo: usuario)
          .get();

      if (adminQuery.docs.isNotEmpty) {
        return false; // Usuario ya existe como admin
      }

      // Crear nuevo usuario
      await _usuariosRef.add({
        'usuario': usuario,
        'password': password,
        'rol': 'usuario', // Por defecto es usuario
      });

      return true;
    } catch (e) {
      print('Error en registro: $e');
      return false;
    }
  }

  // Verificar si un usuario es administrador consultando la base de datos
  Future<bool> esAdmin(String? userId) async {
    if (userId == null) return false;
    
    try {
      final adminDoc = await _adminsRef.doc(userId).get();
      return adminDoc.exists;
    } catch (e) {
      print('Error verificando si es admin: $e');
      return false;
    }
  }

  // Obtener información de usuario por ID
  Future<Usuario?> obtenerUsuarioPorId(String id) async {
    try {
      // Verificar en administradores
      final adminDoc = await _adminsRef.doc(id).get();
      if (adminDoc.exists) {
        return Usuario.fromMap(adminDoc.data() as Map<String, dynamic>, adminDoc.id);
      }

      // Verificar en usuarios
      final userDoc = await _usuariosRef.doc(id).get();
      if (userDoc.exists) {
        return Usuario.fromMap(userDoc.data() as Map<String, dynamic>, userDoc.id);
      }

      return null;
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }
} 