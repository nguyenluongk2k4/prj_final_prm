import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';
import '../stores/auth_store.dart';

class EmailRegisterPage extends StatefulWidget {
  const EmailRegisterPage({super.key});

  @override
  State<EmailRegisterPage> createState() => _EmailRegisterPageState();
}

class _EmailRegisterPageState extends State<EmailRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final _authStore = getIt<AuthStore>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _authStore.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await _authStore.signup(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      if (!mounted) return;

      if (_authStore.isAuthenticated) {
        context.goNamed(AppRoutes.profileDetailsName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
      showQuickActions: false,
      showBackButton: true,
      actions: const [AppBarActions()],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  t.createAnAccount,
                  style: AppTextStyles.h1.copyWith(color: c.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Join our community',
                  style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Name field
                AppTextField(
                  controller: _nameController,
                  hint: t.fullName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email field
                AppTextField(
                  controller: _emailController,
                  hint: t.email,
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
                const SizedBox(height: 16),

                // Password field
                AppTextField(
                  controller: _passwordController,
                  hint: t.password,
                  obscureText: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: c.text70,
                    ),
                  ),
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

                // Confirm password field
                AppTextField(
                  controller: _confirmPasswordController,
                  hint: t.confirmPassword,
                  obscureText: _obscureConfirm,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    child: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: c.text70,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.confirmPasswordRequired;
                    }
                    if (value != _passwordController.text) {
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
                const SizedBox(height: 24),

                // Sign up button
                Observer(
                  builder: (_) => AppPrimaryButton(
                    text: t.signUpNow,
                    isLoading: _authStore.isLoading,
                    onPressed: _authStore.isLoading ? null : _handleRegister,
                  ),
                ),
                const SizedBox(height: 16),

                // Terms & Privacy
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'By signing up, you agree to our ',
                      style: AppTextStyles.bodySmall.copyWith(color: c.text70),
                      children: [
                        TextSpan(
                          text: t.termsOfUse,
                          style: AppTextStyles.bodySmall.copyWith(color: c.primary),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: AppTextStyles.bodySmall.copyWith(color: c.text70),
                        ),
                        TextSpan(
                          text: t.privacyPolicy,
                          style: AppTextStyles.bodySmall.copyWith(color: c.primary),
                        ),
                      ],
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
