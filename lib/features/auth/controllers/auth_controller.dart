import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/core/utils/ui_helpers.dart';
import 'package:flutter_application_1/features/rutas.dart';

class AuthController {
  final AuthService authService = AuthService();

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw 'Por favor ingresa tu correo y contraseña';
      }
      await authService.signInWithEmailPassword(email, password);
      if (context.mounted) {
        showSuccess(context, 'Inicio de sesión exitoso');
        AppRoutes.goToBooks(context); // Navega a libros
      }
    } catch (e) {
      if (context.mounted) {
        showError(context, e.toString());
      }
    }
  }

  Future<void> register(
    BuildContext context,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
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
      if (response.user?.identities?.isEmpty ?? true) {
        throw 'Este correo ya está registrado';
      }
      if (context.mounted) {
        showSuccess(context, 'Registro exitoso');
        AppRoutes.goToBooks(context); // Navega a libros
      }
    } catch (e) {
      if (context.mounted) {
        showError(context, e.toString());
      }
    }
  }

  String getJwtString() {
    return authService.getJwtString();
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await authService.signOut();
      if (context.mounted) {
        showSuccess(context, 'Sesión cerrada correctamente');
      }
    } catch (e) {
      if (context.mounted) {
        showError(context, 'Error al cerrar sesión: ${e.toString()}');
      }
    }
  }
}
