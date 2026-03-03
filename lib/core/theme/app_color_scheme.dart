import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Convenience extension — use [context.appColors] in any widget build method.
///
/// ```dart
/// final c = context.appColors;
/// Container(color: c.background)
/// Text('hello', style: TextStyle(color: c.textPrimary))
/// ```
extension AppColorSchemeX on BuildContext {
  AppColorScheme get appColors => AppColorScheme.of(this);
}

/// A fully adaptive color palette resolved from the current [ThemeData.brightness].
///
/// Access via [context.appColors].
class AppColorScheme {
  // ── surface ──────────────────────────────────────────────────────────────
  final Color background;
  final Color backgroundSecondary;

  // ── text ─────────────────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary; // ~40 % opacity
  final Color text70;        // ~70 % opacity

  // ── border ───────────────────────────────────────────────────────────────
  final Color border;

  // ── brand (brightness-independent) ───────────────────────────────────────
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;

  /// Whether this scheme represents a dark palette.
  final bool isDark;

  const AppColorScheme._({
    required this.background,
    required this.backgroundSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.text70,
    required this.border,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.isDark,
  });

  // ── singletons ────────────────────────────────────────────────────────────

  static const AppColorScheme light = AppColorScheme._(
    background: AppColors.background,
    backgroundSecondary: AppColors.backgroundSecondary,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    text70: AppColors.textPrimary70,
    border: AppColors.border,
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    primaryLight: AppColors.primaryLight,
    isDark: false,
  );

  static const AppColorScheme dark = AppColorScheme._(
    background: AppColors.backgroundDark,
    backgroundSecondary: AppColors.backgroundDarkSecondary,
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textPrimary70Dark,
    text70: AppColors.textPrimary70Dark,
    border: AppColors.borderDark,
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    primaryLight: AppColors.primaryLight,
    isDark: true,
  );

  // ── factory ───────────────────────────────────────────────────────────────

  /// Resolves the correct scheme for [context]'s current theme brightness.
  factory AppColorScheme.of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  /// Resolves directly from a [Brightness] value (useful outside widget tree).
  factory AppColorScheme.fromBrightness(Brightness b) {
    return b == Brightness.dark ? dark : light;
  }
}
