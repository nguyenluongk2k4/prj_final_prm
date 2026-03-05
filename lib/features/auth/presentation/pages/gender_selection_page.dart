import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';
import '../stores/auth_store.dart';

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  final _authStore = getIt<AuthStore>();
  String? _selectedGender;
  String? _selectedTargetGender;

  @override
  void initState() {
    super.initState();
    final user = _authStore.currentUser;
    if (user != null) {
      _selectedGender = user.gender;
      _selectedTargetGender = user.targetGender;
    }
  }

  void _handleContinue() async {
    if (_selectedGender == null || _selectedTargetGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đầy đủ thông tin')),
      );
      return;
    }

    final user = _authStore.currentUser;
    if (user != null) {
      await _authStore.updateProfile(
        name: user.name ?? '',
        phone: user.phone ?? '',
        bio: user.bio ?? '',
        gender: _selectedGender,
        targetGender: _selectedTargetGender,
        birthDate: user.birthDate,
        provinceId: user.provinceId,
      );
    }

    if (!mounted) return;

    if (_authStore.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authStore.errorMessage!)),
      );
    } else {
      context.pushNamed(AppRoutes.interestsName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      showSkipButton: true,
      onSkip: () => context.goNamed(AppRoutes.homeName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(t.iAm, style: AppTextStyles.h1),
            const SizedBox(height: 20),
            _buildGenderOption(
              label: t.woman,
              value: 'woman',
              isSelected: _selectedGender == 'woman',
              onSelect: (val) => setState(() => _selectedGender = val),
            ),
            const SizedBox(height: 10),
            _buildGenderOption(
              label: t.man,
              value: 'man',
              isSelected: _selectedGender == 'man',
              onSelect: (val) => setState(() => _selectedGender = val),
            ),
            const SizedBox(height: 10),
            _buildGenderOption(
              label: t.other,
              value: 'other',
              isSelected: _selectedGender == 'other',
              onSelect: (val) => setState(() => _selectedGender = val),
            ),

            const SizedBox(height: 40),
            Text(t.interestedIn, style: AppTextStyles.h1),
            const SizedBox(height: 20),
            _buildGenderOption(
              label: t.woman,
              value: 'woman',
              isSelected: _selectedTargetGender == 'woman',
              onSelect: (val) => setState(() => _selectedTargetGender = val),
            ),
            const SizedBox(height: 10),
            _buildGenderOption(
              label: t.man,
              value: 'man',
              isSelected: _selectedTargetGender == 'man',
              onSelect: (val) => setState(() => _selectedTargetGender = val),
            ),
            const SizedBox(height: 10),
            _buildGenderOption(
              label: t.both,
              value: 'both',
              isSelected: _selectedTargetGender == 'both',
              onSelect: (val) => setState(() => _selectedTargetGender = val),
            ),

            const SizedBox(height: 60),
            Observer(
              builder: (_) => AppPrimaryButton(
                text: t.continueLabel,
                isLoading: _authStore.isLoading,
                onPressed: _handleContinue,
              ),
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
    required Function(String) onSelect,
  }) {
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
