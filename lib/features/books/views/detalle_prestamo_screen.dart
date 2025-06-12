import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/models/prestamo_dto.dart';
import 'package:flutter_application_1/features/books/services/book_service.dart';
import 'package:flutter_application_1/features/books/models/libro.dart';
import 'package:flutter_application_1/features/books/services/prestamo_service.dart';
import 'package:flutter_application_1/features/books/widgets/custom_icon_button.dart';
import 'package:flutter_application_1/features/chat/screens/chat_screen.dart';

class DetallePrestamoScreen extends StatefulWidget {
  final PrestamoDTO prestamo;
  final String tipo;

  const DetallePrestamoScreen({
    super.key,
    required this.prestamo,
    required this.tipo,
  });

  @override
  State<DetallePrestamoScreen> createState() => _DetallePrestamoScreenState();
}

class _DetallePrestamoScreenState extends State<DetallePrestamoScreen> {
  final BookService _bookService = BookService();
  final PrestamoService _prestamoService = PrestamoService();
  late Future<Libro?> _libroFuture;
  bool _isLoading = false;
  DateTime? _selectedDateTime;
  String fechaParaBackend = "";

  @override
  void initState() {
    super.initState();
    _libroFuture = _loadBookData();
  }

  Future<Libro?> _loadBookData() async {
    try {
      setState(() => _isLoading = true);
      return await _bookService.getBookById(widget.prestamo.idLibro);
    } catch (e) {
      debugPrint('Error cargando libro: $e');
      return null;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text(
          'Detalle del Préstamo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5E4B3B),
      ),
      body: FutureBuilder<Libro?>(
        future: _libroFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                const Text(
                  'Solicitud de préstamo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E4B3B),
                  ),
                ),
                const SizedBox(height: 20),

                _buildSeccion(
                  titulo: 'Libro solicitado',
                  contenido: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prestamo.nombreLibro,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Propietario
                _buildSeccion(
                  titulo: 'Propietario',
                  contenido: Text(widget.prestamo.nombrePropietario),
                ),

                // Estado
                _buildSeccion(
                  titulo: 'Estado',
                  contenido: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    child: Text(
                      widget.prestamo.estado,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Fechas
                _buildSeccion(
                  titulo: 'Fechas',
                  contenido: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Duracion: ${widget.prestamo.duracion} dias'),
                    ],
                  ),
                ),
                /*
                _buildSeccion(
                  titulo: 'Fechas',
                  contenido: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Solicitado: ${widget.prestamo.fechaInicio}'),
                      const SizedBox(height: 4),
                      Text(
                        'Devolución esperada: ${widget.prestamo.fechaDevolucionEsperada}',
                      ),
                    ],
                  ),
                ),*/

                // Detalles del encuentro
                _buildSeccion(
                  titulo: 'Detalles del encuentro',
                  contenido: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFF8C7A6B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.prestamo.fechaInicio ??
                                'Fecha aun no especificada',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFF8C7A6B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.prestamo.lugar ?? 'Lugar no especificado',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                _buildSeccion(
                  titulo: 'Mensaje',
                  contenido: Text(widget.prestamo.mensaje),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomIconButton(
                          text: "Enviar mensaje",
                          icon: Icons.message,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChatScreen(
                                      currentUserId: "1",
                                      otherUserId: "2",
                                      otherUserName: "Omar",
                                    ),
                              ),
                            );

                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  currentUserId: widget.prestamo.idUsuario,
                                  otherUserId:
                                      widget.prestamo.idPropietario,
                                  otherUserName:
                                      widget.prestamo.nombrePropietario,
                                ),
                              ),
                            );
                          */
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Botones de acción
                if (widget.prestamo.estado.toLowerCase() == 'solicitado' &&
                    widget.tipo == "enviado")
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomIconButton(
                            text: "Cancelar solicitud",
                            onPressed: _cancelarPrestamo,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (widget.prestamo.estado.toLowerCase() == 'solicitado' &&
                    widget.tipo == "recibido")
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        // Botón Rechazar
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                            ), // Espacio entre botones
                            child: CustomIconButton(
                              text: "Rechazar",
                              onPressed: _rechazarPrestamo,
                            ),
                          ),
                        ),
                        // Botón Aceptar
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CustomIconButton(
                              text: "Aceptar",
                              onPressed: _aceptarPrestamo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (widget.prestamo.estado.toLowerCase() == 'aceptado' &&
                    widget.tipo == "enviado")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              text: 'Seleccionar fecha y hora',
                              icon:
                                  Icons
                                      .calendar_today, // Opcional: puedes añadir un icono
                              onPressed: () async {
                                final DateTime?
                                pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 1),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary:
                                              Colors.blue, // Color principal
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  final TimeOfDay? pickedTime =
                                      await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                  if (pickedTime != null) {
                                    // Por ejemplo: ;
                                    setState(() {
                                      _selectedDateTime = DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                        pickedTime.hour,
                                        pickedTime.minute,
                                      );
                                    });
                                    fechaParaBackend =
                                        _selectedDateTime!.toIso8601String();
                                    fechaParaBackend =
                                        fechaParaBackend.split('.')[0];
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _selectedDateTime == null
                              ? 'Ninguna fecha/hora seleccionada'
                              : 'Seleccionado: ${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        CustomIconButton(
                          text: 'Aceptar',
                          onPressed: _aceptarHorario,
                        ),
                      ],
                    ),
                  ),

                if (widget.prestamo.estado.toLowerCase() ==
                        'solicitando fecha' &&
                    widget.tipo == "recibido")
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        // Botón Rechazar
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                            ), // Espacio entre botones
                            child: CustomIconButton(
                              text: "Rechazar",
                              onPressed: _rechazarFecha,
                            ),
                          ),
                        ),
                        // Botón Aceptar
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CustomIconButton(
                              text: "Aceptar",
                              onPressed: _aceptarFecha,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (widget.prestamo.estado.toLowerCase() == 'fecha aceptada')
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CustomIconButton(
                              text: "Libro entregado",
                              onPressed: _entregado,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _cancelarPrestamo() async {
    try {
      setState(() => _isLoading = true);
      _prestamoService.deleteSolicitud(widget.prestamo.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préstamo cancelado exitosamente')),
      );
      Navigator.pop(context, true); // Retornar true para indicar éxito
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cancelar: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _rechazarPrestamo() async {
    try {
      setState(() => _isLoading = true);
      _prestamoService.cambiarEstado(widget.prestamo.id, 5);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préstamo rechazado exitosamente')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al rechazar: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _entregado() async {
    try {
      setState(() => _isLoading = true);
      _prestamoService.cambiarEstado(widget.prestamo.id, 3);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Libro entregado')));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al entegar libro: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _aceptarPrestamo() async {
    try {
      setState(() => _isLoading = true);
      _prestamoService.cambiarEstado(widget.prestamo.id, 2);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préstamo aceptado exitosamente')),
      );
      Navigator.pop(context, true); // Retornar true para indicar éxito
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cancelar: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _rechazarFecha() async {
    try {
      setState(() => _isLoading = true);
      _prestamoService.cambiarEstado(widget.prestamo.id, 2);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fecha rechazada exitosamente')),
      );
      Navigator.pop(context, true); // Retornar true para indicar éxito
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al rechazar fecha: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _aceptarFecha() async {
    try {
      setState(() => _isLoading = true);
      _prestamoService.cambiarEstado(widget.prestamo.id, 8);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fecha aceptada exitosamente')),
      );
      Navigator.pop(context, true); // Retornar true para indicar éxito
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al aceptada fecha: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _aceptarHorario() async {
    try {
      setState(() => _isLoading = true);

      _prestamoService.cambiarEstado(widget.prestamo.id, 7);
      _prestamoService.cambiarfecha(widget.prestamo.id, fechaParaBackend);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fecha aceptada exitosamente')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al acptar: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildSeccion({required String titulo, required Widget contenido}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E4B3B),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE5DDD3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5DDD3)),
            ),
            child: contenido,
          ),
        ],
      ),
    );
  }
}
