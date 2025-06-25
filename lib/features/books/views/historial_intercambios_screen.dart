import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/controllers/auth_controller.dart';
import 'package:flutter_application_1/features/auth/views/login_page.dart';
import 'package:flutter_application_1/features/books/models/prestamo_dto.dart';
import 'package:flutter_application_1/features/books/services/prestamo_service.dart';

class HistorialIntercambiosScreen extends StatefulWidget {
  const HistorialIntercambiosScreen({super.key});

  @override
  State<HistorialIntercambiosScreen> createState() =>
      _HistorialIntercambiosScreenState();
}

class _HistorialIntercambiosScreenState
    extends State<HistorialIntercambiosScreen> {
  final PrestamoService _prestamoService = PrestamoService();
  late Future<List<PrestamoDTO>> _solicitudesEnviadas;
  late Future<List<PrestamoDTO>> _solicitudesRecibidas;
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
    _cargarSolicitudes();
  }

  void _cargarSolicitudes() {
    _solicitudesEnviadas = _prestamoService.getSolicitudesEnviadas();
    _solicitudesRecibidas = _prestamoService.getSolicitudesRecibidas();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8F0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Historial de Intercambios',
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
          bottom: const TabBar(
            tabs: [Tab(text: 'Enviadas'), Tab(text: 'Recibidas')],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildListaSolicitudes(_solicitudesEnviadas, "enviado"),
            _buildListaSolicitudes(_solicitudesRecibidas, "recibido"),
          ],
        ),
      ),
    );
  }

  Widget _buildListaSolicitudes(
    Future<List<PrestamoDTO>> futureSolicitudes,
    String tipo,
  ) {
    return FutureBuilder<List<PrestamoDTO>>(
      future: futureSolicitudes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF5E4B3B)),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar los datos',
              style: TextStyle(color: Color(0xFF5E4B3B), fontSize: 16),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No hay solicitudes',
              style: TextStyle(color: Color(0xFF8C7A6B), fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final solicitud = snapshot.data![index];
            return _buildTarjetaSolicitud(solicitud, tipo);
          },
        );
      },
    );
  }

  Widget _buildTarjetaSolicitud(PrestamoDTO solicitud, String tipo) {
    // Configuración de colores según estado
    final (
      Color bgColor,
      Color borderColor,
      Color textColor,
    ) = switch (solicitud.estado.toLowerCase()) {
      'pendiente' => (
        const Color(0xFFFFF8F0),
        const Color(0xFFF4A261),
        const Color(0xFF5E4B3B),
      ),
      'aceptada' => (
        const Color(0xFFF0F9F7),
        const Color(0xFF2A9D8F),
        const Color(0xFF264653),
      ),
      'completado' => (
        const Color(0xFFF0F2F5),
        const Color(0xFF264653),
        const Color(0xFF5E4B3B),
      ),
      _ => (
        const Color(0xFFFFF8F0),
        const Color(0xFF8C7A6B),
        const Color(0xFF5E4B3B),
      ),
    };

    return Container(
      height: 180, // Altura similar a BookCard pero un poco más grande
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5DDD3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sección de contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del libro (estilo igual a BookCard)
                  Text(
                    "Titulo del libro:\n${solicitud.nombreLibro}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF5E4B3B),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Información del propietario/intercambio
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5E4B3B),
                        fontFamily: "Roboto",
                      ),
                      children: [
                        const TextSpan(
                          text: "Dueño: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: solicitud.nombrePropietario),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Fila inferior con estado y botón
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge de estado (estilo mejorado)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: borderColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Text(
                          solicitud.estado,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/prestamo-details',
                              arguments: {"prestamo": solicitud, "tipo": tipo},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4A373),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text(
                            "Detalles",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ),
                      ),
                    ],
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
