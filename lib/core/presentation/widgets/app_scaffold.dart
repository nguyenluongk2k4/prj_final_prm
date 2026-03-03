import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../../i18n/strings.g.dart';
import 'app_bar_actions.dart';
import 'app_bar_icon_button.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  /// Custom widget replacing the text title — takes priority over [title].
  final Widget? titleWidget;
  final bool showBackButton;
  final bool showSkipButton;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? secondaryAction;
  final Color? backgroundColor;
  final bool centerTitle;
  /// Show dark/light + language toggle buttons on the right of the AppBar.
  final bool showQuickActions;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.showSkipButton = false,
    this.onSkip,
    this.onBack,
    this.actions,
    this.secondaryAction,
    this.backgroundColor,
    this.centerTitle = false,
    this.showQuickActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bg = backgroundColor ?? AppColors.bg(brightness);
    final titleColor = AppColors.text(brightness);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: centerTitle,
        leadingWidth: 64,
        title: titleWidget ??
            (title != null
                ? Text(
                    title!,
                    style: AppTextStyles.h3.copyWith(color: titleColor),
                  )
                : null),
        leading: showBackButton
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: AppBarIconButton(
                  icon: Assets.icons.icBack.svg(width: 24, height: 24),
                  onTap: onBack ?? () => context.pop(),
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
                if (secondaryAction != null) secondaryAction!,
                ...?actions,
                if (showQuickActions) const AppBarActions(),
              ],
      ),
      body: SafeArea(child: body),
    );
  }
}
