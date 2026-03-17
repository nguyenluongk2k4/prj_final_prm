import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';
import '../stores/auth_store.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final _authStore = getIt<AuthStore>();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      await _authStore.changePassword(
        newPassword: _newPasswordController.text,
      );
      if (_authStore.hasSuccess && mounted) {
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
      title: t.changePassword,
      showQuickActions: false,
      showBackButton: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // New password
                AppTextField(
                  controller: _newPasswordController,
                  hint: t.newPasswordHint,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.passwordRequired;
                    }
                    if (value.length < 6) {
                      return t.passwordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm new password
                AppTextField(
                  controller: _confirmPasswordController,
                  hint: t.confirmNewPasswordHint,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.confirmPasswordRequired;
                    }
                    if (value != _newPasswordController.text) {
                      return t.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Error message
                Observer(
                  builder: (_) => _authStore.hasError
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _authStore.errorMessage!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFFE94057),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Success message
                Observer(
                  builder: (_) => _authStore.hasSuccess
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            t.passwordChanged,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                Observer(
                  builder: (_) => AppPrimaryButton(
                    text: t.changePassword,
                    isLoading: _authStore.isLoading,
                    onPressed:
                        _authStore.isLoading ? null : _handleChangePassword,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
