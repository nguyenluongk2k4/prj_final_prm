import 'package:injectable/injectable.dart';
import '../repositories/friends_repository.dart';

@injectable
class SubscribeFriendsRealtimeUseCase {
  final FriendsRepository _repository;

  SubscribeFriendsRealtimeUseCase(this._repository);

  Stream<void> execute({required String myId}) {
    return _repository.watchFriendsRealtime(myId: myId);
  }
}
