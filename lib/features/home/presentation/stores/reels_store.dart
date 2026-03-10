import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prj_final_prm/features/auth/presentation/stores/auth_store.dart';
import '../../domain/entities/reel.dart';
import '../../domain/entities/reel_comment.dart';
import '../../domain/usecases/reels_usecases.dart';
import '../../../chat/domain/usecases/get_friends_usecase.dart';

part 'reels_store.g.dart';

enum ReelsFeedType { discover, friends, profile }

@injectable
class ReelsStore = _ReelsStore with _$ReelsStore;

abstract class _ReelsStore with Store {
  final GetReelsUseCase _getReelsUseCase;
  final UploadReelUseCase _uploadReelUseCase;
  final GetFriendsUseCase _getFriendsUseCase;
  final LikeReelUseCase _likeReelUseCase;
  final UnlikeReelUseCase _unlikeReelUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final PostCommentUseCase _postCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final AuthStore _authStore;

  _ReelsStore(
    this._getReelsUseCase,
    this._uploadReelUseCase,
    this._getFriendsUseCase,
    this._likeReelUseCase,
    this._unlikeReelUseCase,
    this._getCommentsUseCase,
    this._postCommentUseCase,
    this._deleteCommentUseCase,
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

  @action
  Future<void> setFeedType(ReelsFeedType type) async {
    if (feedType == type) return;
    feedType = type;
    await fetchReels(refresh: true);
  }

  @action
  Future<void> fetchReels({bool refresh = false, String? profileUserId}) async {
    if (isLoading) return;
    
    isLoading = true;
    errorMessage = null;

    if (refresh) {
      reels.clear();
      currentIndex = 0;
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
      (r) => reels.addAll(r),
    );

    isLoading = false;
  }

  @action
  void setCurrentIndex(int index) {
    currentIndex = index;
    // Check if we need more reels
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
  Future<void> addComment(String reelId, String content) async {
    if (content.trim().isEmpty) return;

    final result = await _postCommentUseCase.execute(reelId: reelId, content: content);
    
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

  @action
  Future<void> uploadReel(String description) async {
    if (pickedVideoPath == null || isUploading) return;

    isUploading = true;
    errorMessage = null;
    uploadProgress = 0.1; // Simulated start

    final result = await _uploadReelUseCase.execute(
      videoPath: pickedVideoPath!,
      description: description,
    );

    result.fold(
      (l) => errorMessage = l.message,
      (r) async {
        // Clear video selection first
        clearPickedVideo();
        // Switch to discover feed so the uploaded reel is visible
        feedType = ReelsFeedType.discover;
        // Refresh reels list to show the newly uploaded reel
        await fetchReels(refresh: true);
      },
    );

    isUploading = false;
    uploadProgress = 1.0;
  }
}
