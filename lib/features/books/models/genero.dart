class Genero {
  final int id;
  final String nombre;
  final String descripcion;

  Genero({required this.id, required this.nombre, required this.descripcion});

  factory Genero.fromJson(Map<String, dynamic> json) {
    return Genero(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  @override
  String toString() {
    return 'Genero{id: $id, nombre: "$nombre", descripcion: "$descripcion"}';
  }
}
