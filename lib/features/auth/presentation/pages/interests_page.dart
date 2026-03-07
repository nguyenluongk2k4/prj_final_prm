import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '../constants/preferences_constants.dart';
import '../stores/interests_store.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  late final List<InterestUI> _interests;
  late final _interestsStore = getIt<InterestsStore>();

  @override
  void initState() {
    super.initState();
    _initializeInterests();
  }

  void _initializeInterests() {
    _interests = PreferencesConstants.allPreferences.map((pref) {
      return InterestUI(
        id: pref.id,
        translationKey: pref.translationKey,
        iconAsset: pref.iconAsset,
        isSelected: false,
      );
    }).toList();
  }

  void _toggleInterest(int index) {
    setState(() {
      _interests[index].isSelected = !_interests[index].isSelected;
    });
  }

  Future<void> _handleContinue() async {
    final selectedIds = _interests
        .where((i) => i.isSelected)
        .map((i) => i.id)
        .toList();

    await _interestsStore.savePreferences(selectedIds);

    if (!mounted) return;
    if (_interestsStore.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_interestsStore.errorMessage!)),
      );
      _interestsStore.clearError();
    } else {
      context.goNamed(AppRoutes.locationName);
    }
  }

  String _getTranslationForPreference(Translations t, String key) {
    switch (key) {
      case 'photography':
        return t.photography;
      case 'shopping':
        return t.shopping;
      case 'karaoke':
        return t.karaoke;
      case 'yoga':
        return t.yoga;
      case 'cooking':
        return t.cooking;
      case 'tennis':
        return t.tennis;
      case 'run':
        return t.run;
      case 'swimming':
        return t.swimming;
      case 'art':
        return t.art;
      case 'traveling':
        return t.traveling;
      case 'extreme':
        return t.extreme;
      case 'music':
        return t.music;
      case 'drink':
        return t.drink;
      case 'videoGames':
        return t.videoGames;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    
    return AppScaffold(
      showBackButton: true,
      showSkipButton: true,
      onSkip: () => context.goNamed(AppRoutes.locationName),
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
                  return _buildInterestChip(t, _interests[index], index);
                },
              ),
            ),
          ),

          // Continue button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Observer(
              builder: (_) => AppPrimaryButton(
                text: t.continueLabel,
                isLoading: _interestsStore.isLoading,
                onPressed: _handleContinue,
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInterestChip(Translations t, InterestUI interest, int index) {
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
                child: _getIcon(interest.iconAsset).svg(
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
                  _getTranslationForPreference(t, interest.translationKey),
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

  SvgGenImage _getIcon(String iconAsset) {
    switch (iconAsset) {
      case 'camera': return Assets.icons.camera;
      case 'shopping': return Assets.icons.shopping;
      case 'voice': return Assets.icons.voice;
      case 'yoga': return Assets.icons.yoga;
      case 'noodles': return Assets.icons.noodles;
      case 'tennis': return Assets.icons.tennis;
      case 'sport': return Assets.icons.sport;
      case 'ripple': return Assets.icons.ripple;
      case 'platte': return Assets.icons.platte;
      case 'outdoor': return Assets.icons.outdoor;
      case 'parachute': return Assets.icons.parachute;
      case 'music': return Assets.icons.music;
      case 'goblet': return Assets.icons.goblet;
      case 'gameHandle': return Assets.icons.gameHandle;
      default: return Assets.icons.camera;
    }
  }
}

class InterestUI {
  final String id;
  final String translationKey;
  final String iconAsset;
  bool isSelected;

  InterestUI({
    required this.id,
    required this.translationKey,
    required this.iconAsset,
    required this.isSelected,
  });
}
