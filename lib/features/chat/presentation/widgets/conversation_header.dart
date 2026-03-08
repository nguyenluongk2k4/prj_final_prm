import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../i18n/strings.g.dart';
class ConversationHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool hasReels;
  final bool isOnline;
  final DateTime? lastActive;
  final String? statusTextOverride;
  final VoidCallback onBack;
  final VoidCallback onCall;
  final VoidCallback onVideoCall;

  const ConversationHeader({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.hasReels,
    required this.isOnline,
    required this.lastActive,
    this.statusTextOverride,
    required this.onBack,
    required this.onCall,
    required this.onVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final topPadding = MediaQuery.of(context).padding.top + 10;
    final statusText = statusTextOverride ??
      (isOnline
        ? t.activeNow
        : (lastActive != null
          ? t.activeTimeAgo(time: timeago.format(lastActive!))
          : t.offline));

    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _CircleIconButton(
            onTap: onBack,
            child: Assets.icons.icBack.svg(
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _AvatarCircle(name: name, avatarUrl: avatarUrl, hasReels: hasReels),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.h3.copyWith(color: Colors.black),
                ),
                Text(
                  statusText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
          _CircleIconButton(
            onTap: onCall,
            child: Assets.icons.icCall.image(
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 8),
          _CircleIconButton(
            onTap: onVideoCall,
            child: Assets.icons.icVideoCall.svg(
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _CircleIconButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool hasReels;

  const _AvatarCircle({
    required this.name,
    required this.avatarUrl,
    required this.hasReels,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initials = trimmed.isNotEmpty
        ? trimmed.split(' ').map((p) => p.isNotEmpty ? p[0] : '').join()
        : '?';
    final url = avatarUrl?.trim() ?? '';

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasReels
            ? Border.all(color: Colors.red, width: 2)
            : null,
      ),
      child: CircleAvatar(
        radius: 21,
        backgroundColor: const Color(0xFFE6E6E6),
        foregroundImage: url.isNotEmpty ? NetworkImage(url) : null,
        child: Text(
          initials.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
