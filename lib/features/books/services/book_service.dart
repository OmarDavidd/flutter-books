import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/features/auth/controllers/auth_controller.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:http/http.dart' as http;

class BookService {
  final String baseUrl = 'https://books-production-564c.up.railway.app';

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
    required int usuarioId,
    required List<int> generosIdsEntrada,
    required List<String> urlsImagenesEntrada,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/libros/add?usuarioId=2',
    ); // Or your actual IP if not running on emulator/device
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "titulo": titulo,
      "autor": autor,
      "editorial": editorial,
      "anioPublicacion": anioPublicacion,
      "isbn": isbn,
      "estadoFisico": estadoFisico,
      "disponibleIntercambio": disponibleIntercambio,
      "generosIdsEntrada":
          generosIdsEntrada, // Ahora es una lista de int directamente
      "urlsImagenesEntrada": urlsImagenesEntrada,
    });

    try {
      await http.post(url, headers: headers, body: body);
    } catch (e) {
      print("Error en la petición: $e");
    }
  }
}
