import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../stores/profile_store.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/di/injection.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;
  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _store = getIt<ProfileStore>();
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.userId != null) {
      _store.fetchProfile(widget.userId!);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    // Douyin style: Stay transparent until 100px, then fade in over next 100px
    final opacity = ((offset - 100) / 100).clamp(0.0, 1.0);
    if (opacity != _appBarOpacity) {
      setState(() {
        _appBarOpacity = opacity;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    
    return AppScaffold(
      showBackButton: true,
      showQuickActions: false,
      centerTitle: true,
      backgroundColor: c.background,
      appBarColor: c.background.withValues(alpha: _appBarOpacity),
      extendBodyBehindAppBar: true,
      removeSafeArea: true,
      titleWidget: Observer(
        builder: (_) => Opacity(
          opacity: _appBarOpacity,
          child: Text(
            _store.profile?.displayName ?? '',
            style: AppTextStyles.h3.copyWith(color: c.textPrimary),
          ),
        ),
      ),
      body: Observer(
        builder: (_) {
          if (_store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (_store.error != null) {
            return Center(child: Text(_store.error!));
          }

          final profile = _store.profile;
          if (profile == null) {
            return Center(child: Text(t.error));
          }

          return _ScrollBody(
            c: c, 
            t: t,
            profile: profile, 
            showActions: _store.showActions,
            scrollController: _scrollController,
          );
        },
      ),
    );
  }
}

// ─── Scrollable body ──────────────────────────────────────────────────────────

class _ScrollBody extends StatelessWidget {
  const _ScrollBody({
    required this.c, 
    required this.t,
    required this.profile, 
    required this.showActions,
    required this.scrollController,
  });
  final AppColorScheme c;
  final Translations t;
  final UserProfile profile;
  final bool showActions;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero photo ───────────────────────────────────────────────
          _HeroPhoto(avatarUrl: profile.avatarUrl),

          // ── White card ───────────────────────────────────────────────
          Transform.translate(
            offset: const Offset(0, -30),
            child: Container(
              decoration: BoxDecoration(
                color: c.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Action buttons ───────────────────────────────────
                  if (showActions) _ActionButtons(),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Name & title ─────────────────────────────
                        _NameSection(c: c, profile: profile),

                        const SizedBox(height: 20),

                        // ── Location ─────────────────────────────────
                        _LocationSection(c: c, t: t, profile: profile),

                        const SizedBox(height: 20),

                        // ── About ────────────────────────────────────
                        _AboutSection(c: c, t: t, profile: profile),

                        const SizedBox(height: 20),

                        // ── Interests ────────────────────────────────
                        _InterestsSection(c: c, t: t, profile: profile),

                        const SizedBox(height: 20),

                        // ── Gallery ──────────────────────────────────
                        _GallerySection(c: c, t: t),

                        SizedBox(
                          height:
                              24 + MediaQuery.of(context).padding.bottom,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero photo section ───────────────────────────────────────────────────────

class _HeroPhoto extends StatelessWidget {
  final String? avatarUrl;
  const _HeroPhoto({this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      height: 480, // Slightly taller for better bleed effect
      child: avatarUrl != null && avatarUrl!.startsWith('http')
          ? Image.network(
              avatarUrl!,
              width: screenWidth,
              height: 480,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/profile_main_photo.png',
                width: screenWidth,
                height: 480,
                fit: BoxFit.cover,
              ),
            )
          : Image.asset(
              'assets/images/profile_main_photo.png',
              width: screenWidth,
              height: 480,
              fit: BoxFit.cover,
            ),
    );
  }
}

// ─── Action buttons (Like / Close / Star) ────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final c = context.appColors;

    return Transform.translate(
      offset: const Offset(0, -32),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dislike button
            GestureDetector(
              onTap: () {},
              child: Container(
                width: screenWidth * 0.21,
                height: screenWidth * 0.21,
                decoration: BoxDecoration(
                  color: c.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    color: Color(0xFFF27121),
                    size: 32,
                  ),
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.043),

            // Like button
            GestureDetector(
              onTap: () {},
              child: Container(
                width: screenWidth * 0.264,
                height: screenWidth * 0.264,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE94057), Color(0xFFF27121)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE94057).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.043),

            // Super like button
            GestureDetector(
              onTap: () {},
              child: Container(
                width: screenWidth * 0.21,
                height: screenWidth * 0.21,
                decoration: BoxDecoration(
                  color: c.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.star,
                    color: Color(0xFF8A2387),
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Name section ─────────────────────────────────────────────────────────────

class _NameSection extends StatelessWidget {
  const _NameSection({required this.c, required this.profile});
  final AppColorScheme c;
  final UserProfile profile;

  int _calculateAge(DateTime birthDate) {
    DateTime now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final age = profile.birthDate != null ? _calculateAge(profile.birthDate!) : null;
    final nameText = age != null ? '${profile.displayName}, $age' : profile.displayName;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nameText,
                style: AppTextStyles.h2.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile.bio != null && profile.bio!.isNotEmpty 
                  ? profile.bio!.split('.').first 
                  : t.userTitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: c.text70,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.mainGradient,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Location section ─────────────────────────────────────────────────────────

class _LocationSection extends StatelessWidget {
  const _LocationSection({required this.c, required this.t, required this.profile});
  final AppColorScheme c;
  final Translations t;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.location,
          style: AppTextStyles.h3.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on_rounded,
                color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Province ID: ${profile.provinceId ?? "Unknown"}', // Placeholder until we have province names
                style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded,
                      color: AppColors.primary, size: 12),
                  const SizedBox(width: 3),
                  Text(
                    '1 ${t.distanceUnit}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── About section ────────────────────────────────────────────────────────────

class _AboutSection extends StatefulWidget {
  const _AboutSection({required this.c, required this.t, required this.profile});
  final AppColorScheme c;
  final Translations t;
  final UserProfile profile;

  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.t.about,
          style: AppTextStyles.h3.copyWith(color: widget.c.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          widget.profile.bio ?? t.noBio,
          maxLines: _expanded ? null : 3,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(color: widget.c.text70),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? widget.t.showLess : widget.t.readMore,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Interests section ────────────────────────────────────────────────────────

class _InterestsSection extends StatelessWidget {
  const _InterestsSection({required this.c, required this.t, required this.profile});
  final AppColorScheme c;
  final Translations t;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final List<String> interests = profile.interests ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.interests,
          style: AppTextStyles.h3.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: 12),
        if (interests.isEmpty)
          Text(t.noInterests, style: AppTextStyles.bodySmall.copyWith(color: c.text70)),
        if (interests.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: interests.map((i) => _InterestChip(interest: _Interest(i, true))).toList(),
          ),
      ],
    );
  }
}

class _Interest {
  const _Interest(this.label, this.active);
  final String label;
  final bool active;
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({required this.interest});
  final _Interest interest;

  @override
  Widget build(BuildContext context) {
    final active = interest.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (active) ...[
            Icon(Icons.check_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
          ],
          Text(
            interest.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: active ? AppColors.primary : AppColors.border,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gallery section ──────────────────────────────────────────────────────────

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.c, required this.t});
  final AppColorScheme c;
  final Translations t;

  static const _photos = [
    'assets/images/gallery_1.png',
    'assets/images/gallery_2.png',
    'assets/images/gallery_3.png',
    'assets/images/gallery_4.png',
    'assets/images/gallery_5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.gallery,
              style: AppTextStyles.h3.copyWith(color: c.textPrimary),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See all',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Gallery grid: 2 tall on left/right, 3 medium in center column
        SizedBox(
          height: 200,
          child: Row(
            children: [
              // Left tall photo
              Expanded(
                flex: 5,
                child: _GalleryPhoto(path: _photos[0], borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                )),
              ),
              const SizedBox(width: 6),
              // Center column – 3 photos stacked
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: _GalleryPhoto(path: _photos[1]),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: _GalleryPhoto(path: _photos[2]),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: _GalleryPhoto(path: _photos[3]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Right tall photo
              Expanded(
                flex: 5,
                child: _GalleryPhoto(path: _photos[4], borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GalleryPhoto extends StatelessWidget {
  const _GalleryPhoto({required this.path, this.borderRadius});
  final String path;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
