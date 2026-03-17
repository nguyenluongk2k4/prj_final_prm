import 'package:injectable/injectable.dart';
import '../repositories/match_repository.dart';

@injectable
class CheckMatchUseCase {
  final MatchRepository _repository;

  CheckMatchUseCase(this._repository);

  Future<bool> execute(String swipedUserId) async {
    return await _repository.checkForNewMatch(swipedUserId);
  }
}