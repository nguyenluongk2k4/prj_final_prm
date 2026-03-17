import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_store.dart';
import '../../../../core/theme/locale_store.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../i18n/strings.g.dart';
import '../stores/auth_store.dart';

class SettingsPage extends StatelessWidget {
  final ThemeStore themeStore;
  final LocaleStore localeStore;

  const SettingsPage({
    super.key,
    required this.themeStore,
    required this.localeStore,
  });

  Future<void> _setLocale(Locale locale) async {
    await localeStore.setLocale(locale);
    final appLocale = AppLocale.values.firstWhere(
      (l) => l.languageCode == locale.languageCode,
      orElse: () => AppLocale.en,
    );
    LocaleSettings.setLocale(appLocale);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
      title: t.settings,
      showQuickActions: false,
      showBackButton: true,
      body: ListView(
        children: [
          // Theme Section
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(t.theme),
            subtitle: Observer(
              builder: (_) => Text(
                themeStore.isDarkMode ? t.darkMode : t.lightMode,
              ),
            ),
          ),
          Observer(
            builder: (_) => SwitchListTile(
              secondary: Icon(
                themeStore.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              title: Text(
                themeStore.isDarkMode ? t.darkMode : t.lightMode,
              ),
              value: themeStore.isDarkMode,
              onChanged: (_) => themeStore.toggleTheme(),
            ),
          ),
          const Divider(),

          // Language Section
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(t.language),
            subtitle: Observer(
              builder: (_) => Text(
                localeStore.currentLocale.languageCode == 'vi'
                    ? 'Tiếng Việt'
                    : 'English',
              ),
            ),
          ),
          Observer(
            builder: (_) {
              return Column(
                children: [
                  ListTile(
                    leading: Radio<String>(
                      value: 'en',
                      groupValue: localeStore.currentLocale.languageCode,
                      onChanged: (_) => _setLocale(const Locale('en')),
                    ),
                    title: const Text('English'),
                    onTap: () => _setLocale(const Locale('en')),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'vi',
                      groupValue: localeStore.currentLocale.languageCode,
                      onChanged: (_) => _setLocale(const Locale('vi')),
                    ),
                    title: const Text('Tiếng Việt'),
                    onTap: () => _setLocale(const Locale('vi')),
                  ),
                ],
              );
            },
          ),
          const Divider(),

          // Account Section
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(t.changePassword),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoutes.changePasswordName),
          ),
          const Divider(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(t.logout),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(t.logout),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(t.cancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          final authStore = getIt<AuthStore>();
                          await authStore.logout();
                          if (context.mounted) {
                            context.goNamed(AppRoutes.loginName);
                          }
                        },
                        child: Text(t.logout),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
