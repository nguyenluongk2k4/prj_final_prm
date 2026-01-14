import 'theme/theme_store.dart';
import 'theme/locale_store.dart';

/// Global stores instance
class AppStores {
  static final AppStores instance = AppStores._();
  
  AppStores._();

  late final ThemeStore themeStore = ThemeStore();
  late final LocaleStore localeStore = LocaleStore();
}
