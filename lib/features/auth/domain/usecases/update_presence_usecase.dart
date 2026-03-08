import 'package:injectable/injectable.dart';
import '../repositories/presence_repository.dart';

@injectable
class UpdatePresenceUseCase {
  final PresenceRepository _repository;

  UpdatePresenceUseCase(this._repository);

  Future<void> execute({DateTime? lastActive}) async {
    await _repository.updateCurrentUserPresence(
      isOnline: true,
      lastActive: lastActive,
    );
  }
}
