import 'dart:io';
import 'package:injectable/injectable.dart';
import '../repositories/chat_media_repository.dart';

@injectable
class UploadChatFileUseCase {
  final ChatMediaRepository _repository;

  UploadChatFileUseCase(this._repository);

  Future<String?> execute({required File file}) async {
    return _repository.uploadFile(file);
  }
}
