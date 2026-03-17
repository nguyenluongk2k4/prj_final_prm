class MapGiftEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String giftType;
  final double senderLat;
  final double senderLng;
  final int distanceMeters;
  final DateTime createdAt;

  const MapGiftEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.giftType,
    required this.senderLat,
    required this.senderLng,
    required this.distanceMeters,
    required this.createdAt,
  });
}
