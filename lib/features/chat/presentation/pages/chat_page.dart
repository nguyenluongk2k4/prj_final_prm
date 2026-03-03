import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '../widgets/chat_conversation_sheet.dart';
import '../widgets/chat_filter_sheet.dart';

// ─── Data model ──────────────────────────────────────────────────────────────

class _ActivityItem {
  final String name;
  final AssetGenImage image;
  const _ActivityItem({required this.name, required this.image});
}

class _MessageItem {
  final String name;
  final String lastMessage;
  final String time;
  final AssetGenImage avatar;
  final int unread;
  const _MessageItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatar,
    this.unread = 0,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static final List<_ActivityItem> _activities = [
    _ActivityItem(name: 'You', image: Assets.images.chatActivityYou),
    _ActivityItem(name: 'Emma', image: Assets.images.chatActivityEmma),
    _ActivityItem(name: 'Ava', image: Assets.images.chatActivityAva),
    _ActivityItem(name: 'Sophia', image: Assets.images.chatActivitySophia),
    _ActivityItem(name: 'Amelia', image: Assets.images.chatActivityAmelia),
  ];

  static final List<_MessageItem> _messages = [
    _MessageItem(
      name: 'Emelie',
      lastMessage: 'Sticker 😍',
      time: '23 min',
      avatar: Assets.images.chatMsgEmelie,
      unread: 1,
    ),
    _MessageItem(
      name: 'Abigail',
      lastMessage: 'Typing..',
      time: '27 min',
      avatar: Assets.images.chatMsgAbigail,
      unread: 2,
    ),
    _MessageItem(
      name: 'Elizabeth',
      lastMessage: 'Ok, see you then.',
      time: '33 min',
      avatar: Assets.images.chatMsgElizabeth,
    ),
    _MessageItem(
      name: 'Penelope',
      lastMessage: 'You: Hey! What\'s up, long time..',
      time: '50 min',
      avatar: Assets.images.chatMsgPenelope,
    ),
    _MessageItem(
      name: 'Chloe',
      lastMessage: 'You: Hello how are you?',
      time: '55 min',
      avatar: Assets.images.chatMsgChloe,
    ),
    _MessageItem(
      name: 'Grace',
      lastMessage: 'You: Great I will write later..',
      time: '1 hour',
      avatar: Assets.images.chatMsgGrace,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_MessageItem> get _filtered => _searchQuery.isEmpty
      ? _messages
      : _messages
          .where(
            (m) =>
                m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                m.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
      titleWidget: Text(
        t.messages,
        style: AppTextStyles.h1.copyWith(color: c.textPrimary),
      ),
      showQuickActions: false,
      showBackButton: false,
      secondaryAction: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: AppBarIconButton(
          icon: Assets.icons.icSetting.svg(width: 24, height: 24),
          onTap: () => showChatFilterSheet(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: AppTextField(
              controller: _searchController,
              hint: t.searchMessages,
              prefixIcon: Assets.icons.icSearch.svg(
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(c.text70, BlendMode.srcIn),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // ── Activities ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 12),
            child: Text(t.activities, style: AppTextStyles.h3),
          ),

          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _activities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (_, i) => _ActivityAvatar(item: _activities[i]),
            ),
          ),

          // ── Messages header ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 6),
            child: Text(t.messages, style: AppTextStyles.h3),
          ),

          // ── Messages list ───────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: c.border,
              ),
              itemBuilder: (_, i) => _MessageTile(
                item: _filtered[i],
                onTap: () => showChatConversationSheet(
                  context,
                  name: _filtered[i].name,
                  avatar: _filtered[i].avatar,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Activity bubble ─────────────────────────────────────────────────────────

class _ActivityAvatar extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityAvatar({required this.item});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final bool isMe = item.name == 'You';

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isMe
                ? Border.all(color: AppColors.primary, width: 2.5)
                : Border.all(color: c.border, width: 1),
          ),
          child: ClipOval(
            child: item.image.image(fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.name,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── Message list tile ────────────────────────────────────────────────────────

class _MessageTile extends StatelessWidget {
  final _MessageItem item;
  final VoidCallback? onTap;
  const _MessageTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              ClipOval(
                child: item.avatar.image(
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              // Online indicator
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71),
                    shape: BoxShape.circle,
                    border: Border.all(color: c.background, width: 2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          // Name + last message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(color: c.text70),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Time + unread badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.time,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFFADAFBB),
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (item.unread > 0) ...[
                const SizedBox(height: 6),
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${item.unread}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      ),
    );
  }
}
