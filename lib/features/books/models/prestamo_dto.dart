class PrestamoDTO {
  final int id;
  final String nombreSolicitante;
  final String idSolicitante;
  final String nombrePropietario;
  final String idPropietario;

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
    required this.idSolicitante,
    required this.nombrePropietario,
    required this.idPropietario,
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
      idSolicitante: json['idSolicitante'] ?? "",
      nombrePropietario: json['nombrePropietario'],
      idPropietario: json['idPropietario'] ?? "",
      nombreLibro: json['nombreLibro'],
      idLibro: json['idLibro'] ?? 0,
      fechaInicio: json['fechaInicio'] ?? "",
      fechaDevolucionEsperada: json['fechaDevolucionEsperada'] ?? "",
      duracion: json['duracion'],
      lugar: json['lugar'],
      estado: json['estado'],
      mensaje: json['mensaje'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreSolicitante': nombreSolicitante,
      'idSolicitante': idSolicitante,
      'nombrePropietario': nombrePropietario,
      'idPropietario': idPropietario,
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
        'idSolicitante: $idSolicitante, '
        'propietario: $nombrePropietario, '
        'idPropietario: $idPropietario, '
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
