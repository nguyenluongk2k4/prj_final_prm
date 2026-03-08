abstract class PresenceRepository {
  Future<void> updateCurrentUserPresence({
    required bool isOnline,
    DateTime? lastActive,
  });
}
