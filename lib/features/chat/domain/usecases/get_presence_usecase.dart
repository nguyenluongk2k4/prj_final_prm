import 'package:injectable/injectable.dart';
import '../entities/chat_presence.dart';
import '../repositories/chat_repository.dart';

@injectable
class GetPresenceUseCase {
  final ChatRepository _repository;

  GetPresenceUseCase(this._repository);

  Future<ChatPresence?> execute({required String userId}) async {
    return _repository.fetchPresence(userId: userId);
  }
}
