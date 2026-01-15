import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  late final List<Interest> _interests = [
    Interest(name: t.photography, icon: '177:332', isSelected: false),
    Interest(name: t.shopping, icon: '177:328', isSelected: true),
    Interest(name: t.karaoke, icon: '177:324', isSelected: false),
    Interest(name: t.yoga, icon: '177:334', isSelected: false),
    Interest(name: t.cooking, icon: '177:329', isSelected: false),
    Interest(name: t.tennis, icon: '177:325', isSelected: false),
    Interest(name: t.run, icon: '177:326', isSelected: true),
    Interest(name: t.swimming, icon: '177:336', isSelected: false),
    Interest(name: t.art, icon: '177:327', isSelected: false),
    Interest(name: t.traveling, icon: '177:333', isSelected: true),
    Interest(name: t.extreme, icon: '177:330', isSelected: false),
    Interest(name: t.music, icon: '177:401', isSelected: false),
    Interest(name: t.drink, icon: '177:335', isSelected: false),
    Interest(name: t.videoGames, icon: '177:337', isSelected: false),
  ];

  void _toggleInterest(int index) {
    setState(() {
      _interests[index].isSelected = !_interests[index].isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      showSkipButton: true,
      onSkip: () => context.goNamed(AppRoutes.homeName),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Title and description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.yourInterests, style: AppTextStyles.h1),
                const SizedBox(height: 12),
                Text(
                  t.interestsDesc,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Interests grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 10,
                  childAspectRatio: 140 / 45,
                ),
                itemCount: _interests.length,
                itemBuilder: (context, index) {
                  return _buildInterestChip(_interests[index], index);
                },
              ),
            ),
          ),

          // Continue button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AppPrimaryButton(
              text: t.continueLabel,
              onPressed: () {
                context.pushNamed(AppRoutes.friendsName);
              },
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInterestChip(Interest interest, int index) {
    return GestureDetector(
      onTap: () => _toggleInterest(index),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: interest.isSelected ? AppColors.primary : AppColors.background,
          border: Border.all(
            color: interest.isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: interest.isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 15),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              // Icon from assets
              SizedBox(
                width: 19,
                height: 19,
                child: _getIcon(interest.name).svg(
                  colorFilter: ColorFilter.mode(
                    interest.isSelected
                        ? AppColors.textWhite
                        : AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  interest.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: interest.isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: interest.isSelected
                        ? AppColors.textWhite
                        : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SvgGenImage _getIcon(String name) {
    if (name == t.photography) return Assets.icons.camera;
    if (name == t.shopping) return Assets.icons.shopping;
    if (name == t.karaoke) return Assets.icons.voice;
    if (name == t.yoga) return Assets.icons.yoga;
    if (name == t.cooking) return Assets.icons.noodles;
    if (name == t.tennis) return Assets.icons.tennis;
    if (name == t.run) return Assets.icons.sport;
    if (name == t.swimming) return Assets.icons.ripple;
    if (name == t.art) return Assets.icons.platte;
    if (name == t.traveling) return Assets.icons.outdoor;
    if (name == t.extreme) return Assets.icons.parachute;
    if (name == t.music) return Assets.icons.music;
    if (name == t.drink) return Assets.icons.goblet;
    if (name == t.videoGames) return Assets.icons.gameHandle;
    return Assets.icons.camera;
  }
}

class Interest {
  final String name;
  final String icon;
  bool isSelected;

  Interest({required this.name, required this.icon, required this.isSelected});
}
