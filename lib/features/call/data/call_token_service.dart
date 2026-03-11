import 'package:supabase_flutter/supabase_flutter.dart';

class CallTokenService {
  final SupabaseClient _supabase;

  CallTokenService(this._supabase);

  Future<String> fetchToken({
    required String channelId,
    required String userId,
    required bool isPublisher,
  }) async {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw StateError('Missing Supabase session for agora_token');
    }
    final response = await _supabase.functions.invoke(
      'agora_token',
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: {
        'channel': channelId,
        'userId': userId,
        'role': isPublisher ? 'publisher' : 'subscriber',
        'expireSeconds': 3600,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw StateError('Invalid Agora token response');
    }

    final token = data['token'];
    if (token is! String || token.isEmpty) {
      throw StateError('Agora token missing');
    }

    return token;
  }
}
