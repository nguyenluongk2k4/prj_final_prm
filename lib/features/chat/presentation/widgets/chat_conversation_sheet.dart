import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../pages/conservation_detail.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

enum _Sender { me, other }

enum _MsgType { text, image, file }

class _ChatMsg {
  final _MsgType type;
  final String text; // text content, or filename for image/file msgs
  final String time;
  final _Sender sender;
  final String? filePath; // local path for picked image/file

  const _ChatMsg({
    this.type = _MsgType.text,
    required this.text,
    required this.time,
    required this.sender,
    this.filePath,
  });
}

// ─── Public API ───────────────────────────────────────────────────────────────

/// Opens a full-height bottom sheet that displays the conversation with [name].
/// Pass [userId] (Tencent user ID) to enable audio/video calls.
void showChatConversationSheet(
  BuildContext context, {
  required String name,
  required AssetGenImage avatar,
  bool hasReels = false,
  String userId = '',
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _ChatConversationSheet(
          name: name,
          avatar: avatar,
          hasReels: hasReels,
          userId: userId,
        ),
  );
}

// ─── Sheet widget ─────────────────────────────────────────────────────────────

class _ChatConversationSheet extends StatefulWidget {
  final String name;
  final AssetGenImage avatar;
  final String userId;
  final bool hasReels;

  const _ChatConversationSheet({
    required this.name,
    required this.avatar,
    required this.hasReels,
    required this.userId,
  });

  @override
  State<_ChatConversationSheet> createState() => _ChatConversationSheetState();
}

class _ChatConversationSheetState extends State<_ChatConversationSheet> {
  final TextEditingController _msgCtrl = TextEditingController();
  // The DraggableScrollableSheet hands us its scrollController in the builder.
  // We keep a reference so _scrollToBottom() can use it everywhere.
  ScrollController? _listScrollCtrl;
  final ImagePicker _imagePicker = ImagePicker();
  bool _hasText = false;
  int _unreadBelow = 0;   // messages from other while user is scrolled up
  bool _isAtBottom = true;

  final List<_ChatMsg> _messages = [
    _ChatMsg(
      text: 'Hi Jake, how are you? I saw on the app that we\'ve crossed paths several times this week 😄',
      time: '2:55 PM',
      sender: _Sender.other,
    ),
    _ChatMsg(
      text: 'Haha truly! Nice to meet you Grace! What about a cup of coffee today evening? ☕️',
      time: '3:02 PM',
      sender: _Sender.me,
    ),
    _ChatMsg(text: 'Sure, let\'s do it! 😊', time: '3:10 PM', sender: _Sender.other),
    _ChatMsg(
      text: 'Great I will write later the exact\ntime and place. See you soon!',
      time: '3:12 PM',
      sender: _Sender.me,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _msgCtrl.addListener(() {
      final hasText = _msgCtrl.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  // ── Called once when the DraggableScrollableSheet exposes its controller ───
  void _attachScrollController(ScrollController sc) {
    if (_listScrollCtrl == sc) return; // already attached
    _listScrollCtrl = sc;
    sc.addListener(() {
      if (!sc.hasClients) return;
      final atBottom =
          sc.offset >= sc.position.maxScrollExtent - 60;
      if (atBottom != _isAtBottom) {
        setState(() {
          _isAtBottom = atBottom;
          if (atBottom) _unreadBelow = 0;
        });
      }
    });
  }

  // ── Send text ──────────────────────────────────────────────────────────────

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(text: text, time: _nowTime(), sender: _Sender.me));
      _msgCtrl.clear();
    });
    _scrollToBottom();
    _simulateReply();
  }

  // ── Simulated incoming reply (demos the badge) ────────────────────────────
  static const List<String> _autoReplies = [
    'Sounds great! 😊',
    'Haha yes, totally! 😄',
    'Let me think about it... 🤔',
    'Sure, why not! ✨',
    'Can\'t wait! 🙌',
  ];
  int _replyIdx = 0;

  void _simulateReply() {
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final reply = _autoReplies[_replyIdx % _autoReplies.length];
      _replyIdx++;
      setState(() {
        _messages.add(
          _ChatMsg(text: reply, time: _nowTime(), sender: _Sender.other),
        );
        if (!_isAtBottom) _unreadBelow++;
      });
      if (_isAtBottom) _scrollToBottom();
    });
  }

  // ── Voice message (tencent_cloud_chat_sdk supports V2TIMAudioElem) ─────────

  void _onVoiceTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hold to record audio message (Tencent SDK)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ── Calls (tencent_calls_uikit) ───────────────────────────────────────────

  Future<void> _startAudioCall() async {
    if (widget.userId.isEmpty) {
      _showNoUserIdSnack();
      return;
    }
    await TUICallKit.instance.call(widget.userId, TUICallMediaType.audio);
  }

  Future<void> _startVideoCall() async {
    if (widget.userId.isEmpty) {
      _showNoUserIdSnack();
      return;
    }
    await TUICallKit.instance.call(widget.userId, TUICallMediaType.video);
  }

  void _showNoUserIdSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User ID not available for calling')),
    );
  }

  // ── Attachment picker ──────────────────────────────────────────────────────

  void _showAttachmentOptions() {
    final c = context.appColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _AttachOption(
              icon: Icons.photo_library_rounded,
              label: 'Photo Gallery',
              color: const Color(0xFF4CAF50),
              onTap: () { Navigator.pop(context); _pickFromGallery(); },
            ),
            _AttachOption(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              color: const Color(0xFF2196F3),
              onTap: () { Navigator.pop(context); _pickFromCamera(); },
            ),
            _AttachOption(
              icon: Icons.insert_drive_file_rounded,
              label: 'File',
              color: const Color(0xFFFF9800),
              onTap: () { Navigator.pop(context); _pickFile(); },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final xfile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    setState(() {
      _messages.add(_ChatMsg(
        type: _MsgType.image,
        text: xfile.name,
        time: _nowTime(),
        sender: _Sender.me,
        filePath: xfile.path,
      ));
    });
    _scrollToBottom();
  }

  Future<void> _pickFromCamera() async {
    final xfile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (xfile == null) return;
    setState(() {
      _messages.add(_ChatMsg(
        type: _MsgType.image,
        text: xfile.name,
        time: _nowTime(),
        sender: _Sender.me,
        filePath: xfile.path,
      ));
    });
    _scrollToBottom();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    final picked = result.files.first;
    setState(() {
      _messages.add(_ChatMsg(
        type: _MsgType.file,
        text: picked.name,
        time: _nowTime(),
        sender: _Sender.me,
        filePath: picked.path,
      ));
    });
    _scrollToBottom();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _nowTime() {
    final now = DateTime.now();
    final h = now.hour;
    final m = now.minute.toString().padLeft(2, '0');
    final suffix = h >= 12 ? 'PM' : 'AM';
    final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$h12:$m $suffix';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sc = _listScrollCtrl;
      if (sc != null && sc.hasClients) {
        sc.animateTo(
          sc.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onBadgeTap() {
    setState(() => _unreadBelow = 0);
    _scrollToBottom();
  }

  void _openConversationPage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConservationDetailPage(
          name: widget.name,
          avatarUrl: null,
          userId: widget.userId,
          hasReels: widget.hasReels,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final mq = MediaQuery.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.55,
      maxChildSize: 0.97,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ── Drag handle ─────────────────────────────────────────────
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  // Back / close
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Assets.icons.icBack.svg(width: 24, height: 24),
                  ),

                  const SizedBox(width: 12),

                  // Name + Online
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: AppTextStyles.h3.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        Text(
                          'Online',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: c.textPrimary.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Audio call button ──────────────────────────────
                  _HeaderIconButton(
                    icon: Icons.phone_rounded,
                    color: c,
                    iconColor: const Color(0xFF4CAF50),
                    onTap: _startAudioCall,
                    semanticLabel: 'Audio call',
                  ),

                  const SizedBox(width: 8),

                  // ── Video call button ──────────────────────────────────
                  _HeaderIconButton(
                    icon: Icons.videocam_rounded,
                    color: c,
                    iconColor: AppColors.primary,
                    onTap: _startVideoCall,
                    semanticLabel: 'Video call',
                  ),

                  const SizedBox(width: 12),

                  _HeaderIconButton(
                    icon: Icons.open_in_new_rounded,
                    color: c,
                    iconColor: c.textPrimary,
                    onTap: _openConversationPage,
                    semanticLabel: 'Open full chat',
                  ),

                  const SizedBox(width: 12),

                  // Avatar + online dot
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: widget.hasReels
                              ? Border.all(color: Colors.red, width: 2)
                              : null,
                        ),
                        child: ClipOval(
                          child: widget.avatar.image(
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: c.background, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: c.border),

            // ── Messages + floating new-message badge ─────────────────
            Expanded(
              child: Builder(builder: (context) {
                _attachScrollController(scrollController);
                return Stack(
                  children: [
                    ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      itemCount: _messages.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 1) return _DateSeparator(label: 'Today', c: c);
                        final idx = i > 1 ? i - 1 : i;
                        if (idx >= _messages.length) return const SizedBox.shrink();
                        final msg = _messages[idx];
                        if (msg.type == _MsgType.image) return _ImageBubbleTile(msg: msg, c: c);
                        if (msg.type == _MsgType.file) return _FileBubbleTile(msg: msg, c: c);
                        return _BubbleTile(msg: msg, c: c);
                      },
                    ),

                    // ── Floating "↓ N new messages" badge ─────────────
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedSlide(
                          offset: _unreadBelow > 0
                              ? Offset.zero
                              : const Offset(0, 2.0),
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutBack,
                          child: AnimatedOpacity(
                            opacity: _unreadBelow > 0 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 220),
                            child: _NewMessageBadge(
                              count: _unreadBelow,
                              onTap: _onBadgeTap,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            // ── Input bar ────────────────────────────────────────────────
            Container(
              color: c.background,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: mq.viewInsets.bottom + mq.padding.bottom + 12,
              ),
              child: Container(
                constraints: const BoxConstraints(minHeight: 50),
                decoration: BoxDecoration(
                  color: c.backgroundSecondary,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Attachment
                    GestureDetector(
                      onTap: _showAttachmentOptions,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.add_circle_outline_rounded,
                          color: c.text70,
                          size: 22,
                        ),
                      ),
                    ),

                    // Text field
                    Expanded(
                      child: AppTextField(
                        controller: _msgCtrl,
                        hint: 'Your message',
                        maxLines: 4,
                        minLines: 1,
                        embedded: true,
                        onChanged: (_) {},
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),

                    // Voice  ← kept: tencent_cloud_chat_sdk supports V2TIMAudioElem
                    // Send   ← shown when text is non-empty
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _hasText
                          ? GestureDetector(
                              key: const ValueKey('send'),
                              onTap: _sendMessage,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                    child: Assets.icons.icSendMessage.image(
                                      width: 18,
                                      height: 18,
                                      color: Colors.white,
                                    ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              key: const ValueKey('voice'),
                              onTap: _onVoiceTap,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                child: Assets.icons.chatVoice.image(
                                  width: 22,
                                  height: 22,
                                  color: c.text70,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Date separator ───────────────────────────────────────────────────────────

class _DateSeparator extends StatelessWidget {
  final String label;
  final AppColorScheme c;
  const _DateSeparator({required this.label, required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(child: Divider(color: c.border, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: c.text70),
            ),
          ),
          Expanded(child: Divider(color: c.border, thickness: 1)),
        ],
      ),
    );
  }
}

// ─── Chat bubble ─────────────────────────────────────────────────────────────

class _BubbleTile extends StatelessWidget {
  final _ChatMsg msg;
  final AppColorScheme c;
  const _BubbleTile({required this.msg, required this.c});

  bool get _isMe => msg.sender == _Sender.me;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment:
            _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Bubble
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: _isMe
                    ? (c.isDark
                        ? const Color(0xFF2C2C2C)
                        : const Color(0xFFF3F3F3))
                    : AppColors.primary.withOpacity(0.07),
                borderRadius: _isMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.zero,
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.zero,
                      ),
              ),
              child: Text(
                msg.text,
                style: AppTextStyles.bodyMedium.copyWith(color: c.textPrimary),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Time + done-all (mine only)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (_isMe) ...[
                Assets.icons.chatDoneAll.image(width: 14, height: 14),
                const SizedBox(width: 4),
              ],
              Text(
                msg.time,
                style: AppTextStyles.bodySmall.copyWith(
                  color: c.text70.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// ─── Header icon button ───────────────────────────────────────────────────────

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final AppColorScheme color;
  final Color iconColor;
  final VoidCallback onTap;
  final String semanticLabel;

  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final c = color;
    return Semantics(
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: c.isDark ? Colors.transparent : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: c.isDark
                  ? const Color(0xFF2C2C2C)
                  : const Color(0xFFE8E6EA),
            ),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }
}

// ─── Attachment option row ────────────────────────────────────────────────────

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(color: c.textPrimary),
      ),
      onTap: onTap,
    );
  }
}

// ─── Image bubble ─────────────────────────────────────────────────────────────

class _ImageBubbleTile extends StatelessWidget {
  final _ChatMsg msg;
  final AppColorScheme c;
  const _ImageBubbleTile({required this.msg, required this.c});

  bool get _isMe => msg.sender == _Sender.me;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment:
            _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.60,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: msg.filePath != null
                  ? Image.file(File(msg.filePath!), fit: BoxFit.cover)
                  : Container(
                      height: 120,
                      color: c.backgroundSecondary,
                      child: Icon(Icons.image, color: c.text70),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isMe) ...[
                Assets.icons.chatDoneAll.image(width: 14, height: 14),
                const SizedBox(width: 4),
              ],
              Text(
                msg.time,
                style: AppTextStyles.bodySmall.copyWith(
                  color: c.text70.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── File bubble ─────────────────────────────────────────────────────────────

class _FileBubbleTile extends StatelessWidget {
  final _ChatMsg msg;
  final AppColorScheme c;
  const _FileBubbleTile({required this.msg, required this.c});

  bool get _isMe => msg.sender == _Sender.me;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment:
            _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _isMe
                    ? (c.isDark
                        ? const Color(0xFF2C2C2C)
                        : const Color(0xFFF3F3F3))
                    : AppColors.primary.withOpacity(0.07),
                borderRadius: _isMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.insert_drive_file_rounded,
                      color: Color(0xFFFF9800),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      msg.text,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: c.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isMe) ...[
                Assets.icons.chatDoneAll.image(width: 14, height: 14),
                const SizedBox(width: 4),
              ],
              Text(
                msg.time,
                style: AppTextStyles.bodySmall.copyWith(
                  color: c.text70.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── New messages badge (Gmail-style) ────────────────────────────────────────

class _NewMessageBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _NewMessageBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = count == 1 ? '↓  1 new message' : '↓  $count new messages';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}