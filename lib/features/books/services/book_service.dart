import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/features/auth/controllers/auth_controller.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/auth/services/user_service.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:http/http.dart' as http;

class BookService {
  final String baseUrl = 'http://52.90.173.247:8080';
  //final String baseUrl = 'https://books-production-564c.up.railway.app';

  final authController = AuthController();
  late String token = authController.getJwtString();

  Future<List<Libro>> getBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/libros/get'),
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> librosJson = jsonDecode(response.body);
        return librosJson.map((json) => Libro.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar libros: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Response: fallo aquiasdfhjvuf');
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> createLibro({
    required String titulo,
    required String autor,
    required String editorial,
    required int anioPublicacion,
    required String isbn,
    required String estadoFisico,
    required bool disponibleIntercambio,
    required List<int> generosIdsEntrada,
    required List<String> urlsImagenesEntrada,
  }) async {
    try {
      final AuthService authService = AuthService();
      final UserService userService = UserService();
      final email = await authService.getCurrentUserEmail(); // Añadí await
      if (email == null) throw Exception('Usuario no autenticado');

      final userIdStr = await userService.getUserId(email: email);
      debugPrint("ID de usuario obtenido: $userIdStr"); // Para depuración

      final idUser = int.tryParse(userIdStr) ?? 0; // Conversión segura
      if (idUser == 0) throw Exception('ID de usuario inválido');

      final url = Uri.parse('$baseUrl/api/libros/add?usuarioId=$idUser');
      final headers = {"Content-Type": "application/json"};

      final body = jsonEncode({
        "titulo": titulo,
        "autor": autor,
        "editorial": editorial,
        "anioPublicacion": anioPublicacion,
        "isbn": isbn,
        "estadoFisico": estadoFisico,
        "disponibleIntercambio": disponibleIntercambio,
        "generosIdsEntrada": generosIdsEntrada,
        "urlsImagenesEntrada": urlsImagenesEntrada,
      });

      debugPrint("Enviando a $url con body: $body"); // Para depuración

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Libro creado exitosamente");
      } else {
        debugPrint(
          "Error al crear libro: ${response.statusCode} - ${response.body}",
        );
        throw Exception('Error al crear libro: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error en createLibro: $e");
      rethrow; // Relanza el error para manejo superior
    }
  }
  /*
  Future<void> updateLibro({
    required int id,
    required String titulo,
    required String autor,
    required String editorial,
    required int anioPublicacion,
    required String isbn,
    required String estadoFisico,
    required bool disponibleIntercambio,
    required List<int> generosIdsEntrada,
    required List<String> urlsImagenesEntrada,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/libros/update/$id');
      final headers = {"Content-Type": "application/json"};

      final body = jsonEncode({
        "titulo": titulo,
        "autor": autor,
        "editorial": editorial,
        "anioPublicacion": anioPublicacion,
        "isbn": isbn,
        "estadoFisico": estadoFisico,
        "disponibleIntercambio": disponibleIntercambio,
        "generosIdsEntrada": generosIdsEntrada,
        "urlsImagenesEntrada": urlsImagenesEntrada,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Libro actualizado exitosamente");
      } else {
        throw Exception('Error al actualizar libro: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error en updateLibro: $e");
      rethrow; // Relanza el error para manejo superior
    }
  }*/

  Future<void> deleteLibro(int id) async {
    try {
      final url = Uri.parse('$baseUrl/api/libros/$id');
      final headers = {"Content-Type": "application/json"};

      final response = await http.delete(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Libro eliminado exitosamente");
      } else {
        throw Exception('Error al eliminar libro: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error en deleteLibro: $e");
      rethrow; // Relanza el error para manejo superior
    }
  }

  Future<Libro> getBookById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/libros/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Libro.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al cargar libro: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}
