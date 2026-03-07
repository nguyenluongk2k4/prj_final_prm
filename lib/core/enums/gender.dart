enum Gender {
  male,
  female,
  other,
  both; // 'both' is used for target_gender preference

  String get value => name;

  static Gender? fromString(String? value) {
    if (value == null) return null;
    return Gender.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => Gender.other,
    );
  }
}
