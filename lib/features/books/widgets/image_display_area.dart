// lib/widgets/image_display_area.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/config/cloudinary_config.dart';
import 'package:image_picker/image_picker.dart'; // Solo para el tipo XFile
import 'package:cloudinary_flutter/image/cld_image.dart';

class ImageDisplayArea extends StatelessWidget {
  final XFile? selectedPhoto;
  final String? uploadedImageUrl;
  final String? uploadedImagePublicId;
  final bool isUploading;

  const ImageDisplayArea({
    super.key,
    this.selectedPhoto,
    this.uploadedImageUrl,
    this.uploadedImagePublicId,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: const Text(
            'Imagen seleccionada:',
            style: TextStyle(fontSize: 16),
          ),
        ),
        if (selectedPhoto != null)
          Image.file(
            File(selectedPhoto!.path),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
        else
          const Icon(Icons.image, size: 150, color: Colors.grey),

        const SizedBox(height: 30),
      ],
    );
  }
}
