import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class AuthController {
  final authService = AuthService();

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await authService.singInWithEmailPassword(email, password);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> register(
    BuildContext context,
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no son iguales')),
      );
      return;
    }

    try {
      await authService.singUpWithEmailPassword(email, password);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
