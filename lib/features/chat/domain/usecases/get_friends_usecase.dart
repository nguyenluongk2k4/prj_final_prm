import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/friend_profile.dart';
import '../repositories/friends_repository.dart';

@injectable
class GetFriendsUseCase {
  final FriendsRepository _repository;

  GetFriendsUseCase(this._repository);

  Future<Either<String, List<FriendProfile>>> execute() async {
    try {
      final friends = await _repository.getFriends();
      return Right(friends);
    } catch (e) {
      return Left('Failed to fetch friends: ${e.toString()}');
    }
  }
}
