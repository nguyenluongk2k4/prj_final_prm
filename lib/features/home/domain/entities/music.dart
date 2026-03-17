import 'package:freezed_annotation/freezed_annotation.dart';

part 'music.freezed.dart';
part 'music.g.dart';

@freezed
class SystemMusic with _$SystemMusic {
  const factory SystemMusic({
    required String id,
    required String title,
    String? artist,
    required String url,
    @JsonKey(name: 'duration_ms') int? durationMs,
  }) = _SystemMusic;

  factory SystemMusic.fromJson(Map<String, dynamic> json) => _$SystemMusicFromJson(json);
}
