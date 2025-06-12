import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/helpers/genres.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';

class WidgetGeneros extends StatelessWidget {
  const WidgetGeneros({super.key, required this.book});

  final Libro book; // Declara el campo final

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          book.generosIds.map((genreId) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEEE4DA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD9C8B8)),
              ),
              child: Text(
                allGenres
                    .firstWhere((genre) => genre['id'] == genreId)['nombre']
                    .toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5E4B3B),
                  fontFamily: "Roboto",
                ),
              ),
            );
          }).toList(),
    );
  }
}
