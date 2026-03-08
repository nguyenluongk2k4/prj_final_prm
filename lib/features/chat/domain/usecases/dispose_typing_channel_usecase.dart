import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/typing_repository.dart';

@injectable
class DisposeTypingChannelUseCase {
  final TypingRepository _repository;

  DisposeTypingChannelUseCase(this._repository);

  void execute(RealtimeChannel channel) {
    _repository.disposeChannel(channel);
  }
}
