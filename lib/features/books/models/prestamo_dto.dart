class PrestamoDTO {
  final int id;
  final String nombreSolicitante;
  final String nombrePropietario;
  final String nombreLibro;
  final int idLibro;
  final String fechaInicio;
  final String fechaDevolucionEsperada;
  final int duracion;
  final String? lugar;
  final String estado;
  final String mensaje;

  PrestamoDTO({
    required this.id,
    required this.nombreSolicitante,
    required this.nombrePropietario,
    required this.nombreLibro,
    required this.idLibro,
    required this.fechaInicio,
    required this.fechaDevolucionEsperada,
    required this.duracion,
    this.lugar,
    required this.estado,
    this.mensaje = "",
  });

  factory PrestamoDTO.fromJson(Map<String, dynamic> json) {
    return PrestamoDTO(
      id: json['id'],
      nombreSolicitante: json['nombreSolicitante'],
      nombrePropietario: json['nombrePropietario'],
      nombreLibro: json['nombreLibro'],
      idLibro:
          json['idLibro'] ??
          0, // Aseguramos que idLibro tenga un valor por defecto
      fechaInicio: json['fechaInicio'] ?? "",
      fechaDevolucionEsperada: json['fechaDevolucionEsperada'] ?? "",
      duracion: json['duracion'],
      lugar: json['lugar'],
      estado: json['estado'],
      mensaje: json['mensaje'] ?? "",
    );
  }

  // Método para convertir a Map (útil para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreSolicitante': nombreSolicitante,
      'nombrePropietario': nombrePropietario,
      'nombreLibro': nombreLibro,
      'idLibro': idLibro,
      'fechaInicio': fechaInicio,
      'fechaDevolucionEsperada': fechaDevolucionEsperada,
      'duracion': duracion,
      'lugar': lugar,
      'estado': estado,
      'mensaje': mensaje,
    };
  }

  // Método para imprimir de forma legible
  @override
  String toString() {
    return 'PrestamoDTO{'
        'id: $id, '
        'solicitante: $nombreSolicitante, '
        'propietario: $nombrePropietario, '
        'libro: $nombreLibro, '
        'idLibro: $idLibro, '
        'inicio: $fechaInicio, '
        'devolución esperada: $fechaDevolucionEsperada, '
        'duración: $duracion días, '
        'lugar: $lugar, '
        'estado: $estado'
        ', mensaje: $mensaje'
        '}';
  }
}
