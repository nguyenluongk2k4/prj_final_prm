import 'package:equatable/equatable.dart';

/// Domain Entity - User
/// Entities là business objects, không phụ thuộc vào framework
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, email, name, avatar];
}
