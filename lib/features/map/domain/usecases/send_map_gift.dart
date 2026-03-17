import '../repositories/i_map_gift_repository.dart';

class SendMapGift {
  final IMapGiftRepository repository;

  const SendMapGift(this.repository);

  Future<void> call({
    required String receiverId,
    required String giftType,
    required double senderLat,
    required double senderLng,
    required double receiverLat,
    required double receiverLng,
  }) {
    return repository.sendGift(
      receiverId: receiverId,
      giftType: giftType,
      senderLat: senderLat,
      senderLng: senderLng,
      receiverLat: receiverLat,
      receiverLng: receiverLng,
    );
  }
}
