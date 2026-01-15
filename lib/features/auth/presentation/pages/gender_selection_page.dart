import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      showSkipButton: true,
      onSkip: () => context.goNamed(AppRoutes.homeName),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Title
            Text(t.iAm, style: AppTextStyles.h1),

            const SizedBox(height: 91),

            // Woman option
            _buildGenderOption(
              label: t.woman,
              value: 'woman',
              isSelected: _selectedGender == 'woman',
            ),

            const SizedBox(height: 10),

            // Man option
            _buildGenderOption(
              label: t.man,
              value: 'man',
              isSelected: _selectedGender == 'man',
            ),

            const SizedBox(height: 10),

            // Choose another option
            _buildGenderOption(
              label: t.other,
              value: 'other',
              isSelected: _selectedGender == 'other',
              isOther: true,
            ),

            const Spacer(),

            // Continue button
            AppPrimaryButton(
              text: t.continueLabel,
              onPressed: _selectedGender != null
                  ? () {
                      context.pushNamed(AppRoutes.interestsName);
                    }
                  : null,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption({
    required String label,
    required String value,
    required bool isSelected,
    bool isOther = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.textWhite
                      : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (isSelected && !isOther)
                const Icon(Icons.check, color: AppColors.textWhite, size: 20)
              else if (isOther)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textPrimary,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
