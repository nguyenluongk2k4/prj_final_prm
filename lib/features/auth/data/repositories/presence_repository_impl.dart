import 'package:injectable/injectable.dart';
import '../../domain/repositories/presence_repository.dart';
import '../../infrastructure/datasources/presence_datasource.dart';

@Injectable(as: PresenceRepository)
class PresenceRepositoryImpl implements PresenceRepository {
  final PresenceDatasource _datasource;

  PresenceRepositoryImpl(this._datasource);

  @override
  Future<void> updateCurrentUserPresence({
    required bool isOnline,
    DateTime? lastActive,
  }) async {
    await _datasource.updateCurrentUserPresence(
      isOnline: isOnline,
      lastActive: lastActive,
    );
  }
}
