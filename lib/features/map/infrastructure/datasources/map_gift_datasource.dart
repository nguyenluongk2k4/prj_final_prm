import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapGiftDataSource {
  final SupabaseClient _client;

  MapGiftDataSource(this._client);

  Future<void> sendGift({
    required String receiverId,
    required String giftType,
    required double senderLat,
    required double senderLng,
    required double receiverLat,
    required double receiverLng,
  }) async {
    final senderId = _client.auth.currentUser?.id;
    if (senderId == null) throw Exception('Not authenticated');

    final distanceMeters = _calcDistance(senderLat, senderLng, receiverLat, receiverLng);

    // Sort user IDs for the CHECK constraint (user1_id < user2_id)
    final ids = [senderId, receiverId]..sort();

    // Insert as a message with type 'gift'
    // content = "gift_emoji|distance_meters" so receiver can parse it
    await _client.from('messages').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'user1_id': ids[0],
      'user2_id': ids[1],
      'content': '$giftType|$distanceMeters',
      'message_type': 'gift',
    });
  }

  int _calcDistance(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    return (r * 2 * atan2(sqrt(a), sqrt(1 - a))).round();
  }

  double _toRad(double deg) => deg * pi / 180;
}
