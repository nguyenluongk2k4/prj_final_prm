import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';

class Match {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  final UserModel? otherUser; // The matched user (not current user)

  const Match({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    this.otherUser,
  });

  Match copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    DateTime? createdAt,
    UserModel? otherUser,
  }) {
    return Match(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      createdAt: createdAt ?? this.createdAt,
      otherUser: otherUser ?? this.otherUser,
    );
  }
}