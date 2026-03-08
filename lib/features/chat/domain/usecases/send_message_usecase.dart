import 'package:injectable/injectable.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

@injectable
class SendMessageUseCase {
  final ChatRepository _repository;

  SendMessageUseCase(this._repository);

  Future<ChatMessage> execute({
    required String myId,
    required String otherId,
    required String content,
    required ChatMessageType type,
  }) async {
    return _repository.sendMessage(
      myId: myId,
      otherId: otherId,
      content: content,
      type: type,
    );
  }
}
