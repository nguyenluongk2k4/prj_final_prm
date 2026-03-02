import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../../i18n/strings.g.dart';
import 'app_bar_actions.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showBackButton;
  final bool showSkipButton;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  /// Show dark/light + language toggle buttons on the right of the AppBar.
  final bool showQuickActions;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.showBackButton = false,
    this.showSkipButton = false,
    this.onSkip,
    this.onBack,
    this.actions,
    this.backgroundColor,
    this.centerTitle = false,
    this.showQuickActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: AppBar(
        backgroundColor: backgroundColor ?? AppColors.background,
        elevation: 0,
        centerTitle: centerTitle,
        title: title != null
            ? Text(
                title!,
                style: AppTextStyles.h3,
              )
            : null,
        leading: showBackButton
            ? Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Assets.icons.btnBack.svg(
                    width: 52,
                    height: 52,
                  ),
                  onPressed: onBack ?? () => context.pop(),
                ),
              )
            : null,
        actions: showSkipButton
            ? [
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    t.skip,
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (showQuickActions) const AppBarActions(),
              ]
            : [
                ...?actions,
                if (showQuickActions) const AppBarActions(),
              ],
      ),
      body: SafeArea(child: body),
    );
  }
}
