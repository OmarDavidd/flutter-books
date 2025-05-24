import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/views/add_libro_screen.dart';
import 'package:flutter_application_1/features/books/views/books_screen.dart';
import 'package:flutter_application_1/features/books/views/login_page.dart';
import 'package:flutter_application_1/features/books/views/main_screen.dart';
import 'package:flutter_application_1/features/books/views/register_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String books = '/books';
  static const String addBook = '/add-book';
  static const String main = '/main';
  static const String library = '/library'; // Nueva ruta para Biblioteca
  static const String exchange = '/exchange'; // Nueva ruta para Intercambio
  static const String bookDetails =
      '/book-details'; // Nueva ruta para detalles del libro

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    books: (context) => const BooksScreen(),
    main: (context) => const MainScreen(),
    addBook: (context) => const AddBookScreen(), // Descomentado
    //library: (context) => const LibraryScreen(), // Usar la pantalla real o un Placeholder
    //exchange: (context) => const ExchangeScreen(), // Usar la pantalla real o un Placeholder
    /*bookDetails: (context) {
      // Para pasar argumentos a una ruta, se recuperan de ModalRoute.of(context)!.settings.arguments
      final book = ModalRoute.of(context)!.settings.arguments as Libro;
      return BookDetailsScreen(book: book);
    },*/
  };

  // Navegar limpiando todo el stack (para después de login)
  static void goToBooks(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, books, (route) => false);
  }

  // Navegar normal
  static void goTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  // Regresar
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
