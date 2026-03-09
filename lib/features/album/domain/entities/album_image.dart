class AlbumImage {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime createdAt;

  const AlbumImage({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.createdAt,
  });
}
