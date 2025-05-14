import 'dart:convert';
import 'package:flutter_application_1/auth/auth_controller.dart';
import 'package:flutter_application_1/models/libro.dart';
import 'package:http/http.dart' as http;

class BookService {
  final String baseUrl = 'https://backend-books-exchange.onrender.com';

  final authController = AuthController();
  late String token = authController.getJwtString();

  Future<List<Libro>> getBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/libros'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> librosJson = jsonDecode(response.body);
        return librosJson.map((json) => Libro.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar libros: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
