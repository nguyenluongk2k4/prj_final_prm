enum SwipeType {
  like,
  dislike,
  superlike;

  String toJson() => name;

  static SwipeType fromJson(String value) {
    return SwipeType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SwipeType.like,
    );
  }
}
