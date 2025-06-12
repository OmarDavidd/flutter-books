import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/features/books/helpers/genres.dart';

class BookFormFields extends StatefulWidget {
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
  State<BookFormFields> createState() => _BookFormFieldsState();
}

class _BookFormFieldsState extends State<BookFormFields> {
  List<String> _selectedGenresList = [];
  List<int> _selectedGenreIds = [];

  late List<String> _genreOptions;
  late Map<String, int> _genreNameToIdMap;

  @override
  void initState() {
    super.initState();

    // Crear mapa de nombre de género a ID
    _genreNameToIdMap = {
      for (var genre in allGenres)
        genre['nombre'] as String: genre['id'] as int,
    };

    _genreOptions =
        allGenres.map((genre) => genre['nombre'] as String).toList();

    if (widget.genresController.text.isNotEmpty) {
      // Si el controlador ya tiene IDs (números), los convertimos a nombres para mostrar
      _selectedGenreIds =
          widget.genresController.text
              .split(',')
              .map((id) => int.tryParse(id.trim()) ?? 0)
              .toList();
      _selectedGenresList =
          _selectedGenreIds
              .map((id) {
                var genre = allGenres.firstWhere(
                  (g) => g['id'] == id,
                  orElse: () => {'nombre': ''},
                );
                return genre['nombre'] as String;
              })
              .where((name) => name.isNotEmpty)
              .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: widget.titleController,
          icon: Icons.title,
          label: 'Título',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El título no puede estar vacío.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: widget.authorController,
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
          controller: widget.publisherController,
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
          controller: widget.yearController,
          icon: Icons.calendar_today,
          label: 'Año de publicación',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El año no puede estar vacío.';
            }
            final year = int.tryParse(value);
            if (year == null || year < 1000 || year > DateTime.now().year) {
              return 'Ingresa un año válido.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: widget.isbnController,
          icon: Icons.code,
          label: 'ISBN',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El ISBN no puede estar vacío.';
            }
            if (value.length < 10 || value.length > 13) {
              return 'El ISBN suele tener 10 o 13 dígitos.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),

        InputDecorator(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.category),
            labelText: 'Géneros',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: const Color(0xFFFFFFFF),
            contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Selecciona un género'),
              value: null,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                if (newValue != null &&
                    !_selectedGenresList.contains(newValue)) {
                  setState(() {
                    _selectedGenresList.add(newValue);
                    _selectedGenreIds.add(_genreNameToIdMap[newValue]!);
                    widget.genresController.text = _selectedGenreIds.join(',');
                  });
                }
              },
              items:
                  _genreOptions.map<DropdownMenuItem<String>>((String genre) {
                    return DropdownMenuItem<String>(
                      value: genre,
                      child: Text(genre),
                    );
                  }).toList(),
            ),
          ),
        ),
        if (_selectedGenresList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  _selectedGenresList.map((genre) {
                    return Chip(
                      label: Text(genre),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          int index = _selectedGenresList.indexOf(genre);
                          _selectedGenresList.removeAt(index);
                          _selectedGenreIds.removeAt(index);
                          widget.genresController.text = _selectedGenreIds.join(
                            ',',
                          );
                        });
                      },
                    );
                  }).toList(),
            ),
          ),

        const SizedBox(height: 10),
        CustomTextField(
          controller: widget.stateController,
          icon: Icons.check_circle,
          label: 'Estado',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El estado no puede estar vacío.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
