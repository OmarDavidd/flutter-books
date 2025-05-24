import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/features/books/config/cloudinary_config.dart'; // Para debugPrint

class ImageUploadService {
  Future<Map<String, String>?> uploadImage(File imageFile) async {
    try {
      final response = await uploaderCloudinary.unsignedUpload(
        file: imageFile.path,
        uploadPreset: UPLOAD_PRESET,
        folder: CLOUDINARY_UPLOAD_FOLDER,
        resourceType: CloudinaryResourceType.image,
      );

      if (response.statusCode == 200 && response.secureUrl != null) {
        debugPrint(
          'Cloudinary: Imagen subida con éxito. URL: ${response.secureUrl}, Public ID: ${response.publicId}',
        );
        return {
          'secureUrl': response.secureUrl!,
          'publicId': response.publicId!,
        };
      } else {
        debugPrint(
          'Cloudinary Error (HTTP ${response.statusCode}): ${response.error ?? 'Error desconocido'}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Cloudinary Exception during upload: $e');
      return null;
    }
  }
}
