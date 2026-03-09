import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/album_image.dart';

part 'album_image_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AlbumImageModel extends AlbumImage {
  AlbumImageModel({
    required super.id,
    required super.userId,
    required super.imageUrl,
    required super.createdAt,
  });

  factory AlbumImageModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumImageModelToJson(this);
}
