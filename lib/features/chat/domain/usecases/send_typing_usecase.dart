import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/typing_repository.dart';

@injectable
class SendTypingUseCase {
  final TypingRepository _repository;

  SendTypingUseCase(this._repository);

  Future<void> execute({
    required RealtimeChannel channel,
    required String myId,
    required String otherId,
    required bool isTyping,
  }) async {
    await _repository.sendTyping(
      channel: channel,
      myId: myId,
      otherId: otherId,
      isTyping: isTyping,
    );
  }
}
