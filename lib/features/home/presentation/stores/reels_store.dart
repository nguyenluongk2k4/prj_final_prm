import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prj_final_prm/features/auth/presentation/stores/auth_store.dart';
import '../../domain/entities/reel.dart';
import '../../domain/entities/reel_comment.dart';
import '../../domain/entities/music.dart';
import '../../domain/usecases/reels_usecases.dart';
import '../../../chat/domain/usecases/get_friends_usecase.dart';

part 'reels_store.g.dart';

enum ReelsFeedType { discover, friends, profile }

@lazySingleton
class ReelsStore = _ReelsStore with _$ReelsStore;

abstract class _ReelsStore with Store {
  final GetReelsUseCase _getReelsUseCase;
  final UploadReelUseCase _uploadReelUseCase;
  final UploadPhotoPostUseCase _uploadPhotoPostUseCase;
  final GetFriendsUseCase _getFriendsUseCase;
  final LikeReelUseCase _likeReelUseCase;
  final UnlikeReelUseCase _unlikeReelUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final PostCommentUseCase _postCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final GetSystemMusicUseCase _getSystemMusicUseCase;
  final AuthStore _authStore;

  _ReelsStore(
    this._getReelsUseCase,
    this._uploadReelUseCase,
    this._uploadPhotoPostUseCase,
    this._getFriendsUseCase,
    this._likeReelUseCase,
    this._unlikeReelUseCase,
    this._getCommentsUseCase,
    this._postCommentUseCase,
    this._deleteCommentUseCase,
    this._getSystemMusicUseCase,
    this._authStore,
  );

  @observable
  ReelsFeedType feedType = ReelsFeedType.discover;

  @observable
  ObservableList<Reel> reels = ObservableList<Reel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  int currentIndex = 0;

  @observable
  String? pickedVideoPath;

  @observable
  bool isUploading = false;

  @observable
  double uploadProgress = 0;

  @observable
  ObservableList<ReelComment> comments = ObservableList<ReelComment>();

  @observable
  bool isCommentsLoading = false;

  @observable
  ObservableList<SystemMusic> systemMusicList = ObservableList<SystemMusic>();

  @observable
  SystemMusic? selectedMusic;

  @observable
  bool isMusicLoading = false;

  // Centralized Audio for Photo Posts
  final AudioPlayer _globalAudioPlayer = AudioPlayer();
  String? _currentlyPlayingReelId;
  
  @observable
  String? currentActiveReelId;
  
  // Registry of Reel IDs that have music
  @observable
  ObservableMap<String, String> reelMusicMap = ObservableMap();

  @action
  Future<void> playReelAudio(String url, String reelId) async {
    // Only play if it's the focused reel AND the page is visible
    if (reelId != currentActiveReelId || !isReelsPageVisible) {
      debugPrint('STORE: Rejecting play request for [$reelId] - Focus mismatch or Hidden');
      return;
    }

    if (_currentlyPlayingReelId == reelId && _globalAudioPlayer.state == PlayerState.playing) return;
    
    debugPrint('STORE: Playing Audio for Reel [$reelId]');
    _currentlyPlayingReelId = reelId;

    try {
      await _globalAudioPlayer.setReleaseMode(ReleaseMode.loop);
      await _globalAudioPlayer.stop();
      await _globalAudioPlayer.setSource(UrlSource(url));
      await _globalAudioPlayer.resume();
    } catch (e) {
      debugPrint('STORE: Error playing audio: $e');
    }
  }

  @action
  Future<void> stopAudio() async {
    debugPrint('STORE: Stopping Audio');
    await _globalAudioPlayer.stop();
    _currentlyPlayingReelId = null;
  }

  @action
  void globalPause() {
    debugPrint('STORE: Global Pause triggered');
    _globalAudioPlayer.pause();
  }

  @action
  void globalResume() {
    // Re-check focus and map before resuming
    if (isReelsPageVisible && currentActiveReelId != null) {
      final musicUrl = reelMusicMap[currentActiveReelId];
      if (musicUrl != null) {
        debugPrint('STORE: Global Resume - Playing music for focused reel [$currentActiveReelId]');
        playReelAudio(musicUrl, currentActiveReelId!);
      } else {
        debugPrint('STORE: Global Resume - Focused reel [$currentActiveReelId] has no music');
        _globalAudioPlayer.pause();
      }
    }
  }

  @action
  void _handleAudioFocus() {
    if (!isReelsPageVisible || currentActiveReelId == null) {
      globalPause();
      return;
    }

    final musicUrl = reelMusicMap[currentActiveReelId];
    if (musicUrl != null) {
      playReelAudio(musicUrl, currentActiveReelId!);
    } else {
      debugPrint('STORE: Focus changed to silent reel [$currentActiveReelId], pausing audio');
      _globalAudioPlayer.pause();
      _currentlyPlayingReelId = null;
    }
  }

  @observable
  bool isReelsPageVisible = true;

  @action
  void setPageVisibility(bool visible) {
    if (isReelsPageVisible == visible) return;
    isReelsPageVisible = visible;
    debugPrint('STORE: Reels Page Visibility changed to: $visible');
    if (!visible) {
      globalPause();
    } else {
      globalResume();
    }
  }

  @action
  Future<void> setFeedType(ReelsFeedType type) async {
    if (feedType == type) return;
    feedType = type;
    stopAudio(); // Stop completely when changing feed
    await fetchReels(refresh: true);
  }

  @action
  Future<void> fetchReels({bool refresh = false, String? profileUserId}) async {
    if (isLoading) return;
    
    isLoading = true;
    errorMessage = null;

    if (refresh) {
      reels.clear();
      reelMusicMap.clear();
      currentIndex = 0;
      currentActiveReelId = null;
      stopAudio();
    }

    String? authorId;
    List<String>? friendIds;

    if (feedType == ReelsFeedType.profile) {
      authorId = profileUserId ?? _authStore.currentUser?.id;
    } else if (feedType == ReelsFeedType.friends) {
      final friendsResult = await _getFriendsUseCase.execute();
      friendsResult.fold(
        (l) => errorMessage = l,
        (r) => friendIds = r.map((f) => f.friendId).toList(),
      );
      
      if (friendIds == null || friendIds!.isEmpty) {
        // No friends, show empty or error
        reels.clear();
        isLoading = false;
        return;
      }
    }

    final result = await _getReelsUseCase.execute(
      offset: reels.length,
      authorId: authorId,
      friendIds: friendIds,
    );
    
    result.fold(
      (l) => errorMessage = l.message,
      (r) {
        for (var reel in r) {
          reels.add(reel);
          if (reel.isPhoto && reel.audioUrl != null && reel.audioUrl!.isNotEmpty) {
            reelMusicMap[reel.id] = reel.audioUrl!;
          }
        }
        
        if (currentActiveReelId == null && reels.isNotEmpty) {
          currentActiveReelId = reels[0].id;
          _handleAudioFocus();
        }
      },
    );

    isLoading = false;
  }

  @action
  void setCurrentIndex(int index) {
    currentIndex = index;
    if (index >= 0 && index < reels.length) {
      currentActiveReelId = reels[index].id;
      _handleAudioFocus();
    }
    
    if (index >= reels.length - 3) {
      fetchReels();
    }
  }

  @action
  Future<void> toggleLike(String reelId) async {
    final index = reels.indexWhere((r) => r.id == reelId);
    if (index == -1) return;

    final reel = reels[index];
    final wasLiked = reel.isLikedByMe;
    
    // Optimistic UI update
    reels[index] = reel.copyWith(
      isLikedByMe: !wasLiked,
      likesCount: wasLiked ? reel.likesCount - 1 : reel.likesCount + 1,
    );

    final result = wasLiked 
        ? await _unlikeReelUseCase.execute(reelId)
        : await _likeReelUseCase.execute(reelId);

    result.fold(
      (l) {
        // Rollback on error
        reels[index] = reel;
        errorMessage = l.message;
      },
      (r) => null,
    );
  }

  @action
  Future<void> fetchComments(String reelId) async {
    isCommentsLoading = true;
    comments.clear();
    
    final result = await _getCommentsUseCase.execute(reelId);
    
    result.fold(
      (l) => errorMessage = l.message,
      (r) => comments.addAll(r),
    );
    
    isCommentsLoading = false;
  }

  @action
  Future<void> addComment(String reelId, String content, {String? parentId}) async {
    if (content.trim().isEmpty) return;

    final result = await _postCommentUseCase.execute(
      reelId: reelId,
      content: content,
      parentId: parentId,
    );
    
    result.fold(
      (l) => errorMessage = l.message,
      (r) {
        comments.add(r);
        // Update comments count in the reel object
        final index = reels.indexWhere((re) => re.id == reelId);
        if (index != -1) {
          reels[index] = reels[index].copyWith(
            commentsCount: reels[index].commentsCount + 1,
          );
        }
      },
    );
  }

  @action
  Future<void> deleteComment(String commentId, String reelId) async {
    final commentIndex = comments.indexWhere((c) => c.id == commentId);
    if (commentIndex == -1) return;

    // Optimistic removal
    final removedComment = comments[commentIndex];
    comments.removeAt(commentIndex);

    // Also update count optimistically
    final reelIndex = reels.indexWhere((r) => r.id == reelId);
    if (reelIndex != -1) {
      reels[reelIndex] = reels[reelIndex].copyWith(
        commentsCount: (reels[reelIndex].commentsCount - 1).clamp(0, 999999),
      );
    }

    final result = await _deleteCommentUseCase.execute(
      commentId: commentId,
      reelId: reelId,
    );

    result.fold(
      (l) {
        // Rollback on error
        comments.insert(commentIndex, removedComment);
        if (reelIndex != -1) {
          reels[reelIndex] = reels[reelIndex].copyWith(
            commentsCount: reels[reelIndex].commentsCount + 1,
          );
        }
        errorMessage = l.message;
      },
      (r) => null,
    );
  }

  @action
  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      pickedVideoPath = video.path;
    }
  }

  @action
  void clearPickedVideo() {
    pickedVideoPath = null;
    uploadProgress = 0;
  }

  @observable
  String? pickedImagePath;

  @action
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (image != null) {
      pickedImagePath = image.path;
    }
  }

  @action
  void clearPickedImage() {
    pickedImagePath = null;
    uploadProgress = 0;
  }

  @action
  Future<void> uploadReel(String description) async {
    if (pickedVideoPath == null || isUploading) return;

    isUploading = true;
    errorMessage = null;
    uploadProgress = 0.1;

    final result = await _uploadReelUseCase.execute(
      videoPath: pickedVideoPath!,
      description: description,
    );

    result.fold(
      (l) => errorMessage = l.message,
      (r) async {
        clearPickedVideo();
        feedType = ReelsFeedType.discover;
        await fetchReels(refresh: true);
      },
    );

    isUploading = false;
    uploadProgress = 1.0;
  }

  @action
  Future<void> uploadPhotoPost(String description) async {
    if (pickedImagePath == null || isUploading) return;

    isUploading = true;
    errorMessage = null;
    uploadProgress = 0.1;

    final result = await _uploadPhotoPostUseCase.execute(
      imagePath: pickedImagePath!,
      description: description,
      audioUrl: selectedMusic?.url,
    );

    result.fold(
      (l) => errorMessage = l.message,
      (r) async {
        clearPickedImage();
        selectedMusic = null;
        feedType = ReelsFeedType.discover;
        await fetchReels(refresh: true);
      },
    );

    isUploading = false;
    uploadProgress = 1.0;
  }

  @action
  Future<void> fetchSystemMusic() async {
    isMusicLoading = true;
    final result = await _getSystemMusicUseCase.execute();
    result.fold(
      (l) => errorMessage = l.message,
      (r) => systemMusicList = ObservableList.of(r),
    );
    isMusicLoading = false;
  }

  @action
  void selectMusic(SystemMusic? music) {
    selectedMusic = music;
  }

  void dispose() {
    _globalAudioPlayer.dispose();
  }
}
