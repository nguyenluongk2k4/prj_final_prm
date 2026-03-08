import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/typing_repository.dart';

@injectable
class SubscribeTypingUseCase {
  final TypingRepository _repository;

  SubscribeTypingUseCase(this._repository);

  Stream<bool> execute({
    required RealtimeChannel channel,
    required String myId,
    required String otherId,
  }) {
    return _repository.subscribeTyping(
      channel: channel,
      myId: myId,
      otherId: otherId,
    );
  }
}
