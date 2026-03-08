import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/typing_repository.dart';
import '../../infrastructure/datasources/typing_datasource.dart';

@Injectable(as: TypingRepository)
class TypingRepositoryImpl implements TypingRepository {
  final TypingDatasource _datasource;

  TypingRepositoryImpl(this._datasource);

  @override
  RealtimeChannel createChannel({
    required String myId,
    required String otherId,
  }) {
    return _datasource.createChannel(myId: myId, otherId: otherId);
  }

  @override
  Stream<bool> subscribeTyping({
    required RealtimeChannel channel,
    required String myId,
    required String otherId,
  }) {
    return _datasource.subscribeTyping(
      channel: channel,
      myId: myId,
      otherId: otherId,
    );
  }

  @override
  Future<void> sendTyping({
    required RealtimeChannel channel,
    required String myId,
    required String otherId,
    required bool isTyping,
  }) async {
    await _datasource.sendTyping(
      channel: channel,
      myId: myId,
      otherId: otherId,
      isTyping: isTyping,
    );
  }

  @override
  void disposeChannel(RealtimeChannel channel) {
    _datasource.disposeChannel(channel);
  }
}
