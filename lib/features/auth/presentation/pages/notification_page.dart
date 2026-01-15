import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/notification_service.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showSkipButton: true,
      onSkip: () => context.pushNamed(AppRoutes.homeName),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 104),

            // Illustration
            Center(
              child: Assets.images.notificationIllustration.svg(
                width: 240,
                height: 240,
              ),
            ),

            const SizedBox(height: 64),

            // Title and description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    t.enableNotifications,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.notificationDesc,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary70,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AppPrimaryButton(
                text: t.iWantToBeNotified,
                onPressed: () async {
                  final granted = await NotificationService.requestNotificationPermission();
                  if (!context.mounted) return;
                  
                  // Navigate to home regardless of permission status
                  context.pushNamed(AppRoutes.homeName);
                },
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      );
    
  }
}
