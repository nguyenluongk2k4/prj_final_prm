import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/theme/theme_store.dart';
import '../../../../core/theme/locale_store.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';

class SettingsPage extends StatelessWidget {
  final ThemeStore themeStore;
  final LocaleStore localeStore;

  const SettingsPage({
    super.key,
    required this.themeStore,
    required this.localeStore,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBarWithBack(
        title: t.settings,
      ),
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
                      onChanged: (_) =>
                          localeStore.setLocale(const Locale('en')),
                    ),
                    title: const Text('English'),
                    onTap: () => localeStore.setLocale(const Locale('en')),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'vi',
                      groupValue: localeStore.currentLocale.languageCode,
                      onChanged: (_) =>
                          localeStore.setLocale(const Locale('vi')),
                    ),
                    title: const Text('Tiếng Việt'),
                    onTap: () => localeStore.setLocale(const Locale('vi')),
                  ),
                ],
              );
            },
          ),
          const Divider(),

          // Account Section (removed - no auth state in settings)
        ],
      ),
    );
  }
}
