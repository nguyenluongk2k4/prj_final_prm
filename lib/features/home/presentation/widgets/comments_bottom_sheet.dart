import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../stores/reels_store.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String reelId;
  /// Store được truyền từ ReelCard — KHÔNG dùng getIt() để tránh nhận instance khác.
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

  ReelsStore get _store => widget.store;

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

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
    _commentController.clear();

    await _store.addComment(widget.reelId, text);
    _scrollToBottom();

    if (mounted) setState(() => _isSending = false);
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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Observer(
                    builder: (_) => Text(
                      'Bình luận (${_store.comments.length})',
                      style: AppTextStyles.h3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Comments List
            Expanded(
              child: Observer(
                builder: (_) {
                  if (_store.isCommentsLoading && _store.comments.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_store.comments.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'Chưa có bình luận nào.\nHãy là người đầu tiên! 💬',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _store.comments.length,
                    itemBuilder: (context, index) {
                      final comment = _store.comments[index];
                      final isOwner = comment.userId == _currentUserId;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: comment.user?.avatarUrl != null
                                  ? NetworkImage(comment.user!.avatarUrl!)
                                  : null,
                              backgroundColor: Colors.grey[200],
                              child: comment.user?.avatarUrl == null
                                  ? const Icon(Icons.person, size: 18, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 12),

                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        comment.user?.displayName ?? 'User',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        DateFormat('HH:mm dd/MM').format(comment.createdAt),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(comment.content, style: AppTextStyles.bodyMedium),
                                ],
                              ),
                            ),

                            // Delete button (only for own comments)
                            if (isOwner)
                              GestureDetector(
                                onTap: () => _confirmDelete(comment.id),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, top: 2),
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Input field
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
              child: Row(
                children: [
                  // Current user avatar
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: Supabase.instance.client.auth.currentUser?.userMetadata?['avatar_url'] != null
                        ? NetworkImage(Supabase.instance.client.auth.currentUser!.userMetadata!['avatar_url'])
                        : null,
                    child: Supabase.instance.client.auth.currentUser?.userMetadata?['avatar_url'] == null
                        ? const Icon(Icons.person, size: 18, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendComment(),
                      decoration: InputDecoration(
                        hintText: 'Thêm bình luận...',
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Send button
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
                          icon: const Icon(Icons.send_rounded, color: Colors.pinkAccent),
                          onPressed: _sendComment,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
