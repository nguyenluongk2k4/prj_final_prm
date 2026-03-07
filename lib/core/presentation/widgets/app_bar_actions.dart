import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../theme/app_colors.dart';
import '../../../core/app_stores.dart';
import '../../../i18n/strings.g.dart';

/// Compact dark/light + language toggle buttons for the AppBar.
/// Uses [AppStores.instance] directly — no prop drilling needed.
class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final themeStore = AppStores.instance.themeStore;
    final localeStore = AppStores.instance.localeStore;
    final brightness = Theme.of(context).brightness;
    final iconColor = AppColors.text(brightness);

    return Observer(
      builder: (_) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Dark / Light toggle ──────────────────────────────────────
          _ActionButton(
            tooltip: themeStore.isDarkMode ? 'Light mode' : 'Dark mode',
            icon: themeStore.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,            iconColor: iconColor,            onTap: () => themeStore.setThemeMode(
              themeStore.isDarkMode ? ThemeMode.light : ThemeMode.dark,
            ),
          ),

          const SizedBox(width: 4),

          // ── Language toggle ──────────────────────────────────────────
          _LangButton(
            languageCode: localeStore.currentLocale.languageCode,
            onTap: () async {
              await localeStore.toggleLocale();
              // Notify slang's TranslationProvider to re-render
              final appLocale = AppLocale.values.firstWhere(
                (l) =>
                    l.languageCode ==
                    localeStore.currentLocale.languageCode,
                orElse: () => AppLocale.en,
              );
              LocaleSettings.setLocale(appLocale);
            },
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: iconColor),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _LangButton extends StatelessWidget {
  const _LangButton({required this.languageCode, required this.onTap});

  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isEn = languageCode == 'en';
    final brightness = Theme.of(context).brightness;
    return Tooltip(
      message: isEn ? 'Switch to Tiếng Việt' : 'Switch to English',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor(brightness)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isEn ? '🇬🇧 EN' : '🇻🇳 VI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.text(brightness),
            ),
          ),
        ),
      ),
    );
  }
}
