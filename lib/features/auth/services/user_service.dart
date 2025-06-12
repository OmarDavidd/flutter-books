import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://52.90.173.247:8080';

  Future<bool> createUser({
    required String nombre,
    required String apellido,
    required String email,
    double valoracion = 0.0,
  }) async {
    final url = Uri.parse('$baseUrl/api/usuarios');
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "nombre": nombre,
      "apellido": apellido,
      "email": email,
      "valoracion": valoracion,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<String> getUserId({required String email}) async {
    final url = Uri.parse('$baseUrl/api/usuarios/email/$email');
    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.get(url, headers: headers);
      debugPrint("Respuesta completa: ${response.body}");
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Extrae el ID
      final int userId = jsonResponse['id'];
      debugPrint("mi id es: ");
      debugPrint(userId.toString());
      return userId.toString();
    } catch (e) {
      return "";
    }
  }

  Future<String> getUserName({required String email}) async {
    final url = Uri.parse('$baseUrl/api/usuarios/email/$email');
    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.get(url, headers: headers);
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Extrae el ID
      final String name = jsonResponse['nombreCompleto'];

      debugPrint("mi nombre es: $name.toString()");
      return name.toString();
    } catch (e) {
      return "";
    }
  }
}
