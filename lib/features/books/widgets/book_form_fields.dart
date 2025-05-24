// lib/widgets/book_form_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';

class BookFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController publisherController;
  final TextEditingController yearController;
  final TextEditingController isbnController;
  final TextEditingController genresController;
  final TextEditingController stateController;

  const BookFormFields({
    super.key,
    required this.titleController,
    required this.authorController,
    required this.publisherController,
    required this.yearController,
    required this.isbnController,
    required this.genresController,
    required this.stateController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: titleController,
          icon: Icons.title,
          label: 'Título',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El título no puede estar vacío.';
            }
            return null; // Retorna null si es válido
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: authorController,
          icon: Icons.person,
          label: 'Autor',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El autor no puede estar vacío.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: publisherController,
          icon: Icons.business,
          label: 'Editorial',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La editorial no puede estar vacía.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: yearController,
          icon: Icons.calendar_today,
          label: 'Año de publicación',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El año no puede estar vacío.';
            }
            final year = int.tryParse(value);
            if (year == null || year < 1000 || year > DateTime.now().year) {
              // Validación de año realista
              return 'Ingresa un año válido.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: isbnController,
          icon: Icons.code,
          label: 'ISBN',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El ISBN no puede estar vacío.';
            }
            // Puedes añadir una validación de formato de ISBN más robusta aquí
            if (value.length < 10 || value.length > 13) {
              return 'El ISBN suele tener 10 o 13 dígitos.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: genresController,
          icon: Icons.category,
          label: 'Géneros',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa al menos un género.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: stateController,
          icon: Icons.check_circle,
          label: 'Estado',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El estado no puede estar vacío.';
            }
            // Podrías validar contra una lista de estados permitidos
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
