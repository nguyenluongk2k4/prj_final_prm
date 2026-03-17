import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/usecases/get_current_location.dart';
import '../domain/usecases/get_friend_ids.dart';
import '../domain/usecases/get_match_info.dart';
import '../domain/usecases/get_match_locations.dart';
import '../domain/usecases/get_map_profiles.dart';
import '../domain/usecases/get_nearby_users.dart';
import '../domain/usecases/stream_match_locations.dart';
import '../domain/usecases/stream_user_locations.dart';
import '../domain/usecases/update_location.dart';
import '../domain/usecases/update_match_location.dart';
import '../presentation/stores/map_store.dart';
import 'datasources/map_remote_data_source.dart';
import 'datasources/map_social_remote_data_source.dart';
import 'repositories/map_repository_impl.dart';
import 'repositories/map_social_repository_impl.dart';

class MapStoreFactory {
  static MapStore create() {
    final client = Supabase.instance.client;
    final remoteDataSource = MapRemoteDataSourceImpl(client);
    final repository = MapRepositoryImpl(remoteDataSource);

    final socialRemoteDataSource = MapSocialRemoteDataSourceImpl(client);
    final socialRepository = MapSocialRepositoryImpl(socialRemoteDataSource);

    return MapStore(
      GetMatchLocations(repository),
      UpdateMatchLocation(repository),
      GetCurrentLocation(repository),
      GetNearbyUsers(repository),
      UpdateLocation(repository),
      GetFriendIds(socialRepository),
      GetMatchInfo(socialRepository),
      GetMapProfiles(socialRepository),
      StreamUserLocations(socialRepository),
      StreamMatchLocations(socialRepository),
    );
  }
}
