enum MatchStatus {
  pending,
  accepted,
  rejected,
}

class MatchProfile {
  final String id;
  final String name;
  final int age;
  final String? imagePath;
  final String? avatarUrl;
  final DateTime matchedAt;
  final MatchStatus status;

  const MatchProfile({
    required this.id,
    required this.name,
    required this.age,
    this.imagePath,
    this.avatarUrl,
    required this.matchedAt,
    required this.status,
  });
}
