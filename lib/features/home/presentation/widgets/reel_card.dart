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

class _ReelCardState extends State<ReelCard> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (!widget.reel.isPhoto) {
      _initializeController();
    } else {
      // Photo post
      setState(() => _initialized = true);
    }
  }

  Future<void> _initializeController() async {
    if (widget.reel.videoUrl.isEmpty) return;
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl));
    try {
      await _controller!.initialize();
      await _controller!.setLooping(true);
      if (mounted) {
        setState(() => _initialized = true);
        if (widget.shouldPlay) {
          _controller!.play();
        }
      }
    } catch (e) {
      debugPrint('ReelCard: Error initializing video player: $e');
    }
  }

  @override
  void didUpdateWidget(ReelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      if (widget.shouldPlay && !oldWidget.shouldPlay) {
        debugPrint('ReelCard: ACTIVE [${widget.reel.id}]');
        if (!widget.reel.isPhoto) {
          _controller?.play();
        }
      } else if (!widget.shouldPlay && oldWidget.shouldPlay) {
        debugPrint('ReelCard: INACTIVE [${widget.reel.id}]');
        if (!widget.reel.isPhoto) {
          _controller?.pause();
        }
      }
    }
  }

  @override
  void dispose() {
    debugPrint('ReelCard: DISPOSE [${widget.reel.id}]');
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = context.appColors;

    return VisibilityDetector(
      key: Key('reel_vis_${widget.reel.id}'),
      onVisibilityChanged: (info) {
        if (!mounted || !_initialized) return;
        
        if (info.visibleFraction < 0.05) {
          if (!widget.reel.isPhoto) {
            _controller?.pause();
          }
        } else if (info.visibleFraction > 0.1) {
          if (widget.shouldPlay && !widget.reel.isPhoto) {
            _controller?.play();
          }
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background media: image or video
          if (widget.reel.isPhoto)
            // ── Photo Post ────────────────────────────────────────────────────
            Container(
              color: Colors.black,
              child: Center(
                child: widget.reel.imageUrl != null
                    ? Image.network(
                        widget.reel.imageUrl!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator(color: Colors.white));
                        },
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white54,
                            size: 64),
                      )
                    : const Icon(Icons.image_not_supported_outlined,
                        color: Colors.white54, size: 64),
              ),
            )
          else if (_initialized)
            // ── Video Reel ────────────────────────────────────────────────────
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          // Overlay content
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
          const SizedBox(height: 8),
          // Audio info
          if (widget.reel.audioUrl != null && widget.reel.audioUrl!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.music_note, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Âm nhạc thịnh hành',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                ),
              ],
            ),
          const SizedBox(height: 10),
          // Actions row — Observer watch store.reels để reactive
          Observer(
            builder: (_) {
              // Get the most up-to-date reel from the store
              final currentReel = widget.store.reels.firstWhere(
                (r) => r.id == widget.reel.id,
                orElse: () => widget.reel,
              );
              return Row(
                children: [
                  // Like button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.store.toggleLike(currentReel.id),
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
                          reelId: currentReel.id,
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
