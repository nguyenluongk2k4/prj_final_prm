import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/repositories/matches_repository_impl.dart';
import '../../domain/entities/match_profile.dart';
import '../../domain/usecases/get_matches_usecase.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final GetMatchesUseCase _getMatchesUseCase =
      GetMatchesUseCase(MatchesRepositoryImpl());

  late Future<List<MatchProfile>> _matchesFuture;
  bool _filterActive = false;

  @override
  void initState() {
    super.initState();
    _matchesFuture = _getMatchesUseCase();
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
          icon: _filterActive
              ? Assets.icons.icBack.svg(width: 24, height: 24)
              : Assets.icons.icSetting.svg(width: 24, height: 24),
          onTap: () => setState(() => _filterActive = !_filterActive),
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
                    return const Center(child: CircularProgressIndicator());
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

                  return SingleChildScrollView(
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
                            _MatchGrid(profiles: todayMatches),
                          ],

                          // Yesterday section
                          if (yesterdayMatches.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            _SectionDivider(
                              label: t.yesterday,
                              labelOpacity: 0.4,
                            ),
                            const SizedBox(height: 15),
                            _MatchGrid(profiles: yesterdayMatches),
                          ],
                        ],
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
  const _MatchGrid({required this.profiles});

  final List<MatchProfile> profiles;

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
            Expanded(child: _MatchCard(profile: left)),
            const SizedBox(width: 15),
            Expanded(
              child: right != null
                  ? _MatchCard(profile: right)
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

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.profile});

  final MatchProfile profile;

  // Constant colors (avoid withOpacity per-frame)
  static const _bottomOverlayColor = Color(0xFF000000);
  static const _dividerColor = Color(0x80FFFFFF); // white 50%
  static const _nameShadow = Shadow(
    color: Color(0x33000000),
    blurRadius: 2,
  );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 140 / 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Photo ───────────────────────────────────────────────────
            Image.asset(
              profile.imagePath,
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
                '${profile.name}, ${profile.age}',
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
                child: Row(
                  children: [
                    // Dislike button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
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
                        onTap: () {},
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
    );
  }
}
