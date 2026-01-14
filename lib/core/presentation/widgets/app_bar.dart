import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';

class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppBarWithBack({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: foregroundColor ?? (isDark ? AppColors.textWhite : AppColors.textPrimary),
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? (isDark ? const Color(0xFF1A1A1A) : AppColors.background),
      foregroundColor: foregroundColor ?? (isDark ? AppColors.textWhite : AppColors.textPrimary),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: onBackPressed ?? () => context.pop(),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarSimple extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? leading;

  const AppBarSimple({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: foregroundColor ?? (isDark ? AppColors.textWhite : AppColors.textPrimary),
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? (isDark ? const Color(0xFF1A1A1A) : AppColors.background),
      foregroundColor: foregroundColor ?? (isDark ? AppColors.textWhite : AppColors.textPrimary),
      elevation: 0,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
