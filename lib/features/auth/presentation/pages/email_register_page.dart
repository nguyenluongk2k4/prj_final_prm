import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';

class EmailRegisterPage extends StatefulWidget {
  const EmailRegisterPage({super.key});

  @override
  State<EmailRegisterPage> createState() => _EmailRegisterPageState();
}

class _EmailRegisterPageState extends State<EmailRegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final t = Translations.of(context);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    String? nameErr;
    String? emailErr;
    String? passErr;
    String? confirmErr;

    if (name.isEmpty) nameErr = t.pleaseEnterFullName;

    if (email.isEmpty ||
        !RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(email)) {
      emailErr = t.invalidEmail;
    }

    if (password.isEmpty) {
      passErr = t.pleaseEnterPassword;
    } else if (password.length < 6) {
      passErr = t.passwordMinLength;
    }

    if (confirm.isEmpty) {
      confirmErr = t.pleaseEnterPassword;
    } else if (confirm != password) {
      confirmErr = t.passwordsDoNotMatch;
    }

    setState(() {
      _nameError = nameErr;
      _emailError = emailErr;
      _passwordError = passErr;
      _confirmError = confirmErr;
    });

    if (nameErr == null &&
        emailErr == null &&
        passErr == null &&
        confirmErr == null) {
      // TODO: wire to AuthStore / Supabase
      context.pushNamed(AppRoutes.profileDetailsName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AppScaffold(
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 42),

            // ── Title ─────────────────────────────────────────────────────
            Text(t.createAccount, style: AppTextStyles.h1),

            const SizedBox(height: 16),

            Text(
              t.createAccountDesc,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary70,
              ),
            ),

            const SizedBox(height: 40),

            // ── Full name ─────────────────────────────────────────────────
            _FieldLabel(t.fullName),
            const SizedBox(height: 8),
            AppTextField(
              controller: _nameController,
              hint: t.fullNameHint,
              keyboardType: TextInputType.name,
              errorText: _nameError,
              prefixIcon: const Icon(
                Icons.person_outline,
                size: 22,
                color: AppColors.textPrimary70,
              ),
            ),

            const SizedBox(height: 20),

            // ── Email ─────────────────────────────────────────────────────
            _FieldLabel(t.email),
            const SizedBox(height: 8),
            AppTextField(
              controller: _emailController,
              hint: t.emailHint,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              prefixIcon: const Icon(
                Icons.mail_outline,
                size: 22,
                color: AppColors.textPrimary70,
              ),
            ),

            const SizedBox(height: 20),

            // ── Password ──────────────────────────────────────────────────
            _FieldLabel(t.password),
            const SizedBox(height: 8),
            AppTextField(
              controller: _passwordController,
              hint: t.passwordHint,
              obscureText: _obscurePassword,
              errorText: _passwordError,
              prefixIcon: const Icon(
                Icons.lock_outline,
                size: 22,
                color: AppColors.textPrimary70,
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
                  color: AppColors.textPrimary70,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Confirm password ──────────────────────────────────────────
            _FieldLabel(t.confirmPassword),
            const SizedBox(height: 8),
            AppTextField(
              controller: _confirmPasswordController,
              hint: t.confirmPasswordHint,
              obscureText: _obscureConfirm,
              errorText: _confirmError,
              prefixIcon: const Icon(
                Icons.lock_outline,
                size: 22,
                color: AppColors.textPrimary70,
              ),
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 22,
                  color: AppColors.textPrimary70,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Register button ───────────────────────────────────────────
            AppPrimaryButton(
              text: t.register,
              onPressed: _submit,
            ),

            const SizedBox(height: 24),

            // ── Sign-in footer ────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.alreadyHaveAccount,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary70,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => context.pushNamed(AppRoutes.emailLoginName),
                  child: Text(
                    t.signIn,
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
