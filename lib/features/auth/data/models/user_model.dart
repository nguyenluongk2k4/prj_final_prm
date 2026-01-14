import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// Data Model - extends Domain Entity
/// Model chứa logic serialize/deserialize
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert Model to Entity
  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        avatar: avatar,
      );

  /// Convert Entity to Model
  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        avatar: user.avatar,
      );
}
