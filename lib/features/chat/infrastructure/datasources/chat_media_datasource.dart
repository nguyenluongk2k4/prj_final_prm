import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/services/image_upload_service.dart';
import '../../domain/utils/chat_message_formatter.dart';

@lazySingleton
class ChatMediaDatasource {
  final ImageUploadService _imageUploadService;
  final Dio _downloadDio = Dio();

  ChatMediaDatasource(this._imageUploadService);

  Future<String?> uploadImage(File file) async {
    return _imageUploadService.uploadImage(file);
  }

  Future<String?> uploadFile(File file) async {
    return _imageUploadService.uploadFile(file);
  }

  Future<String?> downloadFile({required String url}) async {
    if (url.isEmpty) return null;
    final docsDir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${docsDir.path}/downloads');
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }

    final name = ChatMessageFormatter.fileNameFromUrl(url);
    final fileName = name.isNotEmpty
        ? name
        : 'file_${DateTime.now().millisecondsSinceEpoch}';
    final savePath = '${downloadsDir.path}/$fileName';

    await _downloadDio.download(url, savePath);
    return savePath;
  }
}
