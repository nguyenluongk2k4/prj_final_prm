import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../domain/entities/reel.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../stores/reels_store.dart';
import 'comments_bottom_sheet.dart';

class ReelCard extends StatefulWidget {
  final Reel reel;
  final bool shouldPlay;
  /// Store được truyền từ ReelsPage xuống — KHÔNG dùng getIt() trực tiếp
  /// để tránh nhận instance khác (vì ReelsStore là @injectable factory).
  final ReelsStore store;

  const ReelCard({
    super.key,
    required this.reel,
    required this.shouldPlay,
    required this.store,
  });

  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl));
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      if (mounted) {
        setState(() => _initialized = true);
        if (widget.shouldPlay) {
          _controller.play();
        }
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  @override
  void didUpdateWidget(ReelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      if (widget.shouldPlay) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return VisibilityDetector(
      key: Key(widget.reel.id),
      onVisibilityChanged: (info) {
        if (info.visibleFraction <= 0.5 && _initialized) {
          _controller.pause();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video background
          if (_initialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          // Overlay content — dùng widget.store được truyền từ ngoài
          _buildOverlay(context, c),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, AppColorScheme c) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black26,
            Colors.transparent,
            Colors.transparent,
            Colors.black54,
          ],
          stops: [0.0, 0.2, 0.7, 1.0],
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: widget.reel.author?.avatarUrl != null
                    ? NetworkImage(widget.reel.author!.avatarUrl!)
                    : null,
                backgroundColor: c.primary.withOpacity(0.1),
                child: widget.reel.author?.avatarUrl == null
                    ? const Icon(Icons.person, size: 20, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                widget.reel.author?.displayName ?? 'User',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Description
          if (widget.reel.description != null)
            Text(
              widget.reel.description!,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 10),
          // Actions row — Observer watch store.reels để reactive
          Observer(
            builder: (_) {
              // Lấy reel mới nhất từ store (lúc toggle like/add comment sẽ bị replace)
              final currentReel = widget.store.reels.firstWhere(
                (r) => r.id == widget.reel.id,
                orElse: () => widget.reel,
              );
              return Row(
                children: [
                  // Like button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.store.toggleLike(widget.reel.id),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              currentReel.isLikedByMe
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey(currentReel.isLikedByMe),
                              color: currentReel.isLikedByMe ? Colors.red : Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${currentReel.likesCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Comment button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CommentsBottomSheet(
                          reelId: widget.reel.id,
                          store: widget.store,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${currentReel.commentsCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Safe area bottom
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
