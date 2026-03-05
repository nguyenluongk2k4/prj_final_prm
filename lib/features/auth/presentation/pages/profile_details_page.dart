import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/di/injection.dart';
import '../stores/auth_store.dart';
import '../../../../i18n/strings.g.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedDateS;
  DateTime? _birthDate;
  final _authStore = getIt<AuthStore>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final user = _authStore.currentUser;
    if (user != null) {
      if (user.name != null) {
        final parts = user.name!.split(' ');
        if (parts.length > 1) {
          _firstNameController.text = parts.first;
          _lastNameController.text = parts.sublist(1).join(' ');
        } else {
          _firstNameController.text = user.name!;
        }
      }
      _phoneController.text = user.phone ?? '';
      if (user.birthDate != null) {
        _birthDate = user.birthDate;
        _selectedDateS = '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}';
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1997, 9, 22),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _selectedDateS =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _handleContinue() async {
    if (_firstNameController.text.trim().isEmpty || _lastNameController.text.trim().isEmpty || _birthDate == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    await _authStore.updateProfile(
      name: '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
      phone: _phoneController.text.trim(),
      bio: _authStore.currentUser?.bio ?? '',
      birthDate: _birthDate,
      gender: _authStore.currentUser?.gender,
      targetGender: _authStore.currentUser?.targetGender,
      provinceId: _authStore.currentUser?.provinceId,
    );

    if (!mounted) return;

    if (_authStore.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authStore.errorMessage!)),
      );
    } else {
      context.pushNamed(AppRoutes.genderSelectionName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      showSkipButton: true,
      onSkip: () => context.goNamed(AppRoutes.homeName),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Title
              Text(t.profileDetails, style: AppTextStyles.h1),

              const SizedBox(height: 40),

              // Profile photo
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 99,
                      height: 99,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(25),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profile_photo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppColors.textWhite,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 37),

              // First name input
              _buildInputField(
                controller: _firstNameController,
                label: t.firstName,
              ),

              const SizedBox(height: 5),

              // Last name input
              _buildInputField(
                controller: _lastNameController,
                label: t.lastName,
              ),

              const SizedBox(height: 5),

              // Birthday input
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 17.5),
                        Text(
                          _selectedDateS ?? t.birthday,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Phone number input
              _buildInputField(
                controller: _phoneController,
                label: 'Phone number',
              ),

              const SizedBox(height: 86),

              // Confirm button
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
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Container(
          margin: const EdgeInsets.only(left: 28),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          color: AppColors.background,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // Input field
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
