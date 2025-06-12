import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:flutter_application_1/features/books/models/prestamo_dto.dart';
import 'package:flutter_application_1/features/books/views/add_libro_screen.dart';
import 'package:flutter_application_1/features/books/views/biblioteca.dart';
import 'package:flutter_application_1/features/books/views/book_detail_screen.dart';
import 'package:flutter_application_1/features/books/views/books_screen.dart';
import 'package:flutter_application_1/features/auth/views/login_page.dart';
import 'package:flutter_application_1/features/books/views/detalle_prestamo_screen.dart';
import 'package:flutter_application_1/features/books/views/historial_intercambios_screen.dart';
import 'package:flutter_application_1/features/books/views/main_screen.dart';
import 'package:flutter_application_1/features/auth/views/register_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String books = '/books';
  static const String addBook = '/add-book';
  static const String main = '/main';
  static const String library = '/library';
  static const String exchange = '/exchange';
  static const String bookDetails = '/book-details';
  static const String prestamoDetails = '/prestamo-details';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    books: (context) => const BooksScreen(),
    main: (context) => const MainScreen(),
    addBook: (context) => const AddBookScreen(),
    library: (context) => const BibliotecaScreen(),
    exchange:
        (context) =>
            const HistorialIntercambiosScreen(), // Usar la pantalla real o un Placeholder
    bookDetails: (context) {
      // Para pasar argumentos a una ruta, se recuperan de ModalRoute.of(context)!.settings.arguments
      final book = ModalRoute.of(context)!.settings.arguments as Libro;
      return BookDetailScreen(book: book);
    },
    prestamoDetails: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return DetallePrestamoScreen(
        prestamo: args['prestamo'] as PrestamoDTO,
        tipo: args['tipo'] as String,
      );
    },
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
