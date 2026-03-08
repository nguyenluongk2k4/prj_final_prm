import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_profile_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final supabase.SupabaseClient _supabaseClient;
  
  // Dùng completer để đợi kết quả trả về từ Firebase verifyPhoneNumber callbacks
  Completer<Either<Failure, String>>? _phoneAuthCompleter;

  AuthRepositoryImpl(this._firebaseAuth, this._supabaseClient);

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<Either<Failure, String>> signInWithPhone(String phoneNumber) async {
    _phoneAuthCompleter = Completer<Either<Failure, String>>();
    
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Chỉ xảy ra tự động trên một số dòng Android hoặc test số đt ảo
          try {
            await _firebaseAuth.signInWithCredential(credential);
            // Có thể bỏ qua Completer nếu không cần xử lý luồng này
          } catch (e) {
            if (!_phoneAuthCompleter!.isCompleted) {
              _phoneAuthCompleter!.complete(Left(ServerFailure(message: e.toString())));
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!_phoneAuthCompleter!.isCompleted) {
            _phoneAuthCompleter!.complete(Left(ServerFailure(message: e.message ?? 'Verification Failed')));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          // Thành công gửi mã đi, trả về ID để user nhập SMS
          if (!_phoneAuthCompleter!.isCompleted) {
            _phoneAuthCompleter!.complete(Right(verificationId));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout
        },
      );
      
      return await _phoneAuthCompleter!.future;
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        return Right(userCredential.user!.uid);
      } else {
        return Left(ServerFailure(message: "Cannot retrieve user from Firebase."));
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(message: e.message ?? "Invalid OTP"));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      // Đánh dấu offline trên DB nếu có current user
      if (uid != null) {
         try {
           await _supabaseClient.from('profiles').update({'is_online': false}).eq('user_id', uid);
         } catch(_) {}
      }
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> syncProfileToSupabase(String uid, String phoneNumber) async {
    try {
      // 1. Kiểm tra xem profile đã có trong Postgres chưa?
      final response = await _supabaseClient.from('profiles').select().eq('user_id', uid).maybeSingle();
      
      if (response != null) {
        // Đã có -> set trạng thái online
        final updatedData = await _supabaseClient.from('profiles').update({
          'is_online': true,
          'last_active': DateTime.now().toIso8601String()
        }).eq('user_id', uid).select().single();
        
        return Right(UserProfileModel.fromJson(updatedData));
      } else {
        // 2. Nếu chưa có -> Tạo (Upsert) user mới
        final newProfile = UserProfileModel(
          id: uid, 
          displayName: "User ${phoneNumber.substring(phoneNumber.length - 4)}", // Tên mặc định tạm thời 
          lastActive: DateTime.now(),
          isOnline: true,
        );
        
        final insertedData = await _supabaseClient
            .from('profiles')
            .upsert(newProfile.toJson())
            .select()
            .single();
            
        return Right(UserProfileModel.fromJson(insertedData));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getCurrentProfile() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(ServerFailure(message: "Bấm đăng nhập trước khi gọi API này."));
      }
      final response = await _supabaseClient.from('profiles').select().eq('user_id', user.uid).maybeSingle();
      if (response == null) {
        return Left(ServerFailure(message: "Không tìm thấy profile cho user hiện tại."));
      }
      return Right(UserProfileModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      if (userCredential.user != null) {
        return syncProfileToSupabase(userCredential.user!.uid, "");
      } else {
        return Left(ServerFailure(message: "Không thể lấy thông tin user từ Firebase."));
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(message: e.message ?? "Đăng nhập thất bại"));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
    try {
      final profileResponse = await _supabaseClient.from('profiles').select().eq('user_id', userId).maybeSingle();
      
      if (profileResponse == null) {
        return Left(ServerFailure(message: "Không tìm thấy thông tin profile cho user này."));
      }
      
      // Fetch interests from user_preferences table
      final prefsResponse = await _supabaseClient
          .from('user_preferences')
          .select('preference_id')
          .eq('user_id', userId);
      
      final List<String> interests = (prefsResponse as List)
          .map((p) => p['preference_id'] as String)
          .toList();

      final Map<String, dynamic> data = Map<String, dynamic>.from(profileResponse);
      data['interests'] = interests;
      
      return Right(UserProfileModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
