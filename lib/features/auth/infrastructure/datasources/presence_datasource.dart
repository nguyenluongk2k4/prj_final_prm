import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class PresenceDatasource {
  final SupabaseClient _supabase;

  PresenceDatasource(this._supabase);

  Future<void> updateCurrentUserPresence({
    required bool isOnline,
    DateTime? lastActive,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('profiles').update({
      'is_online': isOnline,
      'last_active': (lastActive ?? DateTime.now()).toIso8601String(),
    }).eq('user_id', userId);
  }
}
