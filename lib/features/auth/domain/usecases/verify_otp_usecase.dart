import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class VerifyOtpAndSyncProfileUseCase {
  final AuthRepository repository;

  VerifyOtpAndSyncProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call(String verificationId, String smsCode, String phoneNumber) async {
    final verifyResult = await repository.verifyOtp(verificationId, smsCode);
    
    final Either<Failure, UserProfile> finalResult = await verifyResult.fold(
      (failure) async => Left(failure),
      (uid) async => await repository.syncProfileToSupabase(uid, phoneNumber),
    );
    
    return finalResult;
  }
}
