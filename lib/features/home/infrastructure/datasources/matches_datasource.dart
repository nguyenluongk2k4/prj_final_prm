import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/match_profile.dart';

class MatchesDatasource {
  final SupabaseClient _supabase;

  MatchesDatasource(this._supabase);

  Future<List<MatchProfile>> getMatches() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return [];

    // Lấy matches của user hiện tại (chỉ lấy những match đang pending)
    final response = await _supabase
        .from('matches')
        .select('*, user1:user1_id(id, name, avatar_url, created_at), user2:user2_id(id, name, avatar_url, created_at)')
        .eq('status', MatchStatus.pending.name)
        .or('user1_id.eq.${currentUser.id},user2_id.eq.${currentUser.id}')
        .order('created_at', ascending: false);

    final List<MatchProfile> matches = [];

    for (var match in response) {
      // Find out which user is the OTHER user
      final user1 = match['user1'];
      final user2 = match['user2'];
      
      final isUser1Me = user1 != null && user1['id'] == currentUser.id;
      final otherUser = isUser1Me ? user2 : user1;

      if (otherUser != null) {
        matches.add(
          MatchProfile(
            id: otherUser['id'],
            name: otherUser['name'] ?? 'Unknown',
            age: 20, // Hardcoded or default since we don't query public.profiles yet
            avatarUrl: otherUser['avatar_url'],
            matchedAt: DateTime.parse(match['created_at']),
            status: MatchStatus.values.firstWhere(
              (e) => e.name == match['status'],
              orElse: () => MatchStatus.pending,
            ),
          )
        );
      }
    }

    return matches;
  }
}
