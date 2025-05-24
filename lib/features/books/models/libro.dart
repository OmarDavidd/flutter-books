import 'package:flutter_application_1/features/books/models/genero.dart';

class Libro {
  final int id;
  final String titulo;
  final String autor;
  final int anioPublicacion;
  final String isbn;
  final String editorial;
  final String? fechaCreacion; // Made nullable
  final String estado; // Added
  final List<int> generosIds; // Changed to list of int
  final String idUsuario; // Added
  final String nombreUsuario; // Added
  final List<String> urlsImagenes; // Added

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.anioPublicacion,
    required this.isbn,
    required this.editorial,
    this.fechaCreacion, // No longer required due to nullability
    required this.estado,
    required this.generosIds,
    required this.idUsuario,
    required this.nombreUsuario,
    required this.urlsImagenes,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      anioPublicacion: json['anioPublicacion'],
      isbn: json['isbn'],
      editorial: json['editorial'],
      fechaCreacion: json['fechaCreacion'], // Will correctly handle null
      estado: json['estado'],
      generosIds: List<int>.from(json['generosIds']), // Cast to List<int>
      idUsuario: json['idUsuario'],
      nombreUsuario: json['nombreUsuario'],
      urlsImagenes: List<String>.from(
        json['urlsImagenes'],
      ), // Cast to List<String>
    );
  }
}
