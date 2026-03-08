import 'package:injectable/injectable.dart';
import '../repositories/friends_repository.dart';
import '../entities/friend_profile.dart';

@injectable
class CheckFriendshipUseCase {
  final FriendsRepository _repository;

  CheckFriendshipUseCase(this._repository);

  Future<FriendStatus?> execute({
    required String myId,
    required String otherId,
  }) {
    return _repository.checkFriendship(myId: myId, otherId: otherId);
  }
}
