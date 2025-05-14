import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/libro.dart';

class BookCard extends StatelessWidget {
  final Libro book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5DDD3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5E4B3B),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              /*
              image: DecorationImage(
                image: NetworkImage(
                  "https://png.pngtree.com/png-clipart/20190918/ourlarge/pngtree-load-the-3273350-png-image_1733730.jpg",
                ),
                fit: BoxFit.cover,
              ),*/
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.titulo,
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xFF5E4B3B),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.autor,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8C7A6B),
                      fontFamily: "Roboto",
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children:
                        book.generos.map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEE4DA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFD9C8B8),
                              ),
                            ),
                            child: Text(
                              genre.nombre.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF5E4B3B),
                                fontFamily: "Roboto",
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A373),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Ver detalles",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
