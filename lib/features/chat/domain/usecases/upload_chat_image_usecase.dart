import 'dart:io';
import 'package:injectable/injectable.dart';
import '../repositories/chat_media_repository.dart';

@injectable
class UploadChatImageUseCase {
  final ChatMediaRepository _repository;

  UploadChatImageUseCase(this._repository);

  Future<String?> execute({required File file}) async {
    return _repository.uploadImage(file);
  }
}
