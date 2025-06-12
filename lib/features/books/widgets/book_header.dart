import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:flutter_application_1/features/books/widgets/widget_generos.dart';

class BookHeader extends StatelessWidget {
  const BookHeader({super.key, required this.book});

  final Libro book;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          width: 200,
          child:
              book.urlsImagenes.isNotEmpty
                  ? FadeInImage(
                    placeholder: AssetImage("assets/images/placeholder.png"),
                    image: NetworkImage(book.urlsImagenes.first),
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 300),
                    imageErrorBuilder: (context, error, stackTrace) {
                      // Nota: usa imageErrorBuilder
                      return Image.asset(
                        "assets/images/placeholder.png",
                        fit: BoxFit.cover,
                      );
                    },
                  )
                  : Image.asset(
                    "assets/images/placeholder.png",
                    fit: BoxFit.cover,
                  ),
        ),
        Text(
          book.titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5E4B3B),
            fontSize: 20,
          ),
        ),
        Text(book.autor, style: TextStyle(color: const Color(0xFF5E4B3B))),
        SizedBox(height: 10),
        WidgetGeneros(book: book),
      ],
    );
  }
}
