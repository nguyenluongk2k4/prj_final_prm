import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';

abstract class AuthRepository {
  /// Check if the current user is authenticated via Firebase
  Future<bool> isAuthenticated();

  /// Sign in with Phone Number
  /// Returns a verification ID that needs to be verified with an OTP
  Future<Either<Failure, String>> signInWithPhone(String phoneNumber);

  /// Verify OTP
  Future<Either<Failure, String>> verifyOtp(String verificationId, String smsCode);

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Sync User profile to Supabase after successful login
  Future<Either<Failure, UserProfile>> syncProfileToSupabase(String uid, String phoneNumber);

  /// Get Current User Profile from Supabase
  Future<Either<Failure, UserProfile>> getCurrentProfile();

  /// Đăng nhập bằng Email/Password
  Future<Either<Failure, UserProfile>> login(String email, String password);
}
