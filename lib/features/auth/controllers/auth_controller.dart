import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/auth/services/user_service.dart';
import 'package:flutter_application_1/core/utils/ui_helpers.dart';
import 'package:flutter_application_1/features/rutas.dart';

class AuthController {
  final AuthService authService = AuthService();
  final UserService userService = UserService();

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
        AppRoutes.goTo(context, AppRoutes.main);
      }
    } catch (e) {
      if (context.mounted) {
        showError(context, e.toString());
      }
    }
  }

  Future<void> register(
    BuildContext context,
    String nombre,
    String apellido,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      // Validaciones existentes
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        throw 'Por favor completa todos los campos';
      }
      if (password != confirmPassword) {
        throw 'Las contraseñas no coinciden';
      }
      if (password.length < 6) {
        throw 'La contraseña debe tener al menos 6 caracteres';
      }

      // 1. Registro en el sistema de autenticación (existente)
      final response = await authService.signUpWithEmailPassword(
        email,
        password,
      );

      if (response.user?.identities?.isEmpty ?? true) {
        throw 'Este correo ya está registrado';
      }

      // 2. Creación del usuario en tu base de datos (nuevo)
      final userCreated = await userService.createUser(
        nombre: nombre,
        apellido: apellido,
        email: email,
      );

      if (!userCreated) {
        throw 'Error al crear el perfil de usuario';
      }

      // Feedback y navegación (existente)
      if (context.mounted) {
        showSuccess(context, 'Registro exitoso');
        AppRoutes.goTo(context, AppRoutes.main);
      }
    } catch (e) {
      // Manejo de errores (existente)
      if (context.mounted) {
        showError(context, e.toString());
      }

      // Opcional: Revertir el registro en Auth si falla la creación en DB
      try {
        await authService.signOut();
      } catch (_) {}
    }
  }

  // Métodos existentes sin cambios
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
