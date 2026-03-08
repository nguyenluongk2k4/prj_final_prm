import '../entities/friend_profile.dart';

abstract class FriendsRepository {
  Future<void> updateFriendStatus({
    required String swiperId,
    required String swipedId,
    required FriendStatus status,
  });

  Future<List<FriendProfile>> getFriends();

  Stream<void> watchFriendsRealtime({required String myId});

  Future<FriendStatus?> checkFriendship({
    required String myId,
    required String otherId,
  });
}
