import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/auth/services/user_service.dart';
import 'package:flutter_application_1/features/books/models/prestamo_dto.dart';
import 'package:http/http.dart' as http;

class PrestamoService {
  final String baseUrl = 'http://52.90.173.247:8080';

  //  final String baseUrl = 'https://books-production-564c.up.railway.app';
  //final String baseUrl = 'http://10.0.2.2:8080';
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  Future<bool> createPrestamo({
    required int idSolicitante,
    required int idPropietario,
    required int idLibro,
    required int duracion,
    String? mensaje,
  }) async {
    final url = Uri.parse('$baseUrl/api/prestamos');
    final headers = {"Content-Type": "application/json"};

    debugPrint("AQui andamos");
    final body = jsonEncode({
      "solicitante": {"id": idSolicitante},
      "propietario": {"id": idPropietario},
      "libro": {"id": idLibro},
      "duracion": duracion,
      "estado": {"id": 1},
      "mensaje": mensaje,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response sdafhjkb $response");

      return response.statusCode == 201; // 201 Created
    } catch (e) {
      debugPrint("Error en la petición: $e");
      return false;
    }
  }

  //TODO: intercambios
  Future<List<PrestamoDTO>> getPrestamosByUserId() async {
    try {
      final url = Uri.parse('$baseUrl/api/prestamos');
      // final url = Uri.parse('http://10.0.2.2:8080/api/prestamos');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint("Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData is List) {
          return responseData
              .map((json) => PrestamoDTO.fromJson(json))
              .toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<PrestamoDTO>> getSolicitudesEnviadas() async {
    final allPrestamos = await getPrestamosByUserId();
    final email = _authService.getCurrentUserEmail() ?? '';
    final name = await _userService.getUserName(email: email);

    return allPrestamos
        .where((prestamo) => prestamo.nombreSolicitante == name)
        .toList();
  }

  Future<List<PrestamoDTO>> getSolicitudesRecibidas() async {
    final allPrestamos = await getPrestamosByUserId();
    final email = _authService.getCurrentUserEmail() ?? '';
    final name = await _userService.getUserName(email: email);
    "recibidas ${allPrestamos.where((prestamo) => prestamo.nombrePropietario == name).toList()}";

    return allPrestamos
        .where((prestamo) => prestamo.nombrePropietario == name)
        .toList();
  }

  Future<void> deleteSolicitud(int id) async {
    try {
      final url = Uri.parse('$baseUrl/api/prestamos/$id');
      final headers = {"Content-Type": "application/json"};

      final response = await http.delete(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Solicitud cancelada");
      } else {
        throw Exception('Error al cancelar solicitud: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error en cancelar solicitud: $e");
      rethrow; // Relanza el error para manejo superior
    }
  }

  Future<void> cambiarEstado(int id, int estado) async {
    try {
      final url = Uri.parse('$baseUrl/api/prestamos/estado/$id');
      final headers = {"Content-Type": "application/json"};
      final body = estado.toString();

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Solicitud cambiar");
      } else {
        throw Exception('Error al cambiar solicitud: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error en cambiar solicitud: $e");
      rethrow; // Relanza el error para manejo superior
    }
  }

  Future<void> cambiarfecha(int id, String date) async {
    try {
      final url = Uri.parse('$baseUrl/api/prestamos/fecha/$id');
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode(date);

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Solicitud cambiar");
      } else {
        throw Exception('Error al cambiar solicitud: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error en cambiar solicitud: $e");
      rethrow; // Relanza el error para manejo superior
    }
  }
}
