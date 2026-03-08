import '../../domain/entities/friend_profile.dart';
import '../../domain/repositories/friends_repository.dart';
import '../../infrastructure/datasources/friends_datasource.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FriendsRepository)
class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsDatasource _datasource;

  FriendsRepositoryImpl(this._datasource);

  @override
  Future<void> updateFriendStatus({
    required String swiperId,
    required String swipedId,
    required FriendStatus status,
  }) async {
    await _datasource.updateFriendStatus(
      swiperId: swiperId,
      swipedId: swipedId,
      status: status,
    );
  }

  @override
  Future<List<FriendProfile>> getFriends() async {
    return await _datasource.getFriends();
  }

  @override
  Stream<void> watchFriendsRealtime({required String myId}) {
    return _datasource.watchFriendsRealtime(myId: myId);
  }

  @override
  Future<FriendStatus?> checkFriendship({
    required String myId,
    required String otherId,
  }) async {
    return await _datasource.checkFriendship(myId: myId, otherId: otherId);
  }
}
