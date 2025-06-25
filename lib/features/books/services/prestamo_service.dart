import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/auth/services/user_service.dart';
import 'package:flutter_application_1/features/books/models/prestamo_dto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
      rethrow;
    }
  }
  /*
  Future<void> cambiarfecha(int id, String date) async {
    try {
      // 1. Parsear y formatear la fecha eliminando milisegundos
      final dateTime = DateTime.parse(date);
      final formattedDate = dateTime.toIso8601String().split('.')[0];

      // 2. URL original sin cambios
      final url = Uri.parse('$baseUrl/api/prestamos/fecha/$id');

      // 3. Headers mínimos necesarios
      final headers = {"Content-Type": "application/json"};

      // 4. Enviar solo el string de fecha sin comillas adicionales
      final body = formattedDate; // No usar jsonEncode aquí

      debugPrint("Enviando fecha: $body");

      // 5. Realizar la solicitud PUT
      final response = await http.put(
        url,
        headers: headers,
        body: body, // Enviar directamente el string
      );

      debugPrint(
        "Respuesta del servidor: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Fecha actualizada correctamente");
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on FormatException {
      throw Exception("Formato de fecha inválido. Use YYYY-MM-DDTHH:MM:SS");
    } catch (e) {
      debugPrint("Error en cambiar fecha: $e");
      rethrow;
    }
  }*/
  /*
  Future<void> cambiarfecha(int id, String date) async {
    try {
      final url = Uri.parse('$baseUrl/api/prestamos/fecha/$id');
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode(date);
      debugPrint("Body: $body");

      final response = await http.put(url, headers: headers, body: body);
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Solicitud cambiar");
      } else {
        throw Exception('Error al cambiar solicitud: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error en cambiar solicitud: $e");
      rethrow; // Relanza el error para manejo superior
    }
  }*/
  /*
  Future<void> cambiarfecha(int id, String date) async {
    try {
      final url = Uri.parse('$baseUrl/api/prestamos/fecha/$id');
      final headers = {"Content-Type": "application/json"};

      // Convertir el string ISO8601 a DateTime
      final dateTime = DateTime.parse(date);

      // Formatear sin milisegundos
      final formattedDate = DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss",
      ).format(dateTime);
      final body = jsonEncode(formattedDate);

      debugPrint("Enviando fecha al backend: $formattedDate");

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Fecha cambiada exitosamente: ${response.body}");
      } else {
        throw Exception('Error al cambiar fecha: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error en cambiar fecha: $e");
      rethrow;
    }
  }*/

  Future<void> cambiarfecha(int id, String fechaString) async {
    print('=== DEBUGGING FECHA ===');
    print('String recibido: $fechaString');

    try {
      // Convertir el string a DateTime
      DateTime fechaSeleccionada = DateTime.parse(fechaString);
      print('DateTime parseado: $fechaSeleccionada');

      // Diferentes formatos para probar
      String formato1 =
          fechaSeleccionada.toIso8601String().split('.')[0]; // Sin milisegundos
      String formato2 = fechaSeleccionada.toIso8601String(); // Con milisegundos
      String formato3 = fechaSeleccionada.toUtc().toIso8601String(); // UTC
      String formato4 = fechaString; // El string original sin modificar

      print('Formato 1 (sin milisegundos): $formato1');
      print('Formato 2 (con milisegundos): $formato2');
      print('Formato 3 (UTC): $formato3');
      print('Formato 4 (original): $formato4');

      // Prueba con formato1 primero
      String fechaParaEnviar = formato1;
      print('Enviando: $fechaParaEnviar');

      final response = await http.put(
        Uri.parse('$baseUrl/api/prestamos/fecha/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fechaParaEnviar),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Fecha actualizada correctamente');
      } else {
        print('❌ Error en la respuesta');
      }
    } catch (e) {
      print('Error al parsear fecha o en la petición: $e');
    }
  }
}
