import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignInWithPhoneUseCase {
  final AuthRepository repository;

  SignInWithPhoneUseCase(this.repository);

  Future<Either<Failure, String>> call(String phoneNumber) {
    return repository.signInWithPhone(phoneNumber);
  }
}
