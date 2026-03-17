import 'dart:convert';

class DiscoverFilter {
  final double? distanceKm;
  final int? ageMin;
  final int? ageMax;
  final String? targetGender; // 'male', 'female', or null for both

  const DiscoverFilter({
    this.distanceKm,
    this.ageMin,
    this.ageMax,
    this.targetGender,
  });

  factory DiscoverFilter.empty() => const DiscoverFilter();

  DiscoverFilter copyWith({
    double? distanceKm,
    int? ageMin,
    int? ageMax,
    String? targetGender,
  }) {
    return DiscoverFilter(
      distanceKm: distanceKm ?? this.distanceKm,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      targetGender: targetGender ?? this.targetGender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distanceKm': distanceKm,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'targetGender': targetGender,
    };
  }

  factory DiscoverFilter.fromJson(Map<String, dynamic> json) {
    return DiscoverFilter(
      distanceKm: json['distanceKm']?.toDouble(),
      ageMin: json['ageMin']?.toInt(),
      ageMax: json['ageMax']?.toInt(),
      targetGender: json['targetGender'] as String?,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory DiscoverFilter.fromJsonString(String jsonString) {
    return DiscoverFilter.fromJson(jsonDecode(jsonString));
  }
}
