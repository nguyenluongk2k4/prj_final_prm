import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/discover_repository.dart';

@Injectable(as: DiscoverRepository)
class DiscoverRepositoryImpl implements DiscoverRepository {
  final SupabaseClient _supabase;

  DiscoverRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<UserModel>> getDiscoverProfiles({
    required int limit,
    required int offset,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await _supabase.rpc(
      'get_discover_profiles',
      params: {
        'p_user_id': userId,
        'p_limit': limit,
        'p_offset': offset,
      },
    );

    // Cast the response to a List of maps
    final List<dynamic> data = response;
    
    // Map to UserModel
    return data.map((json) {
      // Handle the fact that preference array might be null or dynamic type
      Map<String, dynamic> map = Map<String, dynamic>.from(json);
      if (map['preferences'] != null) {
        map['preferences'] = List<String>.from(map['preferences']);
      }
      return UserModel.fromJson(map);
    }).toList();
  }

  @override
  Future<void> submitSwipe({
    required String swipedId,
    required bool isLike,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    await _supabase.from('swipes').insert({
      'swiper_id': userId,
      'swiped_id': swipedId,
      'is_like': isLike,
    });
  }
}
