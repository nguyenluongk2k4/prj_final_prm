import 'package:injectable/injectable.dart';
import '../repositories/chat_media_repository.dart';

@injectable
class DownloadChatFileUseCase {
  final ChatMediaRepository _repository;

  DownloadChatFileUseCase(this._repository);

  Future<String?> execute({required String url}) async {
    return _repository.downloadFile(url: url);
  }
}
