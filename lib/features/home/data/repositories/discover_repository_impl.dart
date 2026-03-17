import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/discover_repository.dart';
import '../../domain/entities/swipe_type.dart' as domain;
import '../../domain/entities/discover_filter.dart';

@Injectable(as: DiscoverRepository)
class DiscoverRepositoryImpl implements DiscoverRepository {
  final SupabaseClient _supabase;

  DiscoverRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<UserModel>> getDiscoverProfiles({
    required int limit,
    required int offset,
    DiscoverFilter? filter,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final params = {
      'p_user_id': userId,
      'p_limit': limit,
      'p_offset': offset,
    };

    // Add filter parameters if provided
    if (filter != null) {
      if (filter.distanceKm != null) {
        params['p_distance_km'] = filter.distanceKm!;
      }
      if (filter.ageMin != null) {
        params['p_age_min'] = filter.ageMin!;
      }
      if (filter.ageMax != null) {
        params['p_age_max'] = filter.ageMax!;
      }
      if (filter.targetGender != null) {
        params['p_target_gender'] = filter.targetGender!;
      }
    }

    print('🔍 Calling get_discover_profiles_v2 with params: $params');

    try {
      final response = await _supabase.rpc(
        'get_discover_profiles_v2',
        params: params,
      );

      print('📊 Response received: ${response?.runtimeType} - Length: ${response is List ? response.length : 'N/A'}');
      print('📊 Response data: $response');

      // Cast the response to a List of maps
      final List<dynamic> data = response ?? [];
      
      print('📊 Processing ${data.length} profiles');
      
      // Map to UserModel
      final profiles = data.map((json) {
        // Handle the fact that preference array might be null or dynamic type
        Map<String, dynamic> map = Map<String, dynamic>.from(json);
        if (map['preferences'] != null) {
          map['preferences'] = List<String>.from(map['preferences']);
        }
        print('👤 Processing profile: ${map['name']} (${map['id']})');
        return UserModel.fromJson(map);
      }).toList();

      print('✅ Successfully processed ${profiles.length} profiles');
      return profiles;
    } catch (e, stackTrace) {
      print('❌ Error in getDiscoverProfiles: $e');
      print('📍 Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> submitSwipe({
    required String swipedId,
    required domain.SwipeType swipeType,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    await _supabase.from('swipes').insert({
      'swiper_id': userId,
      'swiped_id': swipedId,
      'is_like': swipeType == domain.SwipeType.like || swipeType == domain.SwipeType.superlike,
      'swipe_type': swipeType.toJson(),
    });
  }

  @override
  Future<void> undoSwipe({
    required String swipedId,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    await _supabase
        .from('swipes')
        .delete()
        .eq('swiper_id', userId)
        .eq('swiped_id', swipedId);
  }
}
