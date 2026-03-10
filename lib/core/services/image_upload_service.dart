import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ImageUploadService {
  final Dio _dio = Dio(); // Basic DIO instance avoiding our generic DioClient baseUrl config

  Future<String?> uploadImage(File imageFile) async {
    try {
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];

      if (cloudName == null || uploadPreset == null) {
        throw Exception('Cloudinary configuration is missing in .env');
      }

      final uri = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      final fileName = imageFile.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path, filename: fileName),
        'upload_preset': uploadPreset,
      });

      final response = await _dio.post(uri, data: formData);

      if (response.statusCode == 200) {
        return response.data['secure_url'] as String?;
      }
      return null;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  Future<String?> uploadFile(File file, {String resourceType = 'raw'}) async {
    try {
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];

      if (cloudName == null || uploadPreset == null) {
        throw Exception('Cloudinary configuration is missing in .env');
      }

      final uri =
          'https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload';

      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'upload_preset': uploadPreset,
      });

      final response = await _dio.post(uri, data: formData);

      if (response.statusCode == 200) {
        return response.data['secure_url'] as String?;
      }
      return null;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  Future<String?> uploadVideo(File videoFile) async {
    try {
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];

      if (cloudName == null || uploadPreset == null) {
        throw Exception('Cloudinary configuration is missing in .env');
      }

      final uri = 'https://api.cloudinary.com/v1_1/$cloudName/video/upload';

      final fileName = videoFile.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(videoFile.path, filename: fileName),
        'upload_preset': uploadPreset,
        // Optimization: Cloudinary video transformations can be added here or via URL
      });

      final response = await _dio.post(uri, data: formData);

      if (response.statusCode == 200) {
        String? url = response.data['secure_url'] as String?;
        if (url != null) {
          // Wrap with auto-format and auto-quality for streaming optimization
          // Cloudinary video URL format: .../video/upload/transformations/v.../...
          final parts = url.split('/upload/');
          if (parts.length == 2) {
            return '${parts[0]}/upload/f_auto,q_auto/${parts[1]}';
          }
        }
        return url;
      }
      return null;
    } catch (e) {
      print('Cloudinary video upload error: $e');
      return null;
    }
  }
}
