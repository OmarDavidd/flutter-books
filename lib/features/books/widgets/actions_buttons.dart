// lib/widgets/action_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/books/widgets/custom_icon_button.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onPickFromGallery;
  final VoidCallback onPickFromCamera;
  final VoidCallback onUploadPressed;
  final bool isUploading;
  final bool canUpload;

  const ActionButtons({
    super.key,
    required this.onPickFromGallery,
    required this.onPickFromCamera,
    required this.onUploadPressed,
    this.isUploading = false,
    this.canUpload = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIconButton(
              text: 'Galería',
              icon: Icons.photo_library,
              onPressed: onPickFromGallery,
            ),
            CustomIconButton(
              text: 'Cámara',
              icon: Icons.camera_alt,
              onPressed: onPickFromCamera,
            ),
          ],
        ),
        /*
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: (isUploading || !canUpload) ? null : onUploadPressed,
          icon:
              isUploading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Icon(Icons.cloud_upload),
          label: Text(isUploading ? 'Subiendo...' : 'Subir Imagen'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),*/
      ],
    );
  }
}
