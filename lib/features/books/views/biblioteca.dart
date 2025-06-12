import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/controllers/auth_controller.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/auth/services/user_service.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:flutter_application_1/features/auth/views/login_page.dart';
import 'package:flutter_application_1/features/books/services/book_service.dart';
import 'package:flutter_application_1/features/books/widgets/card_book.dart';

class BibliotecaScreen extends StatefulWidget {
  const BibliotecaScreen({super.key});

  @override
  State<BibliotecaScreen> createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  late Future<List<Libro>> futureLibros;
  final BookService bookService = BookService();
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  String currentUserId = '0';

  void logout() async {
    final authController = AuthController();
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
    futureLibros = _initializeUser().then((userId) {
      return bookService.getBooks().then((books) {
        return books.where((libro) => libro.idUsuario == userId).toList();
      });
    });
  }

  Future<String> _initializeUser() async {
    final email = authService.getCurrentUserEmail() ?? '';
    debugPrint("Email del usuario: $email");
    if (email.isEmpty) throw Exception('No user email found');
    final userId = await userService.getUserId(email: email);
    debugPrint("User ID obtenido: $userId");
    setState(() => currentUserId = userId);
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text(
          'Mis Libros',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
          ),
        ),
        backgroundColor: const Color(0xFF5E4B3B),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Libro>>(
          future: futureLibros,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tienes libros registrados'));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final libro = snapshot.data![index];
                debugPrint("libro $libro");

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BookCard(book: libro),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
