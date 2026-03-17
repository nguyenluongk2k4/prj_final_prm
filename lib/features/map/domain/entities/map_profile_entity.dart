import 'map_relation.dart';

class MapProfileEntity {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final bool isOnline;
  final DateTime? lastActive;
  final MapRelation relation;

  const MapProfileEntity({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.isOnline,
    required this.lastActive,
    required this.relation,
  });
}
