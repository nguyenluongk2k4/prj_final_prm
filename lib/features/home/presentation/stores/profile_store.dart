import 'dart:math';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:prj_final_prm/features/auth/presentation/stores/auth_store.dart';
import 'package:prj_final_prm/features/auth/domain/entities/user_profile.dart';
import 'package:prj_final_prm/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:prj_final_prm/features/chat/domain/entities/friend_profile.dart';
import 'package:prj_final_prm/features/chat/domain/usecases/check_friendship_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prj_final_prm/features/album/domain/entities/album_image.dart';
import 'package:prj_final_prm/features/album/domain/repositories/album_repository.dart';

part 'profile_store.g.dart';

@injectable
class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final GetUserProfileUseCase _getUserProfile;
  final CheckFriendshipUseCase _checkFriendship;
  final SupabaseClient _supabase;
  final IAlbumRepository _albumRepository;
  final AuthStore _authStore;

  _ProfileStore(
    this._getUserProfile, 
    this._checkFriendship, 
    this._supabase, 
    this._albumRepository,
    this._authStore,
  );

  @observable
  bool isLoading = false;

  @observable
  ObservableList<AlbumImage> albumImages = ObservableList<AlbumImage>();

  @observable
  String? error;

  @observable
  UserProfile? profile;

  @observable
  FriendStatus? friendStatus;

  @computed
  bool get isMe {
    final myId = _supabase.auth.currentUser?.id;
    return profile?.userId == myId;
  }

  @computed
  bool get hasRelationship {
    return friendStatus != null && friendStatus != FriendStatus.rejected;
  }

  @computed
  bool get showActions {
    return !isMe && !hasRelationship;
  }

  @computed
  String get provinceName {
    final pid = profile?.provinceId;
    if (pid == null) return 'Unknown';
    
    try {
      final province = _authStore.provinces.firstWhere((p) => p.id == pid);
      return province.name;
    } catch (_) {
      return 'Unknown';
    }
  }

  @computed
  double? get distanceKm {
    final myLat = _authStore.currentUser?.latitude;
    final myLon = _authStore.currentUser?.longitude;
    final otherLat = profile?.latitude;
    final otherLon = profile?.longitude;

    if (myLat == null || myLon == null || otherLat == null || otherLon == null) {
      return null;
    }

    if (isMe) return 0;

    return _calculateDistance(myLat, myLon, otherLat, otherLon);
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @action
  Future<void> fetchProfile(String userId) async {
    isLoading = true;
    error = null;
    profile = null;
    friendStatus = null;

    final profileResult = await _getUserProfile.execute(userId);
    
    profileResult.fold(
      (failure) {
        error = failure.toString();
        isLoading = false;
      },
      (userProfile) async {
        FriendStatus? status;
        
        // Only check friendship if it's not me
        final myId = _supabase.auth.currentUser?.id;
        final otherUserId = userProfile.userId;
        if (myId != null && otherUserId != null && myId != otherUserId) {
          status = await _checkFriendship.execute(
            myId: myId,
            otherId: otherUserId,
          );
        }

        runInAction(() {
          profile = userProfile;
          friendStatus = status;
          isLoading = false;
        });

        // Fetch album images separately
        if (otherUserId != null) {
          final albumResult = await _albumRepository.getUserAlbumImages(otherUserId);
          albumResult.fold(
            (l) => null,
            (images) => runInAction(() => albumImages = ObservableList.of(images)),
          );
        }
      },
    );
  }
}
