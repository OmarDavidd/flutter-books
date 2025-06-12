import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';

class BookDetallesAdicionales extends StatelessWidget {
  final Libro book;
  const BookDetallesAdicionales({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: [
        _buildInfoBox("ISBN: ${book.isbn}"),
        _buildInfoBox("Año de publicación: ${book.anioPublicacion}"),
        _buildInfoBox("Editorial: ${book.editorial}"),
        _buildInfoBox("Estado: ${book.estado}"),
      ],
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFEEE4DA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9C8B8)),
      ),
      child: Center(child: Text(text)),
    );
  }
}
