import 'package:injectable/injectable.dart';
import '../repositories/presence_repository.dart';

@injectable
class SetOfflineUseCase {
  final PresenceRepository _repository;

  SetOfflineUseCase(this._repository);

  Future<void> execute({DateTime? lastActive}) async {
    await _repository.updateCurrentUserPresence(
      isOnline: false,
      lastActive: lastActive,
    );
  }
}
