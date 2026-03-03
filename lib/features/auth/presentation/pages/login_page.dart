import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';
import '../stores/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final _authStore = getIt<AuthStore>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStore.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await _authStore.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      if (_authStore.isAuthenticated && mounted) {
        context.goNamed(AppRoutes.homeName);
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
                  t.login,
                  style: AppTextStyles.h1.copyWith(color: c.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome back',
                  style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Email field
                AppTextField(
                  controller: _emailController,
                  hint: t.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                AppTextField(
                  controller: _passwordController,
                  hint: t.password,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
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

                // Login button
                Observer(
                  builder: (_) => AppPrimaryButton(
                    text: t.login,
                    isLoading: _authStore.isLoading,
                    onPressed: _authStore.isLoading ? null : _handleLogin,
                  ),
                ),
                const SizedBox(height: 16),

                // Sign up link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
                      children: [
                        TextSpan(
                          text: t.signUpNow,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: c.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => context.pushNamed(AppRoutes.signupName),
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
