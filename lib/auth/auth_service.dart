import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in con manejo de errores
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw _parseAuthError(e.message);
    } on Exception catch (e) {
      throw 'Ocurrió un error inesperado: ${e.toString()}';
    }
  }

  // Sign up con manejo de errores
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      return await _supabase.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw _parseAuthError(e.message);
    } on Exception catch (e) {
      throw 'Ocurrió un error inesperado: ${e.toString()}';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on Exception catch (e) {
      throw 'Error al cerrar sesión: ${e.toString()}';
    }
  }

  // Get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  String getJwtString() {
    final String jwt =
        Supabase.instance.client.auth.currentSession?.accessToken ?? '';
    return jwt;
  }

  // Función para parsear errores de Supabase a mensajes amigables
  String _parseAuthError(String errorMessage) {
    if (errorMessage.contains('Invalid login credentials')) {
      return 'Correo electrónico o contraseña incorrectos';
    } else if (errorMessage.contains('Email rate limit exceeded')) {
      return 'Demasiados intentos. Por favor espera un momento';
    } else if (errorMessage.contains('Email not confirmed')) {
      return 'Por favor verifica tu correo electrónico antes de iniciar sesión';
    } else if (errorMessage.contains('User already registered')) {
      return 'Este correo electrónico ya está registrado';
    } else if (errorMessage.contains('Password should be at least')) {
      return 'La contraseña debe tener al menos 6 caracteres';
    } else if (errorMessage.contains('Invalid email')) {
      return 'Por favor ingresa un correo electrónico válido';
    } else if (errorMessage.contains('Unable to validate email address')) {
      return 'Correo electrónico no válido';
    } else if (errorMessage.contains('For security purposes')) {
      return 'Debes ingresar una nueva contraseña';
    }

    // Mensaje genérico para errores no manejados específicamente
    return 'Error de autenticación: $errorMessage';
  }
}
