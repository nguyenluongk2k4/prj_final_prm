// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reels_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReelsStore on _ReelsStore, Store {
  late final _$feedTypeAtom = Atom(
    name: '_ReelsStore.feedType',
    context: context,
  );

  @override
  ReelsFeedType get feedType {
    _$feedTypeAtom.reportRead();
    return super.feedType;
  }

  @override
  set feedType(ReelsFeedType value) {
    _$feedTypeAtom.reportWrite(value, super.feedType, () {
      super.feedType = value;
    });
  }

  late final _$reelsAtom = Atom(name: '_ReelsStore.reels', context: context);

  @override
  ObservableList<Reel> get reels {
    _$reelsAtom.reportRead();
    return super.reels;
  }

  @override
  set reels(ObservableList<Reel> value) {
    _$reelsAtom.reportWrite(value, super.reels, () {
      super.reels = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_ReelsStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_ReelsStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$currentIndexAtom = Atom(
    name: '_ReelsStore.currentIndex',
    context: context,
  );

  @override
  int get currentIndex {
    _$currentIndexAtom.reportRead();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.reportWrite(value, super.currentIndex, () {
      super.currentIndex = value;
    });
  }

  late final _$pickedVideoPathAtom = Atom(
    name: '_ReelsStore.pickedVideoPath',
    context: context,
  );

  @override
  String? get pickedVideoPath {
    _$pickedVideoPathAtom.reportRead();
    return super.pickedVideoPath;
  }

  @override
  set pickedVideoPath(String? value) {
    _$pickedVideoPathAtom.reportWrite(value, super.pickedVideoPath, () {
      super.pickedVideoPath = value;
    });
  }

  late final _$isUploadingAtom = Atom(
    name: '_ReelsStore.isUploading',
    context: context,
  );

  @override
  bool get isUploading {
    _$isUploadingAtom.reportRead();
    return super.isUploading;
  }

  @override
  set isUploading(bool value) {
    _$isUploadingAtom.reportWrite(value, super.isUploading, () {
      super.isUploading = value;
    });
  }

  late final _$uploadProgressAtom = Atom(
    name: '_ReelsStore.uploadProgress',
    context: context,
  );

  @override
  double get uploadProgress {
    _$uploadProgressAtom.reportRead();
    return super.uploadProgress;
  }

  @override
  set uploadProgress(double value) {
    _$uploadProgressAtom.reportWrite(value, super.uploadProgress, () {
      super.uploadProgress = value;
    });
  }

  late final _$commentsAtom = Atom(
    name: '_ReelsStore.comments',
    context: context,
  );

  @override
  ObservableList<ReelComment> get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(ObservableList<ReelComment> value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  late final _$isCommentsLoadingAtom = Atom(
    name: '_ReelsStore.isCommentsLoading',
    context: context,
  );

  @override
  bool get isCommentsLoading {
    _$isCommentsLoadingAtom.reportRead();
    return super.isCommentsLoading;
  }

  @override
  set isCommentsLoading(bool value) {
    _$isCommentsLoadingAtom.reportWrite(value, super.isCommentsLoading, () {
      super.isCommentsLoading = value;
    });
  }

  late final _$systemMusicListAtom = Atom(
    name: '_ReelsStore.systemMusicList',
    context: context,
  );

  @override
  ObservableList<SystemMusic> get systemMusicList {
    _$systemMusicListAtom.reportRead();
    return super.systemMusicList;
  }

  @override
  set systemMusicList(ObservableList<SystemMusic> value) {
    _$systemMusicListAtom.reportWrite(value, super.systemMusicList, () {
      super.systemMusicList = value;
    });
  }

  late final _$selectedMusicAtom = Atom(
    name: '_ReelsStore.selectedMusic',
    context: context,
  );

  @override
  SystemMusic? get selectedMusic {
    _$selectedMusicAtom.reportRead();
    return super.selectedMusic;
  }

  @override
  set selectedMusic(SystemMusic? value) {
    _$selectedMusicAtom.reportWrite(value, super.selectedMusic, () {
      super.selectedMusic = value;
    });
  }

  late final _$isMusicLoadingAtom = Atom(
    name: '_ReelsStore.isMusicLoading',
    context: context,
  );

  @override
  bool get isMusicLoading {
    _$isMusicLoadingAtom.reportRead();
    return super.isMusicLoading;
  }

  @override
  set isMusicLoading(bool value) {
    _$isMusicLoadingAtom.reportWrite(value, super.isMusicLoading, () {
      super.isMusicLoading = value;
    });
  }

  late final _$currentActiveReelIdAtom = Atom(
    name: '_ReelsStore.currentActiveReelId',
    context: context,
  );

  @override
  String? get currentActiveReelId {
    _$currentActiveReelIdAtom.reportRead();
    return super.currentActiveReelId;
  }

  @override
  set currentActiveReelId(String? value) {
    _$currentActiveReelIdAtom.reportWrite(value, super.currentActiveReelId, () {
      super.currentActiveReelId = value;
    });
  }

  late final _$reelMusicMapAtom = Atom(
    name: '_ReelsStore.reelMusicMap',
    context: context,
  );

  @override
  ObservableMap<String, String> get reelMusicMap {
    _$reelMusicMapAtom.reportRead();
    return super.reelMusicMap;
  }

  @override
  set reelMusicMap(ObservableMap<String, String> value) {
    _$reelMusicMapAtom.reportWrite(value, super.reelMusicMap, () {
      super.reelMusicMap = value;
    });
  }

  late final _$isReelsPageVisibleAtom = Atom(
    name: '_ReelsStore.isReelsPageVisible',
    context: context,
  );

  @override
  bool get isReelsPageVisible {
    _$isReelsPageVisibleAtom.reportRead();
    return super.isReelsPageVisible;
  }

  @override
  set isReelsPageVisible(bool value) {
    _$isReelsPageVisibleAtom.reportWrite(value, super.isReelsPageVisible, () {
      super.isReelsPageVisible = value;
    });
  }

  late final _$pickedImagePathAtom = Atom(
    name: '_ReelsStore.pickedImagePath',
    context: context,
  );

  @override
  String? get pickedImagePath {
    _$pickedImagePathAtom.reportRead();
    return super.pickedImagePath;
  }

  @override
  set pickedImagePath(String? value) {
    _$pickedImagePathAtom.reportWrite(value, super.pickedImagePath, () {
      super.pickedImagePath = value;
    });
  }

  late final _$playReelAudioAsyncAction = AsyncAction(
    '_ReelsStore.playReelAudio',
    context: context,
  );

  @override
  Future<void> playReelAudio(String url, String reelId) {
    return _$playReelAudioAsyncAction.run(
      () => super.playReelAudio(url, reelId),
    );
  }

  late final _$stopAudioAsyncAction = AsyncAction(
    '_ReelsStore.stopAudio',
    context: context,
  );

  @override
  Future<void> stopAudio() {
    return _$stopAudioAsyncAction.run(() => super.stopAudio());
  }

  late final _$setFeedTypeAsyncAction = AsyncAction(
    '_ReelsStore.setFeedType',
    context: context,
  );

  @override
  Future<void> setFeedType(ReelsFeedType type) {
    return _$setFeedTypeAsyncAction.run(() => super.setFeedType(type));
  }

  late final _$fetchReelsAsyncAction = AsyncAction(
    '_ReelsStore.fetchReels',
    context: context,
  );

  @override
  Future<void> fetchReels({bool refresh = false, String? profileUserId}) {
    return _$fetchReelsAsyncAction.run(
      () => super.fetchReels(refresh: refresh, profileUserId: profileUserId),
    );
  }

  late final _$toggleLikeAsyncAction = AsyncAction(
    '_ReelsStore.toggleLike',
    context: context,
  );

  @override
  Future<void> toggleLike(String reelId) {
    return _$toggleLikeAsyncAction.run(() => super.toggleLike(reelId));
  }

  late final _$fetchCommentsAsyncAction = AsyncAction(
    '_ReelsStore.fetchComments',
    context: context,
  );

  @override
  Future<void> fetchComments(String reelId) {
    return _$fetchCommentsAsyncAction.run(() => super.fetchComments(reelId));
  }

  late final _$addCommentAsyncAction = AsyncAction(
    '_ReelsStore.addComment',
    context: context,
  );

  @override
  Future<void> addComment(String reelId, String content, {String? parentId}) {
    return _$addCommentAsyncAction.run(
      () => super.addComment(reelId, content, parentId: parentId),
    );
  }

  late final _$deleteCommentAsyncAction = AsyncAction(
    '_ReelsStore.deleteComment',
    context: context,
  );

  @override
  Future<void> deleteComment(String commentId, String reelId) {
    return _$deleteCommentAsyncAction.run(
      () => super.deleteComment(commentId, reelId),
    );
  }

  late final _$pickVideoAsyncAction = AsyncAction(
    '_ReelsStore.pickVideo',
    context: context,
  );

  @override
  Future<void> pickVideo() {
    return _$pickVideoAsyncAction.run(() => super.pickVideo());
  }

  late final _$pickImageAsyncAction = AsyncAction(
    '_ReelsStore.pickImage',
    context: context,
  );

  @override
  Future<void> pickImage() {
    return _$pickImageAsyncAction.run(() => super.pickImage());
  }

  late final _$uploadReelAsyncAction = AsyncAction(
    '_ReelsStore.uploadReel',
    context: context,
  );

  @override
  Future<void> uploadReel(String description) {
    return _$uploadReelAsyncAction.run(() => super.uploadReel(description));
  }

  late final _$uploadPhotoPostAsyncAction = AsyncAction(
    '_ReelsStore.uploadPhotoPost',
    context: context,
  );

  @override
  Future<void> uploadPhotoPost(String description) {
    return _$uploadPhotoPostAsyncAction.run(
      () => super.uploadPhotoPost(description),
    );
  }

  late final _$fetchSystemMusicAsyncAction = AsyncAction(
    '_ReelsStore.fetchSystemMusic',
    context: context,
  );

  @override
  Future<void> fetchSystemMusic() {
    return _$fetchSystemMusicAsyncAction.run(() => super.fetchSystemMusic());
  }

  late final _$_ReelsStoreActionController = ActionController(
    name: '_ReelsStore',
    context: context,
  );

  @override
  void globalPause() {
    final _$actionInfo = _$_ReelsStoreActionController.startAction(
      name: '_ReelsStore.globalPause',
    );
    try {
      return super.globalPause();
    } finally {
      _$_ReelsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void globalResume() {
    final _$actionInfo = _$_ReelsStoreActionController.startAction(
      name: '_ReelsStore.globalResume',
    );
    try {
      return super.globalResume();
    } finally {
      _$_ReelsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleAudioFocus() {
    final _$actionInfo = _$_ReelsStoreActionController.startAction(
      name: '_ReelsStore._handleAudioFocus',
    );
    try {
      return super._handleAudioFocus();
    } finally {
      _$_ReelsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPageVisibility(bool visible) {
    final _$actionInfo = _$_ReelsStoreActionController.startAction(
      name: '_ReelsStore.setPageVisibility',
    );
    try {
      return super.setPageVisibility(visible);
    } finally {
      _$_ReelsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentIndex(int index) {
    final _$actionInfo = _$_ReelsStoreActionController.startAction(
      name: '_ReelsStore.setCurrentIndex',
    );
    try {
      return super.setCurrentIndex(index);
    } finally {
      _$_ReelsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPickedVideo() {
    final _$actionInfo = _$_ReelsStoreActionController.startAction(
      name: '_ReelsStore.clearPickedVideo',
    );
    try {
      return super.clearPickedVideo();
    } finally {
      _$_ReelsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPickedImage() {
    final _$actionInfo = _$_ReelsStoreActionController.startAction(
      name: '_ReelsStore.clearPickedImage',
    );
    try {
      return super.clearPickedImage();
    } finally {
      _$_ReelsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectMusic(SystemMusic? music) {
    final _$actionInfo = _$_ReelsStoreActionController.startAction(
      name: '_ReelsStore.selectMusic',
    );
    try {
      return super.selectMusic(music);
    } finally {
      _$_ReelsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
feedType: ${feedType},
reels: ${reels},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
currentIndex: ${currentIndex},
pickedVideoPath: ${pickedVideoPath},
isUploading: ${isUploading},
uploadProgress: ${uploadProgress},
comments: ${comments},
isCommentsLoading: ${isCommentsLoading},
systemMusicList: ${systemMusicList},
selectedMusic: ${selectedMusic},
isMusicLoading: ${isMusicLoading},
currentActiveReelId: ${currentActiveReelId},
reelMusicMap: ${reelMusicMap},
isReelsPageVisible: ${isReelsPageVisible},
pickedImagePath: ${pickedImagePath}
    ''';
  }
}
