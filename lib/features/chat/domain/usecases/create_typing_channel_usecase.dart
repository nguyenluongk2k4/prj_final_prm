import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/typing_repository.dart';

@injectable
class CreateTypingChannelUseCase {
  final TypingRepository _repository;

  CreateTypingChannelUseCase(this._repository);

  RealtimeChannel execute({
    required String myId,
    required String otherId,
  }) {
    return _repository.createChannel(myId: myId, otherId: otherId);
  }
}
