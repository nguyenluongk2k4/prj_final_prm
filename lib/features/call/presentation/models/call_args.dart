class CallArgs {
  final String channelId;
  final String localUserId;
  final String remoteUserId;
  final String remoteName;
  final String? remoteAvatarUrl;
  final bool isVideo;
  final bool isIncoming;

  const CallArgs({
    required this.channelId,
    required this.localUserId,
    required this.remoteUserId,
    required this.remoteName,
    required this.remoteAvatarUrl,
    required this.isVideo,
    required this.isIncoming,
  });

  CallArgs copyWith({
    String? channelId,
    String? localUserId,
    String? remoteUserId,
    String? remoteName,
    String? remoteAvatarUrl,
    bool? isVideo,
    bool? isIncoming,
  }) {
    return CallArgs(
      channelId: channelId ?? this.channelId,
      localUserId: localUserId ?? this.localUserId,
      remoteUserId: remoteUserId ?? this.remoteUserId,
      remoteName: remoteName ?? this.remoteName,
      remoteAvatarUrl: remoteAvatarUrl ?? this.remoteAvatarUrl,
      isVideo: isVideo ?? this.isVideo,
      isIncoming: isIncoming ?? this.isIncoming,
    );
  }
}

String buildCallChannel(String firstUserId, String secondUserId) {
  final a = _sanitizeUserId(firstUserId);
  final b = _sanitizeUserId(secondUserId);
  final ordered = [a, b]..sort();
  final left = _shortId(ordered[0]);
  final right = _shortId(ordered[1]);
  final nonce = _shortNonce();
  return 'call_${left}_${right}_$nonce';
}

String _sanitizeUserId(String userId) {
  return userId.trim().replaceAll('-', '');
}

String _shortId(String value) {
  if (value.length <= 24) return value;
  return value.substring(0, 24);
}

String _shortNonce() {
  return DateTime.now().millisecondsSinceEpoch.toRadixString(36);
}
