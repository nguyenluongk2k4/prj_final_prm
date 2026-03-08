import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/friend_profile.dart';
import '../stores/friend_list_store.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  final _store = GetIt.I<FriendListStore>();

  @override
  void initState() {
    super.initState();
    _store.fetchFriends();
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null) {
      _store.startRealtime(currentUser.id);
    }
  }

  @override
  void dispose() {
    _store.stopRealtime();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    
    return AppScaffold(
      showBackButton: true,
      showQuickActions: false,
      titleWidget: Text(
        t.friendList,
        style: AppTextStyles.h2.copyWith(color: c.textPrimary),
      ),
      body: Observer(
        builder: (context) {
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

          if (_store.friends.isEmpty) {
            return Center(
              child: Text(
                'No friends yet.',
                style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _store.fetchFriends,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: _store.friends.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final friend = _store.friends[index];
                return _FriendListItem(friend: friend);
              },
            ),
          );
        },
      ),
    );
  }
}

class _FriendListItem extends StatelessWidget {
  final FriendProfile friend;

  const _FriendListItem({required this.friend});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.profileName,
          pathParameters: {'userId': friend.friendId},
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: c.backgroundSecondary,
                backgroundImage: friend.avatarUrl != null
                    ? NetworkImage(friend.avatarUrl!)
                    : null,
                child: friend.avatarUrl == null
                    ? Icon(Icons.person, color: c.text70, size: 28)
                    : null,
              ),
              if (friend.isOnline)
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: AppTextStyles.h3.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusText(friend.status, t),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _getStatusColor(friend.status, context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timeago.format(friend.lastMessageAt ?? friend.createdAt),
            style: AppTextStyles.bodySmall.copyWith(color: c.text70),
          ),
        ],
      ),
    );
  }

  String _getStatusText(FriendStatus status, Translations t) {
    switch (status) {
      case FriendStatus.pending:
        return t.today; 
      case FriendStatus.accepted:
        return t.friendList; 
      case FriendStatus.rejected:
        return t.dislike;
    }
  }

  Color _getStatusColor(FriendStatus status, BuildContext context) {
    final c = context.appColors;
    switch (status) {
      case FriendStatus.pending:
        return Colors.orange;
      case FriendStatus.accepted:
        return AppColors.primary;
      case FriendStatus.rejected:
        return Colors.red;
    }
  }
}
