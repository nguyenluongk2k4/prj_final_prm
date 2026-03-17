import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prj_final_prm/features/home/domain/entities/reel_comment.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../stores/reels_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String reelId;
  final ReelsStore store;

  const CommentsBottomSheet({
    super.key,
    required this.reelId,
    required this.store,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;
  ReelComment? _replyingToComment;
  final Set<String> _expandedComments = {};

  ReelsStore get _store => widget.store;
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  // Find the author ID of the reel to show "Tác giả" badge
  String? get _reelAuthorId {
    try {
      return _store.reels.firstWhere((r) => r.id == widget.reelId).authorId;
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _store.fetchComments(widget.reelId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    
    final parentId = _replyingToComment?.id;
    await _store.addComment(
      widget.reelId, 
      text, 
      parentId: parentId,
    );
    
    _commentController.clear();
    if (mounted) {
      setState(() {
        _isSending = false;
        if (parentId != null) {
          _expandedComments.add(parentId);
        }
        _replyingToComment = null;
      });
    }
    _scrollToBottom();
  }

  void _confirmDelete(String commentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá bình luận?'),
        content: const Text('Bình luận này sẽ bị xoá vĩnh viễn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _store.deleteComment(commentId, widget.reelId);
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Observer(
                    builder: (_) => Text(
                      'Bình luận (${_store.comments.length})',
                      style: AppTextStyles.h3.copyWith(color: colorScheme.onSurface),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: theme.dividerColor),
            Expanded(
              child: Observer(
                builder: (_) {
                  if (_store.isCommentsLoading && _store.comments.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_store.comments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 48, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text(
                            'Chưa có bình luận nào.\nHãy là người đầu tiên! 💬',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  final rootComments = _store.comments.where((c) => c.parentId == null).toList();

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: rootComments.length,
                    itemBuilder: (context, index) {
                      final comment = rootComments[index];
                      final replies = _store.comments.where((c) => c.parentId == comment.id).toList();
                      final isExpanded = _expandedComments.contains(comment.id);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCommentItem(comment, isRoot: true),
                          if (replies.isNotEmpty) ...[
                            if (isExpanded)
                              ...replies.map((reply) => _buildCommentItem(reply, isRoot: false))
                            else
                              Padding(
                                padding: const EdgeInsets.only(left: 56, bottom: 12),
                                child: InkWell(
                                  onTap: () => setState(() => _expandedComments.add(comment.id)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.reply, size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Xem thêm ${replies.length} câu trả lời...',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.only(left: 56, bottom: 12),
                                child: InkWell(
                                  onTap: () => setState(() => _expandedComments.remove(comment.id)),
                                  child: Text(
                                    'Ẩn bớt',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            _buildInputSection(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(ReelComment comment, {required bool isRoot}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOwner = comment.userId == _currentUserId;
    final isAuthor = comment.userId == _reelAuthorId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          // L-shaped line for replies
          if (!isRoot)
            Positioned(
              left: 24,
              top: 0,
              bottom: 20,
              child: Container(
                width: 20,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
                    bottom: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
                  ),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: isRoot ? 0 : 44),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: isRoot ? 18 : 14,
                  backgroundImage: comment.user?.avatarUrl != null ? NetworkImage(comment.user!.avatarUrl!) : null,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  child: comment.user?.avatarUrl == null
                      ? Icon(Icons.person, size: isRoot ? 20 : 16, color: colorScheme.onSurfaceVariant)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Comment Bubble
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  comment.user?.displayName ?? 'User',
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                if (isAuthor) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.mic, size: 10, color: colorScheme.primary),
                                        const SizedBox(width: 2),
                                        Text(
                                          'Tác giả',
                                          style: TextStyle(
                                            color: colorScheme.primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              comment.content,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Action buttons
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              _formatTime(comment.createdAt),
                              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {}, // Thích
                              child: Text(
                                'Thích',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (isRoot)
                              GestureDetector(
                                onTap: () => setState(() => _replyingToComment = comment),
                                child: Text(
                                  'Trả lời',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (isOwner) ...[
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () => _confirmDelete(comment.id),
                                child: Text(
                                  'Xoá',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_replyingToComment != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                      children: [
                        const TextSpan(text: 'Đang trả lời '),
                        TextSpan(
                          text: _replyingToComment!.user?.displayName ?? "người dùng",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _replyingToComment = null),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.surfaceContainerHighest,
                backgroundImage: Supabase.instance.client.auth.currentUser?.userMetadata?['avatar_url'] != null
                    ? NetworkImage(Supabase.instance.client.auth.currentUser!.userMetadata!['avatar_url'])
                    : null,
                child: Supabase.instance.client.auth.currentUser?.userMetadata?['avatar_url'] == null
                    ? Icon(Icons.person, size: 18, color: colorScheme.onSurfaceVariant)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendComment(),
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Viết bình luận...',
                    hintStyle: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 4),
              _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.blueAccent),
                      onPressed: _sendComment,
                    ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) return '${difference.inDays} ngày';
    if (difference.inHours > 0) return '${difference.inHours} giờ';
    if (difference.inMinutes > 0) return '${difference.inMinutes} phút';
    return 'Vừa xong';
  }
}
