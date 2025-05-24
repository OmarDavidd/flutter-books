import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/controllers/auth_controller.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:flutter_application_1/features/books/views/login_page.dart';
import 'package:flutter_application_1/features/books/services/book_service.dart';
import 'package:flutter_application_1/features/books/widgets/card_book.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late Future<List<Libro>> futureLibros;
  final BookService bookService = BookService();
  String searchQuery = '';

  //edit
  List<Libro> allLibros = [];
  List<Libro> filteredLibros = [];
  bool isLoading = true;

  final authController = AuthController();

  void logout() async {
    await authController.signOut(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    futureLibros = bookService.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explorar Libros',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5E4B3B),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Buscar por titulo o autor",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Color(0xFFEEE4DA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 9),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Libro>>(
                future: futureLibros,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay libros disponibles'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Libro libro = snapshot.data![index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: BookCard(book: libro),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
