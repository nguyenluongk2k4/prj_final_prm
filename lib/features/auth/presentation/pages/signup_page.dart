import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../i18n/strings.g.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(height: 128),

              // Logo/Trademark
              SvgPicture.asset(
                'assets/images/logo.svg',
                width: 108.64,
                height: 100,
              ),

              const Spacer(),

              // Sign up section
              Column(
                children: [
                  // Title
                  Text(
                    t.signUpToContinue,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Continue with email button
                  AppPrimaryButton(
                    text: t.continueWithEmail,
                    onPressed: () {
                      context.pushNamed(AppRoutes.emailLoginName);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Use phone number button
                  AppOutlineButton(
                    text: t.usePhoneNumber,
                    onPressed: () {
                      context.pushNamed(AppRoutes.phoneSignupName);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Social login section
              Column(
                children: [
                  // Divider with text
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: c.border,
                          thickness: 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          t.orSignUpWith,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 12,
                                color: c.text70,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: c.border,
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Social buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        assetPath: 'assets/images/facebook_icon.svg',
                        onPressed: () {
                          // Facebook login
                        },
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        assetPath: 'assets/images/google_icon.svg',
                        onPressed: () {
                          // Google login
                        },
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        assetPath: 'assets/images/apple_icon.svg',
                        onPressed: () {
                          // Apple login
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Show terms of use
                    },
                    child: Text(
                      t.termsOfUse,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      // Show privacy policy
                    },
                    child: Text(
                      t.privacyPolicy,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String assetPath,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 64,
      height: 64,
      child: IconButton(
        icon: SvgPicture.asset(
          assetPath,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
