import 'package:injectable/injectable.dart';
import '../repositories/chat_repository.dart';
import '../entities/chat_message.dart';
import '../entities/friend_profile.dart';
import '../repositories/friends_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class SendFirstMessageUseCase {
  final ChatRepository _chatRepository;
  final FriendsRepository _friendsRepository;

  SendFirstMessageUseCase(this._chatRepository, this._friendsRepository);

  Future<void> execute({
    required String receiverId,
    required String message,
  }) async {
    print('🚀 SendFirstMessageUseCase.execute called');
    print('📧 Receiver: $receiverId');
    print('💬 Message: $message');
    
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) {
      print('❌ User not logged in');
      throw Exception('User not logged in');
    }
    print('👤 Current user: $currentUserId');

    try {
      // 1. Check if friendship already exists
      print('🔍 Checking existing friendship between $currentUserId and $receiverId');
      final existingFriendship = await _friendsRepository.checkFriendship(
        myId: currentUserId,
        otherId: receiverId,
      );
      print('🔍 Existing friendship: $existingFriendship');

      // 2. Create or update friendship (from match to accepted)
      if (existingFriendship == null || existingFriendship == FriendStatus.pending) {
        print('👥 Creating/updating friend relationship to accepted...');
        await _friendsRepository.updateFriendStatus(
          swiperId: currentUserId,
          swipedId: receiverId,
          status: FriendStatus.accepted, // Since they matched, it's accepted
        );
        print('✅ Friend relationship created/updated to accepted');
      } else {
        print('👥 Friend relationship already accepted: $existingFriendship');
      }

      // 3. Send the message
      print('📤 Sending message to chat repository...');
      await _chatRepository.sendMessage(
        myId: currentUserId,
        otherId: receiverId,
        content: message,
        type: ChatMessageType.text,
      );
      print('✅ Message sent to chat repository');

      print('✅ SendFirstMessageUseCase completed successfully');
    } catch (e) {
      print('❌ Error in SendFirstMessageUseCase: $e');
      rethrow;
    }
  }
}