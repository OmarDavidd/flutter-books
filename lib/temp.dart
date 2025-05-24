/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genresController = TextEditingController();
  final _publisherController = TextEditingController();
  final _stateController = TextEditingController();
  final _isbnController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  Future<void> _pickImages() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          _images.addAll(selectedImages);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al seleccionar imágenes')),
      );
    }
  }

  // Método para tomar una foto con la cámara
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _images.add(photo);
      });
    }
  }

  // Método para guardar el libro
  void _saveBook() {
    final title = _titleController.text;
    final author = _authorController.text;
    final genres = _genresController.text;
    final publisher = _publisherController.text;
    final state = _stateController.text;
    final isbn = _isbnController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || author.isEmpty || genres.isEmpty || isbn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos obligatorios'),
        ),
      );
      return;
    }

    // Aquí puedes enviar los datos a tu backend o base de datos
    print(
      'Libro guardado: $title, $author, $genres, $publisher, $state, $isbn, $description',
    );
    print('Imágenes seleccionadas: ${_images.length}');

    // Limpia los campos después de guardar
    _titleController.clear();
    _authorController.clear();
    _genresController.clear();
    _publisherController.clear();
    _stateController.clear();
    _isbnController.clear();
    _descriptionController.clear();
    setState(() {
      _images.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Libro agregado exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Libro'),
        backgroundColor: const Color(0xFF5E4B3B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fotos del libro:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galería'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Cámara'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _images.isNotEmpty
                ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.file(
                          File(_images[index].path), // 'File' is now resolved
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                )
                : const Text('No se han seleccionado imágenes'),
            const SizedBox(height: 16),
            _buildTextField(_titleController, 'Título', 'Ej. El Principito'),
            _buildTextField(
              _authorController,
              'Autor',
              'Ej. Antoine de Saint-Exupéry',
            ),
            _buildTextField(
              _genresController,
              'Géneros',
              'Ej. Fantasía, Aventura',
            ),
            _buildTextField(
              _publisherController,
              'Editorial',
              'Ej. Editorial XYZ',
            ),
            _buildTextField(_stateController, 'Estado', 'Ej. Nuevo, Usado'),
            _buildTextField(_isbnController, 'ISBN', 'Ej. 978-3-16-148410-0'),
            _buildTextField(
              _descriptionController,
              'Descripción',
              'Ej. Un libro clásico sobre un pequeño príncipe...',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E4B3B),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Guardar Libro'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir un campo de texto
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String placeholder, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
*/
