import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  final String id; // UUID từ Supabase Auth
  final String email;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  final List<String>? preferences; // Sở thích: danh sách tên preferences
  final String? gender;
  final String? targetGender; // Tìm kiếm giới tính nào
  final String? bio;
  final DateTime? birthDate;
  final int? provinceId;
  final double? latitude;
  final double? longitude;
  final bool isOnline;
  final DateTime? lastActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.avatarUrl,
    this.preferences,
    this.gender,
    this.targetGender,
    this.bio,
    this.birthDate,
    this.provinceId,
    this.latitude,
    this.longitude,
    this.isOnline = false,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatarUrl,
    List<String>? preferences,
    String? gender,
    String? targetGender,
    String? bio,
    DateTime? birthDate,
    int? provinceId,
    double? latitude,
    double? longitude,
    bool? isOnline,
    DateTime? lastActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
    id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferences: preferences ?? this.preferences,
      gender: gender ?? this.gender,
      targetGender: targetGender ?? this.targetGender,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      provinceId: provinceId ?? this.provinceId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
