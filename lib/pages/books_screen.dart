import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_controller.dart';
import 'package:flutter_application_1/models/libro.dart';
import 'package:flutter_application_1/services/book_service.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late Future<List<Libro>> futureLibros;
  final BookService bookService = BookService();

  final authController = AuthController();

  void logout() async {
    await authController.signOut(context);
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
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder<List<Libro>>(
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
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 2.0,
                child: ListTile(
                  title: Text(
                    libro.titulo,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(libro.autor),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
