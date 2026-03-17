import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';
import '../stores/auth_store.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late final _authStore = getIt<AuthStore>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleReset() async {
    if (_formKey.currentState!.validate()) {
      await _authStore.resetPassword(email: _emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
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
                const SizedBox(height: 40),
                Text(
                  t.resetPassword,
                  style: AppTextStyles.h1.copyWith(color: c.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  t.resetPasswordDesc,
                  style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                AppTextField(
                  controller: _emailController,
                  hint: t.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.emailRequired;
                    }
                    if (!value.contains('@')) {
                      return t.invalidEmail;
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
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            t.resetLinkSent,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),

                Observer(
                  builder: (_) => AppPrimaryButton(
                    text: t.sendResetLink,
                    isLoading: _authStore.isLoading,
                    onPressed: _authStore.isLoading ? null : _handleReset,
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: TextButton(
                    onPressed: () => context.goNamed(AppRoutes.loginName),
                    child: Text(
                      t.backToLogin,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: c.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
