import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/friend_profile.dart';
import '../stores/friend_list_store.dart';
import '../widgets/chat_filter_sheet.dart';
import 'conservation_detail.dart';

// ─── Data model ──────────────────────────────────────────────────────────────

// ─── Page ─────────────────────────────────────────────────────────────────────

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final _store = GetIt.I<FriendListStore>();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _store.fetchFriends();
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null) {
      _currentUserId = currentUser.id;
      _store.startRealtime(currentUser.id);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _store.stopRealtime();
    super.dispose();
  }

  List<FriendProfile> _filtered(List<FriendProfile> friends) {
    if (_searchQuery.isEmpty) return friends;
    final q = _searchQuery.toLowerCase();
    return friends.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

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
      body: Observer(builder: (context) {
        if (_store.isLoading && _store.friends.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_store.error != null && _store.friends.isEmpty) {
          return Center(
            child: Text(
              _store.error!,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
            ),
          );
        }

        final friends = _filtered(_store.friends.toList());

        return RefreshIndicator(
          onRefresh: () async {
            await _store.fetchFriends();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
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
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 12),
                  child: Text(t.activities, style: AppTextStyles.h3),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: friends.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 20),
                    itemBuilder: (_, i) =>
                        _ActivityAvatar(friend: friends[i]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 6),
                  child: Text(t.messages, style: AppTextStyles.h3),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 100 + MediaQuery.of(context).padding.bottom,
                ),
                sliver: SliverList.separated(
                  itemCount: friends.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: c.border,
                  ),
                  itemBuilder: (_, i) => _MessageTile(
                    friend: friends[i],
                    currentUserId: _currentUserId,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ConservationDetailPage(
                          name: friends[i].name,
                          avatarUrl: friends[i].avatarUrl,
                          userId: friends[i].friendId,
                          hasReels: friends[i].hasReels,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─── Activity bubble ─────────────────────────────────────────────────────────

class _ActivityAvatar extends StatelessWidget {
  final FriendProfile friend;
  const _ActivityAvatar({required this.friend});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: friend.hasReels ? Colors.red : c.border,
                  width: 2.5,
                ),
              ),
              child: ClipOval(
                child: friend.avatarUrl != null
                    ? Image.network(friend.avatarUrl!, fit: BoxFit.cover)
                    : Icon(Icons.person, color: c.text70),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: friend.isOnline
                      ? const Color(0xFF2ECC71)
                      : const Color(0xFFB0B3B8),
                  shape: BoxShape.circle,
                  border: Border.all(color: c.background, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          friend.name,
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
  final FriendProfile friend;
  final String? currentUserId;
  final VoidCallback? onTap;
  const _MessageTile({
    required this.friend,
    this.currentUserId,
    this.onTap,
  });

  String _buildLastMessagePreview(BuildContext context) {
    final t = context.t;
    final type = friend.lastMessageType;
    final senderId = friend.lastMessageSenderId;
    final senderName = senderId == null
        ? friend.name
        : (senderId == currentUserId ? t.you : friend.name);

    switch (type) {
      case LastMessageType.text:
        return friend.lastMessageContent ?? '';
      case LastMessageType.image:
        return '$senderName ${t.sentImage}';
      case LastMessageType.file:
        return '$senderName ${t.sentFile}';
      case LastMessageType.voice:
        return '$senderName ${t.sentVoice}';
      case LastMessageType.unknown:
      default:
        return '';
    }
  }

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
                child: friend.avatarUrl != null
                    ? Image.network(
                        friend.avatarUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        color: c.backgroundSecondary,
                        child: Icon(Icons.person, color: c.text70),
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
                    color: friend.isOnline
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFB0B3B8),
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
                  friend.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _buildLastMessagePreview(context),
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
                timeago.format(friend.lastMessageAt ?? friend.createdAt),
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFFADAFBB),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
