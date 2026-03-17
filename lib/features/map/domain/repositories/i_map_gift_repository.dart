abstract class IMapGiftRepository {
  Future<void> sendGift({
    required String receiverId,
    required String giftType,
    required double senderLat,
    required double senderLng,
    required double receiverLat,
    required double receiverLng,
  });
}
