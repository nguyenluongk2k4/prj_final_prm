class PreferencesConstants {
  /// Danh sách các sở thích/interests cung cấp
  static const List<PreferenceItem> allPreferences = [
    PreferenceItem(
      id: 'photography',
      translationKey: 'photography',
      iconAsset: 'camera',
    ),
    PreferenceItem(
      id: 'shopping',
      translationKey: 'shopping',
      iconAsset: 'shopping',
    ),
    PreferenceItem(
      id: 'karaoke',
      translationKey: 'karaoke',
      iconAsset: 'voice',
    ),
    PreferenceItem(
      id: 'yoga',
      translationKey: 'yoga',
      iconAsset: 'yoga',
    ),
    PreferenceItem(
      id: 'cooking',
      translationKey: 'cooking',
      iconAsset: 'noodles',
    ),
    PreferenceItem(
      id: 'tennis',
      translationKey: 'tennis',
      iconAsset: 'tennis',
    ),
    PreferenceItem(
      id: 'run',
      translationKey: 'run',
      iconAsset: 'sport',
    ),
    PreferenceItem(
      id: 'swimming',
      translationKey: 'swimming',
      iconAsset: 'ripple',
    ),
    PreferenceItem(
      id: 'art',
      translationKey: 'art',
      iconAsset: 'platte',
    ),
    PreferenceItem(
      id: 'traveling',
      translationKey: 'traveling',
      iconAsset: 'outdoor',
    ),
    PreferenceItem(
      id: 'extreme',
      translationKey: 'extreme',
      iconAsset: 'parachute',
    ),
    PreferenceItem(
      id: 'music',
      translationKey: 'music',
      iconAsset: 'music',
    ),
    PreferenceItem(
      id: 'drink',
      translationKey: 'drink',
      iconAsset: 'goblet',
    ),
    PreferenceItem(
      id: 'videoGames',
      translationKey: 'videoGames',
      iconAsset: 'gameHandle',
    ),
  ];

  /// Lấy preference item theo ID
  static PreferenceItem? getPreferenceById(String id) {
    try {
      return allPreferences.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Model cho một mục sở thích
class PreferenceItem {
  final String id;
  final String translationKey;
  final String iconAsset;

  const PreferenceItem({
    required this.id,
    required this.translationKey,
    required this.iconAsset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferenceItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
