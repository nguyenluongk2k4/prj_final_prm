import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(height: 53),

              // Photos with like icon
              SizedBox(
                width: 295,
                height: 404,
                child: Assets.images.matchPhotos.svg(width: 295, height: 404),
              ),

              const SizedBox(height: 20),

              // Title
              Column(
                children: [
                  Text(
                    t.itsAMatch,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.startConversation,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: c.text70,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Say hello button
              AppPrimaryButton(
                text: t.sayHello,
                onPressed: () {
                  // Navigate to chat or messages
                  context.pop();
                },
              ),

              const SizedBox(height: 20),

              // Keep swiping button
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    t.keepSwiping,
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
