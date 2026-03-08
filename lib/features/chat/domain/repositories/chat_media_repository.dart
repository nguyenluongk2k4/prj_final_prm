import 'dart:io';

abstract class ChatMediaRepository {
  Future<String?> uploadImage(File file);

  Future<String?> uploadFile(File file);

  Future<String?> downloadFile({required String url});
}
