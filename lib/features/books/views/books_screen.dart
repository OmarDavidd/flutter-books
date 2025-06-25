import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/controllers/auth_controller.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/auth/services/user_service.dart';
import 'package:flutter_application_1/features/books/helpers/genres.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:flutter_application_1/features/auth/views/login_page.dart';
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
  List<Libro> allLibros = [];
  final authController = AuthController();
  final AuthService authService = AuthService();
  final UserService _userService = UserService();
  String currentUserId = '0';

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
    _initializeUser(); // Agregar esta llamada
    futureLibros = bookService.getBooks().then((books) {
      allLibros = books;
      return books;
    });
  }

  // Agregar este método
  void _initializeUser() async {
    final email = authService.getCurrentUserEmail() ?? 'default@email.com';
    final userId = await _userService.getUserId(email: email);
    if (mounted) {
      setState(() {
        currentUserId = userId;
      });
    }
  }

  List<Libro> get filteredLibros {
    if (searchQuery.isEmpty) {
      return allLibros
          .where((libro) => libro.idUsuario != currentUserId)
          .toList();
    }

    final query = searchQuery.toLowerCase();
    return allLibros.where((libro) {
      // Excluir libros del usuario con ID 6
      if (libro.idUsuario == currentUserId) return false;

      final matchesTitle = libro.titulo.toLowerCase().contains(query);
      final matchesAuthor = libro.autor.toLowerCase().contains(query);
      final matchesGenre = libro.generosIds.any((generoId) {
        final genero = allGenres.firstWhere(
          (g) => g['id'] == generoId,
          orElse: () => {'nombre': ''},
        );
        return genero['nombre'].toLowerCase().contains(query);
      });

      return matchesTitle || matchesAuthor || matchesGenre;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Explorar Libros',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5E4B3B),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Buscar por título, autor o género",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFEEE4DA),
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay libros disponibles'),
                    );
                  }

                  return filteredLibros.isEmpty
                      ? const Center(
                        child: Text('No se encontraron resultados'),
                      )
                      : ListView.builder(
                        itemCount: filteredLibros.length,
                        itemBuilder: (context, index) {
                          final libro = filteredLibros[index];
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
