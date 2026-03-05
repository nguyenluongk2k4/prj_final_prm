import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

/// fieldRename.snake: tự động map camelCase → snake_case (khớp với Supabase)
@JsonSerializable(fieldRename: FieldRename.snake)
class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.id,
    required super.displayName,
    super.bio,
    super.gender,
    super.targetGender,
    super.birthDate,
    super.avatarUrl,
    super.isOnline = false,
    required super.lastActive,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
