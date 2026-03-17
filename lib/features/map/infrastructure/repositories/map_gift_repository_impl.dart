import '../../domain/repositories/i_map_gift_repository.dart';
import '../datasources/map_gift_datasource.dart';

class MapGiftRepositoryImpl implements IMapGiftRepository {
  final MapGiftDataSource _dataSource;

  MapGiftRepositoryImpl(this._dataSource);

  @override
  Future<void> sendGift({
    required String receiverId,
    required String giftType,
    required double senderLat,
    required double senderLng,
    required double receiverLat,
    required double receiverLng,
  }) {
    return _dataSource.sendGift(
      receiverId: receiverId,
      giftType: giftType,
      senderLat: senderLat,
      senderLng: senderLng,
      receiverLat: receiverLat,
      receiverLng: receiverLng,
    );
  }
}
