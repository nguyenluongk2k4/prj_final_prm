import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:prj_final_prm/features/auth/domain/entities/user_profile.dart';
import 'package:prj_final_prm/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:prj_final_prm/features/chat/domain/entities/friend_profile.dart';
import 'package:prj_final_prm/features/chat/domain/usecases/check_friendship_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_store.g.dart';

@injectable
class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final GetUserProfileUseCase _getUserProfile;
  final CheckFriendshipUseCase _checkFriendship;
  final SupabaseClient _supabase;

  _ProfileStore(this._getUserProfile, this._checkFriendship, this._supabase);

  @observable
  bool isLoading = false;

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
      },
    );
  }
}
