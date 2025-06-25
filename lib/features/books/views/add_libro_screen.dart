import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/services/book_service.dart';
import 'package:flutter_application_1/features/books/services/image_upload_service.dart';
import 'package:flutter_application_1/features/books/widgets/actions_buttons.dart';
import 'package:flutter_application_1/features/books/widgets/book_form_fields.dart';
import 'package:flutter_application_1/features/books/widgets/custom_icon_button.dart';
import 'package:flutter_application_1/features/books/widgets/image_display_area.dart';
import 'package:image_picker/image_picker.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BookService bookService = BookService();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _yearController = TextEditingController();
  final _isbnController = TextEditingController();
  final _genresController = TextEditingController();
  final _stateController = TextEditingController();

  XFile? _selectedPhoto;
  String? _uploadedImageUrl;
  String? _uploadedImagePublicId;
  bool _isUploading = false;

  final ImageUploadService _imageUploadService = ImageUploadService();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedPhoto = pickedFile;
          _uploadedImageUrl = null;
          _uploadedImagePublicId = null;
        });
      }
    } catch (e) {
      debugPrint('Error al seleccionar la imagen: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar la imagen: $e')),
        );
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedPhoto == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecciona una imagen primero.'),
          ),
        );
      }
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final uploadResult = await _imageUploadService.uploadImage(
      File(_selectedPhoto!.path),
    );

    setState(() {
      _isUploading = false;
      if (uploadResult != null) {
        _uploadedImageUrl = uploadResult['secureUrl'];
        _uploadedImagePublicId = uploadResult['publicId'];
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagen subida con éxito!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Falló la subida de la imagen.')),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _isbnController.dispose();
    _genresController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Añadir Libro',
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Añadir libro:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5E4B3B),
                  fontFamily: "Roboto",
                ),
              ),
              const SizedBox(height: 16),
              ActionButtons(
                onPickFromGallery: () => _pickImage(ImageSource.gallery),
                onPickFromCamera: () => _pickImage(ImageSource.camera),
                onUploadPressed: _uploadImage,
                isUploading: _isUploading,
                canUpload: _selectedPhoto != null,
              ),
              const SizedBox(height: 30),
              ImageDisplayArea(
                selectedPhoto: _selectedPhoto,
                uploadedImageUrl: _uploadedImageUrl,
                uploadedImagePublicId: _uploadedImagePublicId,
                isUploading: _isUploading,
              ),
              BookFormFields(
                titleController: _titleController,
                authorController: _authorController,
                genresController: _genresController,
                publisherController: _publisherController,
                stateController: _stateController,
                isbnController: _isbnController,
                yearController: _yearController,
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomIconButton(
                  text: 'Guardar Libro',
                  icon: Icons.save,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_isUploading || (_selectedPhoto != null)) {
                        await _uploadImage();

                        await bookService.createLibro(
                          titulo: _titleController.text,
                          autor: _authorController.text,
                          editorial: _publisherController.text,
                          anioPublicacion: int.parse(_yearController.text),
                          isbn: _isbnController.text,
                          estadoFisico: _stateController.text,
                          disponibleIntercambio: true,

                          generosIdsEntrada:
                              _genresController.text
                                  .split(',')
                                  .map(
                                    (genre) => int.tryParse(genre.trim()) ?? 0,
                                  )
                                  .where((id) => id > 0)
                                  .toList(),
                          urlsImagenesEntrada:
                              _uploadedImageUrl != null
                                  ? [_uploadedImageUrl!]
                                  : [],
                        );
                        debugPrint(
                          "lo que llega del con" + _genresController.text,
                        );

                        _formKey.currentState?.reset();
                        setState(() {
                          _selectedPhoto = null;
                          _uploadedImageUrl = null;
                          _uploadedImagePublicId = null;
                        });

                        _titleController.clear();
                        _authorController.clear();
                        _publisherController.clear();
                        _yearController.clear();
                        _isbnController.clear();
                        _genresController.clear();
                        _stateController.clear();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Libro guardado con éxito!'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, sube la imagen primero.'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, corrige los errores del formulario.',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
