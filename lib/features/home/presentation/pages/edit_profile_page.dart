import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';
import '../../../auth/presentation/stores/auth_store.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _authStore = GetIt.I<AuthStore>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  String? _gender;
  String? _targetGender;

  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = _authStore.currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _gender = user?.gender;
    _targetGender = user?.targetGender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    await _authStore.updateProfile(
      name: _nameController.text,
      phone: _phoneController.text,
      bio: _bioController.text,
      gender: _gender,
      targetGender: _targetGender,
      birthDate: _authStore.currentUser?.birthDate,
      provinceId: _authStore.currentUser?.provinceId,
    );
    if (mounted && !_authStore.hasError) {
      context.pop();
    } else if (mounted && _authStore.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authStore.errorMessage!)),
      );
    }
  }

  bool _isPickingImage = false;

  Future<void> _pickAndUploadImage() async {
    if (_isPickingImage) return;

    try {
      setState(() => _isPickingImage = true);
      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await _authStore.uploadAvatar(File(pickedFile.path));
        if (mounted) {
          if (_authStore.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_authStore.errorMessage!)),
            );
          } else if (_authStore.hasSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_authStore.successMessage!)),
            );
          }
        }
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Try to get translations, fallback to English text if necessary
    final c = context.appColors;
    final t = Translations.of(context);

    return AppScaffold(
      titleWidget: Text(
        t.editProfile, // use localized string if available
        style: AppTextStyles.h2.copyWith(color: c.textPrimary),
      ),
      showBackButton: true,
      showQuickActions: false,
      body: Observer(
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Upload Section
                Center(
                  child: Column(
                    children: [
                      ClipOval(
                        child: _authStore.currentUser?.avatarUrl != null && _authStore.currentUser!.avatarUrl!.isNotEmpty
                            ? Image.network(
                                _authStore.currentUser!.avatarUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Assets.images.chatActivityYou.image(
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Assets.images.chatActivityYou.image(
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 12),
                      AppOutlineButton(
                        text: t.uploadNewPicture,
                        onPressed: _authStore.isLoading ? null : _pickAndUploadImage,
                        isLoading: _authStore.isLoading,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  label: t.name,
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: t.myMobileNumber,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: t.bio,
                  controller: _bioController,
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                Text(
                  t.yourGender,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildGenderDropdown(
                  value: _gender,
                  onChanged: (val) {
                    setState(() {
                      _gender = val;
                    });
                  },
                  context: context,
                ),
                const SizedBox(height: 24),
                Text(
                  t.lookingFor,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildGenderDropdown(
                  value: _targetGender,
                  onChanged: (val) {
                    setState(() {
                      _targetGender = val;
                    });
                  },
                  context: context,
                ),
                const SizedBox(height: 48),
                AppPrimaryButton(
                  text: t.saveChanges,
                  onPressed: _authStore.isLoading ? null : _saveProfile,
                  isLoading: _authStore.isLoading,
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    // using AppTextField instead of building a custom container
    return AppTextField(
      controller: controller,
      hint: label,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildGenderDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
    required BuildContext context,
  }) {
    final c = context.appColors;
    final t = Translations.of(context);
    // Use underlying keys for values, map them for display
    final List<String> genders = ['male', 'female', 'other'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: c.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value != null && value.isNotEmpty
              ? genders.firstWhere(
                  (g) => g.toLowerCase() == value.toLowerCase(),
                  orElse: () => genders.first)
              : null,
          isExpanded: true,
          hint: Text(
            t.selectGender,
            style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
          ),
          dropdownColor: c.backgroundSecondary,
          style: AppTextStyles.bodyMedium.copyWith(color: c.textPrimary),
          items: genders.map((String gender) {
            String localizedText = gender;
            if (gender == 'male') localizedText = t.male;
            if (gender == 'female') localizedText = t.female;
            if (gender == 'other') localizedText = t.other;

            return DropdownMenuItem<String>(
              value: gender,
              child: Text(localizedText),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
