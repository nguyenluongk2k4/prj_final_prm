import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/location_model.dart';

abstract class IMapRemoteDataSource {
  Future<void> updateMatchLocation({
    required String matchId,
    required double latitude,
    required double longitude,
  });
  Stream<List<LocationModel>> getMatchLocations(String matchId);
  Future<List<LocationModel>> getNearbyUsers({required double radius});
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  });
  Future<LocationModel> getCurrentLocation();
}

class MapRemoteDataSourceImpl implements IMapRemoteDataSource {
  final SupabaseClient _supabaseClient;

  MapRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<void> updateMatchLocation({
    required String matchId,
    required double latitude,
    required double longitude,
  }) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabaseClient.from('match_locations').upsert({
      'user_id': userId,
      'match_id': matchId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Stream<List<LocationModel>> getMatchLocations(String matchId) {
    return _supabaseClient
        .from('match_locations')
        .stream(primaryKey: ['user_id', 'match_id'])
        .eq('match_id', matchId)
        .map((data) => data.map((json) => LocationModel.fromJson(json)).toList());
  }

  @override
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabaseClient.from('user_locations').upsert({
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<LocationModel>> getNearbyUsers({required double radius}) async {
    try {
      // Note: This requires a custom RPC function in Supabase for geo-query
      // For now, returning empty list as a placeholder
      return [];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      return LocationModel(
        userId: 'current_user', // This should probably come from an auth service
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
