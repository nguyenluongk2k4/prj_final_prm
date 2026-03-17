import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_match_locations.dart';
import '../../domain/usecases/update_match_location.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/get_nearby_users.dart';
import '../../domain/usecases/update_location.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/map_profile_entity.dart';
import '../../domain/entities/match_info_entity.dart';
import '../../domain/entities/map_realtime_context.dart';
import '../../domain/usecases/get_friend_ids.dart';
import '../../domain/usecases/get_match_info.dart';
import '../../domain/usecases/get_map_profiles.dart';
import '../../domain/usecases/stream_match_locations.dart';
import '../../domain/usecases/stream_user_locations.dart';

part 'map_store.g.dart';

class MapStore = _MapStoreBase with _$MapStore;

abstract class _MapStoreBase with Store {
  final GetMatchLocations _getMatchLocations;
  final UpdateMatchLocation _updateMatchLocation;
  final GetCurrentLocation _getCurrentLocation;
  final GetNearbyUsers _getNearbyUsers;
  final UpdateLocation _updateLocation;
  final GetFriendIds _getFriendIds;
  final GetMatchInfo _getMatchInfo;
  final GetMapProfiles _getMapProfiles;
  final StreamUserLocations _streamUserLocations;
  final StreamMatchLocations _streamMatchLocations;

  _MapStoreBase(
    this._getMatchLocations,
    this._updateMatchLocation,
    this._getCurrentLocation,
    this._getNearbyUsers,
    this._updateLocation,
    this._getFriendIds,
    this._getMatchInfo,
    this._getMapProfiles,
    this._streamUserLocations,
    this._streamMatchLocations,
  );

  @observable
  ObservableList<LocationEntity> matchLocations = ObservableList<LocationEntity>();

  @observable
  LatLng? currentLocation;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<LocationEntity> nearbyUsers = ObservableList<LocationEntity>();

  @action
  Future<void> fetchCurrentLocation() async {
    isLoading = true;
    errorMessage = null;

    final result = await _getCurrentLocation(const NoParams());

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (location) {
        currentLocation = LatLng(location.latitude, location.longitude);
        isLoading = false;
      },
    );
  }

  @action
  Future<void> fetchNearbyUsers(double radius) async {
    isLoading = true;
    errorMessage = null;

    final result = await _getNearbyUsers(radius);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (users) {
        nearbyUsers.clear();
        nearbyUsers.addAll(users);
        isLoading = false;
      },
    );
  }

  @action
  Future<void> updateUserLocation(double latitude, double longitude) async {
    final result = await _updateLocation(
      UpdateLocationParams(latitude: latitude, longitude: longitude),
    );

    result.fold(
      (failure) => errorMessage = failure.message,
      (_) => null,
    );
  }

  @action
  void subscribeToMatchLocations(String matchId) {
    _getMatchLocations(matchId).listen((result) {
      result.fold(
        (failure) => errorMessage = failure.message,
        (locations) {
          matchLocations.clear();
          matchLocations.addAll(locations);
        },
      );
    });
  }

  @action
  Future<void> updateMatchLocation({
    required String matchId,
    required double latitude,
    required double longitude,
  }) async {
    final result = await _updateMatchLocation(
      UpdateMatchLocationParams(
        matchId: matchId,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    result.fold(
      (failure) => errorMessage = failure.message,
      (_) => null,
    );
  }

  Future<MapRealtimeContext?> loadRealtimeContext(String userId) async {
    runInAction(() => errorMessage = null);

    final friendsResult = await _getFriendIds(userId);
    Set<String>? friends;
    friendsResult.fold(
      (failure) => runInAction(() => errorMessage = failure.message),
      (data) => friends = data,
    );
    if (friends == null) return null;

    final matchResult = await _getMatchInfo(userId);
    MatchInfoEntity? matchInfo;
    matchResult.fold(
      (failure) => runInAction(() => errorMessage = failure.message),
      (data) => matchInfo = data,
    );
    if (matchInfo == null) return null;

    final ids = <String>{...friends!, ...matchInfo!.userIds};
    final profilesResult = await _getMapProfiles(
      GetMapProfilesParams(
        ids: ids,
        friendIds: friends!,
        matchUserIds: matchInfo!.userIds,
      ),
    );
    List<MapProfileEntity>? profiles;
    profilesResult.fold(
      (failure) => runInAction(() => errorMessage = failure.message),
      (data) => profiles = data,
    );
    if (profiles == null) return null;

    return MapRealtimeContext(
      friendIds: friends!,
      matchInfo: matchInfo!,
      profiles: profiles!,
    );
  }

  Stream<List<LocationEntity>> watchUserLocations(Set<String> userIds) {
    return _streamUserLocations(userIds).map((result) {
      return result.fold(
        (failure) {
          runInAction(() => errorMessage = failure.message);
          return <LocationEntity>[];
        },
        (locations) => locations,
      );
    });
  }

  Stream<List<LocationEntity>> watchMatchLocations(Set<String> matchIds) {
    return _streamMatchLocations(matchIds).map((result) {
      return result.fold(
        (failure) {
          runInAction(() => errorMessage = failure.message);
          return <LocationEntity>[];
        },
        (locations) => locations,
      );
    });
  }
}
