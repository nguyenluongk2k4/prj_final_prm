import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final t = Translations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    String? emailErr;
    String? passErr;

    if (email.isEmpty ||
        !RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(email)) {
      emailErr = t.invalidEmail;
    }
    if (password.isEmpty) {
      passErr = t.pleaseEnterPassword;
    }

    setState(() {
      _emailError = emailErr;
      _passwordError = passErr;
    });

    if (emailErr == null && passErr == null) {
      // TODO: wire to AuthStore
      context.pushNamed(AppRoutes.homeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
      showBackButton: true,
      showQuickActions: false,
      secondaryAction: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: AppBarIconButton(
          icon: Assets.icons.icSetting.svg(width: 24, height: 24),
          onTap: () => context.push(AppRoutes.settings),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 42),

            // ── Title ────────────────────────────────────────────────────
            Text(t.myEmail, style: AppTextStyles.h1),

            const SizedBox(height: 16),

            Text(
              t.emailLoginDesc,
              style: AppTextStyles.bodyMedium.copyWith(
                color: c.text70,
              ),
            ),

            const SizedBox(height: 48),

            // ── Email field ───────────────────────────────────────────────
            AppTextField(
              controller: _emailController,
              hint: t.emailHint,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              prefixIcon: Icon(
                Icons.mail_outline,
                size: 22,
                color: c.text70,
              ),
            ),

            const SizedBox(height: 16),

            // ── Password field ────────────────────────────────────────────
            AppTextField(
              controller: _passwordController,
              hint: t.passwordHint,
              obscureText: _obscurePassword,
              errorText: _passwordError,
              prefixIcon: Icon(
                Icons.lock_outline,
                size: 22,
                color: c.text70,
              ),
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 22,
                  color: c.text70,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Forgot password ───────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {}, // TODO: forgot password flow
                child: Text(
                  t.forgotPassword,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // ── Login button ─────────────────────────────────────────────
            AppPrimaryButton(
              text: t.login,
              onPressed: _submit,
            ),

            const SizedBox(height: 24),

            // ── Sign-up footer ────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.noAccount,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: c.text70,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => context.pushNamed(AppRoutes.emailRegisterName),
                  child: Text(
                    t.signUpNow,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
