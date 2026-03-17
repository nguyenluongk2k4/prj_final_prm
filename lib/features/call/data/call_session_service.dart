import 'package:supabase_flutter/supabase_flutter.dart';

class CallSessionService {
  static final _supabase = Supabase.instance.client;

  static Future<void> updateStatus(String? sessionId, String status) async {
    if (sessionId == null || sessionId.isEmpty) return;
    try {
      final update = <String, dynamic>{'status': status};
      if (status == 'ended' || status == 'missed' || status == 'rejected') {
        update['ended_at'] = DateTime.now().toIso8601String();
      }
      await _supabase
          .from('call_sessions')
          .update(update)
          .eq('id', sessionId);
    } catch (_) {}
  }

  /// Lookup session id by channel name if not passed via args
  static Future<String?> findSessionId(String channelName) async {
    try {
      final row = await _supabase
          .from('call_sessions')
          .select('id')
          .eq('channel_name', channelName)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return row?['id']?.toString();
    } catch (_) {
      return null;
    }
  }
}
