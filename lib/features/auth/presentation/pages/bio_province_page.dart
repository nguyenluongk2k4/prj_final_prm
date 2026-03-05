import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../stores/auth_store.dart';

class BioProvincePage extends StatefulWidget {
  const BioProvincePage({super.key});

  @override
  State<BioProvincePage> createState() => _BioProvincePageState();
}

class _BioProvincePageState extends State<BioProvincePage> {
  final _bioController = TextEditingController();
  final _authStore = getIt<AuthStore>();
  
  int? _selectedProvinceId;

  // Mock list of provinces for the onboarding step.
  final List<Map<String, dynamic>> _provinces = [
    {'id': 1, 'name': 'Hà Nội'},
    {'id': 2, 'name': 'Hồ Chí Minh'},
    {'id': 3, 'name': 'Đà Nẵng'},
    {'id': 4, 'name': 'Hải Phòng'},
    {'id': 5, 'name': 'Cần Thơ'},
    {'id': 6, 'name': 'Nha Trang'},
    {'id': 7, 'name': 'Biên Hòa'},
  ];

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    // If they provided both, we update. Otherwise, we can just skip or enforce it.
    if (_bioController.text.trim().isEmpty || _selectedProvinceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ Giới thiệu và Tỉnh/Thành phố'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _authStore.updateBioAndProvince(
      bio: _bioController.text.trim(),
      provinceId: _selectedProvinceId!,
    );

    if (!mounted) return;

    if (_authStore.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authStore.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      context.goNamed(AppRoutes.homeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: false, // Don't let them go back to location
      showSkipButton: true,
      onSkip: () => context.goNamed(AppRoutes.homeName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              'Tell us about yourself',
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 12),
            Text(
              'Add a short bio and tell us where you live to find the best matches.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 40),

            // Bio Input
            Text(
              'A little about you (Bio)',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _bioController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'I love long walks on the beach...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Province Selection
            Text(
              'Province / City',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedProvinceId,
                  hint: const Text('Select your province'),
                  items: _provinces.map((prov) {
                    return DropdownMenuItem<int>(
                      value: prov['id'] as int,
                      child: Text(prov['name'] as String),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedProvinceId = val;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Submit Button
            Observer(
              builder: (_) => AppPrimaryButton(
                text: 'Finish',
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
}
