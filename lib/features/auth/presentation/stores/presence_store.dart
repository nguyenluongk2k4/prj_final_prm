import 'dart:async';

import 'package:injectable/injectable.dart';
import '../../domain/usecases/set_offline_usecase.dart';
import '../../domain/usecases/update_presence_usecase.dart';

@injectable
class PresenceStore {
  final UpdatePresenceUseCase _updatePresenceUseCase;
  final SetOfflineUseCase _setOfflineUseCase;

  Timer? _debounceTimer;
  DateTime _lastPing = DateTime.fromMillisecondsSinceEpoch(0);

  PresenceStore(this._updatePresenceUseCase, this._setOfflineUseCase);

  void schedulePing() {
    final now = DateTime.now();
    if (now.difference(_lastPing).inSeconds < 10) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      forcePing();
    });
  }

  Future<void> forcePing() async {
    final now = DateTime.now();
    if (now.difference(_lastPing).inSeconds < 10) return;
    _lastPing = now;
    try {
      await _updatePresenceUseCase.execute(lastActive: now);
    } catch (_) {}
  }

  Future<void> setOffline() async {
    final now = DateTime.now();
    try {
      await _setOfflineUseCase.execute(lastActive: now);
    } catch (_) {}
  }

  void dispose() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
}
