import 'package:flutter_application_1/models/genero.dart';

class Libro {
  final int id;
  final String titulo;
  final String autor;
  final int anioPublicacion;
  final String isbn;
  final String editorial;
  final String fechaCreacion;
  final List<Genero> generos;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.anioPublicacion,
    required this.isbn,
    required this.editorial,
    required this.fechaCreacion,
    required this.generos,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    List<Genero> generosLista = [];
    if (json['generos'] != null) {
      generosLista =
          (json['generos'] as List)
              .map((generoJson) => Genero.fromJson(generoJson))
              .toList();
    }

    return Libro(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      anioPublicacion: json['anioPublicacion'],
      isbn: json['isbn'],
      editorial: json['editorial'],
      fechaCreacion: json['fechaCreacion'],
      generos: generosLista,
    );
  }
}
