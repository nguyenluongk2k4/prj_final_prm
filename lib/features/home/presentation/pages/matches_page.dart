import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/repositories/matches_repository_impl.dart';
import '../../domain/entities/match_profile.dart';
import '../../domain/usecases/get_matches_usecase.dart';
import '../../../chat/presentation/widgets/chat_filter_sheet.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/di/injection.dart';
import '../../../chat/domain/usecases/update_friend_status_usecase.dart';
import '../../../chat/domain/entities/friend_profile.dart';
import '../../infrastructure/datasources/matches_datasource.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  late final GetMatchesUseCase _getMatchesUseCase;

  late Future<List<MatchProfile>> _matchesFuture;
  @override
  void initState() {
    super.initState();
    _getMatchesUseCase = GetMatchesUseCase(
      MatchesRepositoryImpl(MatchesDatasource(Supabase.instance.client)),
    );
    _matchesFuture = _getMatchesUseCase();
  }

  Future<void> _refreshMatches() async {
    setState(() {
      _matchesFuture = _getMatchesUseCase();
    });
    await _matchesFuture;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
      titleWidget: Text(
        t.matches,
        style: AppTextStyles.h1.copyWith(color: c.textPrimary),
      ),
      centerTitle: false,
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
            // ── Description ─────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.only(left: 40, right: 40, top: 8),
              child: Text(
                t.matchesDesc,
                style:
                    AppTextStyles.bodyLarge.copyWith(color: c.text70),
              ),
            ),

            // ── Scrollable content ──────────────────────────────────────
            Expanded(
              child: FutureBuilder<List<MatchProfile>>(
                future: _matchesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Text(
                        t.error,
                        style:
                            AppTextStyles.bodyMedium.copyWith(color: c.textPrimary),
                      ),
                    );
                  }

                  final all = snapshot.data!;
                  final now = DateTime.now();

                  final todayMatches = all
                      .where(
                        (m) =>
                            m.matchedAt.year == now.year &&
                            m.matchedAt.month == now.month &&
                            m.matchedAt.day == now.day,
                      )
                      .toList();

                  final yesterdayMatches = all
                      .where((m) {
                        final diff = now.difference(m.matchedAt);
                        return diff.inHours >= 24 && diff.inHours < 48;
                      })
                      .toList();

                  return RefreshIndicator(
                    onRefresh: _refreshMatches,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 100 + MediaQuery.of(context).padding.bottom),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Today section
                            if (todayMatches.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              _SectionDivider(
                                label: t.today,
                              ),
                              const SizedBox(height: 15),
                              _MatchGrid(
                                profiles: todayMatches,
                                onActionComplete: _refreshMatches,
                              ),
                            ],
  
                            // Yesterday section
                            if (yesterdayMatches.isNotEmpty) ...[
                              const SizedBox(height: 28),
                              _SectionDivider(
                                label: t.yesterday,
                                labelOpacity: 0.4,
                              ),
                              const SizedBox(height: 15),
                              _MatchGrid(
                                profiles: yesterdayMatches,
                                onActionComplete: _refreshMatches,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section divider: "── Today ──"
// ─────────────────────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({
    required this.label,
    this.labelOpacity = 0.7,
  });

  final String label;
  final double labelOpacity;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final dividerColor = c.border;
    final textColor = c.textPrimary.withOpacity(labelOpacity);

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: textColor),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2-column grid of match cards
// ─────────────────────────────────────────────────────────────────────────────

class _MatchGrid extends StatelessWidget {
  const _MatchGrid({
    required this.profiles,
    required this.onActionComplete,
  });

  final List<MatchProfile> profiles;
  final VoidCallback onActionComplete;

  @override
  Widget build(BuildContext context) {
    // Build rows of 2 cards
    final rows = <Widget>[];
    for (int i = 0; i < profiles.length; i += 2) {
      final left = profiles[i];
      final right = (i + 1 < profiles.length) ? profiles[i + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(child: _MatchCard(profile: left, onActionComplete: onActionComplete)),
            const SizedBox(width: 15),
            Expanded(
              child: right != null
                  ? _MatchCard(profile: right, onActionComplete: onActionComplete)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < profiles.length) {
        rows.add(const SizedBox(height: 15));
      }
    }

    return Column(children: rows);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual match card (Figma: 140×200, photo + name + like/dislike bar)
// ─────────────────────────────────────────────────────────────────────────────

class _MatchCard extends StatefulWidget {
  const _MatchCard({
    required this.profile,
    required this.onActionComplete,
  });

  final MatchProfile profile;
  final VoidCallback onActionComplete;

  @override
  State<_MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<_MatchCard> {
  // Constant colors (avoid withOpacity per-frame)
  static const _bottomOverlayColor = Color(0xFF000000);
  static const _dividerColor = Color(0x80FFFFFF); // white 50%
  static const _nameShadow = Shadow(
    color: Color(0x33000000),
    blurRadius: 2,
  );

  bool _isLoading = false;

  void _handleAction(FriendStatus status) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final useCase = getIt<UpdateFriendStatusUseCase>();
    final result = await useCase.execute(
      swipedId: widget.profile.id,
      status: status,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status == FriendStatus.accepted ? 'Added to friends!' : 'Match hidden.'),
            duration: const Duration(seconds: 2),
          ),
        );
        widget.onActionComplete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 140 / 200,
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRoutes.profileName,
            pathParameters: {'userId': widget.profile.id},
          );
        },
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
          children: [
            // ── Photo ───────────────────────────────────────────────────
            if (widget.profile.avatarUrl != null && widget.profile.avatarUrl!.isNotEmpty)
              Image.network(
                widget.profile.avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  Assets.images.profileExample.path,
                  fit: BoxFit.cover,
                ),
              )
            else
              Image.asset(
                widget.profile.imagePath ?? Assets.images.profileExample.path,
                fit: BoxFit.cover,
              ),

            // ── Bottom gradient overlay ──────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 120,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _bottomOverlayColor.withOpacity(0),
                      _bottomOverlayColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),

            // ── Name text ───────────────────────────────────────────────
            Positioned(
              left: 16,
              right: 16,
              // 200 total - 40 bottom bar - 24 text - some padding
              bottom: 48,
              child: Text(
                '${widget.profile.name}, ${widget.profile.age}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: const [_nameShadow],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ── Bottom action bar (40px) ─────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 40,
              child: Container(
                color: Colors.black,
                child: _isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          // Dislike button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _handleAction(FriendStatus.rejected),
                              behavior: HitTestBehavior.opaque,
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),

                          // Divider
                          Container(
                            width: 1,
                            height: 40,
                            color: _dividerColor,
                          ),

                          // Like button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _handleAction(FriendStatus.accepted),
                              behavior: HitTestBehavior.opaque,
                              child: const Center(
                                child: Icon(
                                  Icons.favorite,
                                  color: Color(0xFFE94057),
                                  size: 18,
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
      ),
    );
  }
}
