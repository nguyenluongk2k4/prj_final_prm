import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/chat_message.dart';

class ConversationDateSeparator extends StatelessWidget {
  final String label;
  final AppColorScheme colors;

  const ConversationDateSeparator({
    super.key,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(child: Divider(color: colors.border, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: colors.text70),
            ),
          ),
          Expanded(child: Divider(color: colors.border, thickness: 1)),
        ],
      ),
    );
  }
}

class ConversationBubbleTile extends StatelessWidget {
  final ChatMessage message;
  final AppColorScheme colors;

  const ConversationBubbleTile({
    super.key,
    required this.message,
    required this.colors,
  });

  bool get _isMe => message.sender == ChatSender.me;

  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.72;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_isMe) ...[
                Text(
                  message.time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.text70.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _isMe
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.08),
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
                      message.text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _isMe ? Colors.white : colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              if (!_isMe) ...[
                const SizedBox(width: 6),
                Text(
                  message.time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.text70.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ConversationTypingIndicatorTile extends StatefulWidget {
  final AppColorScheme colors;

  const ConversationTypingIndicatorTile({
    super.key,
    required this.colors,
  });

  @override
  State<ConversationTypingIndicatorTile> createState() =>
      _ConversationTypingIndicatorTileState();
}

class _ConversationTypingIndicatorTileState
    extends State<ConversationTypingIndicatorTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.zero,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TypingDot(progress: t, phase: 0.0, colors: colors),
                  const SizedBox(width: 4),
                  _TypingDot(progress: t, phase: 0.33, colors: colors),
                  const SizedBox(width: 4),
                  _TypingDot(progress: t, phase: 0.66, colors: colors),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final double progress;
  final double phase;
  final AppColorScheme colors;

  const _TypingDot({
    required this.progress,
    required this.phase,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final t = (progress + phase) % 1.0;
    final wave = (math.sin(t * math.pi * 2) + 1) / 2;
    final scale = 0.7 + (wave * 0.6);
    final opacity = 0.4 + (wave * 0.6);

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: colors.text70,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class ConversationImageBubbleTile extends StatelessWidget {
  final ChatMessage message;
  final AppColorScheme colors;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ConversationImageBubbleTile({
    super.key,
    required this.message,
    required this.colors,
    this.onTap,
    this.onLongPress,
  });

  bool get _isMe => message.sender == ChatSender.me;

  @override
  Widget build(BuildContext context) {
    final filePath = message.filePath;
    final fileUrl = message.fileUrl;
    if (filePath == null && (fileUrl == null || fileUrl.isEmpty)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: filePath != null
                ? Image.file(
                    File(filePath),
                    width: 160,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    fileUrl!,
                    width: 160,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}

class ConversationFileBubbleTile extends StatelessWidget {
  final ChatMessage message;
  final AppColorScheme colors;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ConversationFileBubbleTile({
    super.key,
    required this.message,
    required this.colors,
    this.onTap,
    this.onLongPress,
  });

  bool get _isMe => message.sender == ChatSender.me;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = message.text.isNotEmpty ? message.text : t.fileLabel;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _isMe
                  ? AppColors.primary.withOpacity(0.12)
                  : colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.insert_drive_file_rounded, color: colors.text70, size: 18),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: AppTextStyles.bodySmall.copyWith(color: colors.textPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
