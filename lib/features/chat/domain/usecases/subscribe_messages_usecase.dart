import 'package:injectable/injectable.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

@injectable
class SubscribeMessagesUseCase {
  final ChatRepository _repository;

  SubscribeMessagesUseCase(this._repository);

  Stream<ChatMessage> execute({
    required String myId,
    required String otherId,
  }) {
    return _repository.subscribeMessages(myId: myId, otherId: otherId);
  }
}
