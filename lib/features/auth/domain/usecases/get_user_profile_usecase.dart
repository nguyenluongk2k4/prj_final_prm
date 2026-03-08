import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetUserProfileUseCase {
  final AuthRepository _repository;

  GetUserProfileUseCase(this._repository);

  Future<Either<Failure, UserProfile>> execute(String userId) {
    return _repository.getUserProfile(userId);
  }
}
