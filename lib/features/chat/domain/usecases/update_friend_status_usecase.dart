import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/friend_profile.dart';
import '../repositories/friends_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class UpdateFriendStatusUseCase {
  final FriendsRepository _repository;
  final SupabaseClient _supabase;

  UpdateFriendStatusUseCase(this._repository) : _supabase = Supabase.instance.client;

  Future<Either<String, void>> execute({
    required String swipedId,
    required FriendStatus status,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        return const Left('User not logged in');
      }

      await _repository.updateFriendStatus(
        swiperId: currentUser.id,
        swipedId: swipedId,
        status: status,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to update friend status: ${e.toString()}');
    }
  }
}
