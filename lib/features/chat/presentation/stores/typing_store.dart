import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/usecases/create_typing_channel_usecase.dart';
import '../../domain/usecases/dispose_typing_channel_usecase.dart';
import '../../domain/usecases/send_typing_usecase.dart';
import '../../domain/usecases/subscribe_typing_usecase.dart';

part 'typing_store.g.dart';

@injectable
class TypingStore = _TypingStore with _$TypingStore;

abstract class _TypingStore with Store {
  final CreateTypingChannelUseCase _createChannelUseCase;
  final SubscribeTypingUseCase _subscribeTypingUseCase;
  final SendTypingUseCase _sendTypingUseCase;
  final DisposeTypingChannelUseCase _disposeChannelUseCase;

  RealtimeChannel? _channel;
  StreamSubscription<bool>? _typingSub;
  Timer? _typingTimer;
  DateTime _lastPing = DateTime.fromMillisecondsSinceEpoch(0);
  String? _myId;
  String? _otherId;

  _TypingStore(
    this._createChannelUseCase,
    this._subscribeTypingUseCase,
    this._sendTypingUseCase,
    this._disposeChannelUseCase,
  );

  @observable
  bool isOtherTyping = false;

  void init({required String myId, required String otherId}) {
    if (kDebugMode) {
      debugPrint('[TypingStore] init $myId <-> $otherId');
    }
    _myId = myId;
    _otherId = otherId;
    _channel = _createChannelUseCase.execute(myId: myId, otherId: otherId);
    _typingSub?.cancel();
    _typingSub = _subscribeTypingUseCase
        .execute(channel: _channel!, myId: myId, otherId: otherId)
        .listen((value) {
      if (kDebugMode) {
        debugPrint('[TypingStore] other typing: $value');
      }
      isOtherTyping = value;
    });
  }

  void scheduleTypingPing(bool hasText) {
    if (_channel == null || _myId == null || _otherId == null) return;
    if (kDebugMode) {
      debugPrint('[TypingStore] scheduleTypingPing hasText=$hasText');
    }
    _typingTimer?.cancel();
    if (hasText) {
      _sendTyping(true);
      _typingTimer = Timer(const Duration(seconds: 2), () {
        _sendTyping(false);
      });
    } else {
      _sendTyping(false);
    }
  }

  Future<void> sendTypingNow(bool isTyping) async {
    if (kDebugMode) {
      debugPrint('[TypingStore] sendTypingNow isTyping=$isTyping');
    }
    await _sendTyping(isTyping);
  }

  Future<void> _sendTyping(bool isTyping) async {
    if (_channel == null || _myId == null || _otherId == null) return;
    final now = DateTime.now();
    if (now.difference(_lastPing).inMilliseconds < 800 && isTyping) return;
    _lastPing = now;
    try {
      if (kDebugMode) {
        debugPrint(
          '[TypingStore] _sendTyping $_myId -> $_otherId, isTyping=$isTyping',
        );
      }
      await _sendTypingUseCase.execute(
        channel: _channel!,
        myId: _myId!,
        otherId: _otherId!,
        isTyping: isTyping,
      );
    } catch (_) {}
  }

  void dispose() {
    if (kDebugMode) {
      debugPrint('[TypingStore] dispose');
    }
    _typingTimer?.cancel();
    _typingSub?.cancel();
    if (_channel != null) {
      _disposeChannelUseCase.execute(_channel!);
    }
    _channel = null;
  }
}
