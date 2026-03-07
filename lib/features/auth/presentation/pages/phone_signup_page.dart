import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';

class PhoneSignUpPage extends StatefulWidget {
  const PhoneSignUpPage({super.key});

  @override
  State<PhoneSignUpPage> createState() => _PhoneSignUpPageState();
}

class _PhoneSignUpPageState extends State<PhoneSignUpPage> {
  final TextEditingController _phoneController = TextEditingController(
    text: '331 623 8413',
  );

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 42),

            // Header
            Text(t.myMobileNumber, style: AppTextStyles.h1),

            const SizedBox(height: 16),

            Text(
              t.phoneNumberDesc,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary70,
              ),
            ),

            const SizedBox(height: 60),

            // Phone input
            Container(
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),

                  // US Flag placeholder - in real app, use proper flag
                  Container(
                    width: 20,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Center(
                      child: Text('🇺🇸', style: TextStyle(fontSize: 10)),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Back icon
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),

                  const SizedBox(width: 8),

                  // (+1)
                  Text('(+1)', style: AppTextStyles.bodyMedium),

                  // Vertical divider
                  Container(
                    width: 1,
                    height: 18,
                    color: AppColors.border,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),

                  // Phone input
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.bodyMedium,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone number',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Continue button
            AppPrimaryButton(
              text: t.continueLabel,
              onPressed: () {
                context.pushNamed(AppRoutes.verificationName);
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
