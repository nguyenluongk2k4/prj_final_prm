import 'package:injectable/injectable.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

@injectable
class GetMessagesUseCase {
  final ChatRepository _repository;

  GetMessagesUseCase(this._repository);

  Future<List<ChatMessage>> execute({
    required String myId,
    required String otherId,
  }) async {
    return _repository.fetchMessages(myId: myId, otherId: otherId);
  }
}
