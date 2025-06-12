import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/auth/services/user_service.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:flutter_application_1/features/books/services/book_service.dart';
import 'package:flutter_application_1/features/books/services/prestamo_service.dart';
import 'package:flutter_application_1/features/books/widgets/book_detalles_adicionales.dart';
import 'package:flutter_application_1/features/books/widgets/book_header.dart';
import 'package:flutter_application_1/features/books/widgets/custom_icon_button.dart';
import 'package:flutter_application_1/features/books/widgets/detail_user.dart';
import 'package:flutter_application_1/features/books/widgets/solicitud_dialog.dart';
import 'package:flutter_application_1/features/rutas.dart';

class BookDetailScreen extends StatefulWidget {
  final Libro book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final PrestamoService _prestamoService = PrestamoService();
  final AuthService authService = AuthService();
  final UserService _userService = UserService();
  final BookService _bookService = BookService();
  late bool esMiLibro;
  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _checkIfMyBook();
  }

  Future<void> _checkIfMyBook() async {
    final email = authService.getCurrentUserEmail() ?? 'default@email.com';
    final userId = await _userService.getUserId(email: email);
    if (mounted) {
      setState(() {
        esMiLibro = widget.book.idUsuario == userId;
      });
    }
  }

  void _solicitarLibro(BuildContext context) async {
    final result = await SolicitudDialog.mostrar(context: context);
    final email = authService.getCurrentUserEmail() ?? 'default@email.com';

    if (result != null) {
      try {
        await _prestamoService.createPrestamo(
          idSolicitante: int.parse(await _userService.getUserId(email: email)),
          idPropietario: int.parse(widget.book.idUsuario),
          idLibro: widget.book.id,
          duracion: result['duracion'],
          mensaje: result['mensaje'],
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Solicitud enviada con éxito")),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
        }
      }
    }
  }

  void _editarLibro() {
    // Lógica para editar libro
  }

  void _eliminarLibro() {
    _bookService.deleteLibro(widget.book.id);
    AppRoutes.goTo(context, AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadingFuture,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8F0),
          appBar: AppBar(
            title: const Text(
              'Detalles del libro',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto",
              ),
            ),
            backgroundColor: const Color(0xFF5E4B3B),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                BookHeader(book: widget.book),
                const SizedBox(height: 30),
                DetailUser(book: widget.book),
                const SizedBox(height: 15),
                const Text("Detalles adicionales:"),
                BookDetallesAdicionales(book: widget.book),

                if (snapshot.connectionState == ConnectionState.done) ...[
                  if (esMiLibro) ...[
                    CustomIconButton(
                      text: "Editar Libro",
                      onPressed: _editarLibro,
                      icon: Icons.edit,
                    ),
                    CustomIconButton(
                      text: "Eliminar Libro",
                      onPressed: _eliminarLibro,
                      icon: Icons.delete,
                    ),
                  ] else
                    CustomIconButton(
                      text: "Solicitar Libro",
                      onPressed: () => _solicitarLibro(context),
                    ),
                ] else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
