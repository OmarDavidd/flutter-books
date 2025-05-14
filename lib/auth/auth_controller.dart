import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class AuthController {
  final AuthService authService = AuthService();

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      // Validación básica antes de llamar al servicio
      if (email.isEmpty || password.isEmpty) {
        throw 'Por favor ingresa tu correo y contraseña';
      }

      await authService.signInWithEmailPassword(email, password);

      // Mostrar feedback positivo al usuario
      _showSuccess(context, 'Inicio de sesión exitoso');
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  Future<void> register(
    BuildContext context,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      // Validaciones locales
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        throw 'Por favor completa todos los campos';
      }

      if (password != confirmPassword) {
        throw 'Las contraseñas no coinciden';
      }

      if (password.length < 6) {
        throw 'La contraseña debe tener al menos 6 caracteres';
      }

      final response = await authService.signUpWithEmailPassword(
        email,
        password,
      );

      // Manejar diferentes escenarios de registro
      if (response.user?.identities?.isEmpty ?? true) {
        throw 'Este correo ya está registrado';
      }

      // Feedback y navegación
      _showSuccess(context, 'Registro exitoso. Verifica tu correo');
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  String getJwtString() {
    return authService.getJwtString();
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await authService.signOut();
      _showSuccess(context, 'Sesión cerrada correctamente');
    } catch (e) {
      _showError(context, 'Error al cerrar sesión: ${e.toString()}');
    }
  }

  // Métodos auxiliares para mostrar feedback
  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccess(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
