import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';

class DetailUser extends StatelessWidget {
  const DetailUser({super.key, required this.book});

  final Libro book;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: const Color(0xFFEEE4DA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD9C8B8)),
          ),
          child: Row(children: [Expanded(child: Text(book.nombreUsuario))]),
        ),
      ],
    );
  }
}
