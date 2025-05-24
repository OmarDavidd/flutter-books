import 'package:cloudinary/cloudinary.dart';
import 'package:cloudinary_url_gen/cloudinary.dart' as cld_url_gen;

const String CLOUD_NAME = 'dokcaspa4';
const String UPLOAD_PRESET = 'mis_images';
const String CLOUDINARY_UPLOAD_FOLDER = 'flutter_simple_uploads';
final Cloudinary uploaderCloudinary = Cloudinary.unsignedConfig(
  cloudName: CLOUD_NAME,
);
final cld_url_gen.Cloudinary displayCloudinary = cld_url_gen
    .Cloudinary.fromCloudName(cloudName: CLOUD_NAME);
