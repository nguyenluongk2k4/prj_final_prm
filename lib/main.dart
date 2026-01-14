import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'core/di/injection.dart';
import 'core/app_stores.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize slang
  LocaleSettings.useDeviceLocale();
  
  // Initialize Dependency Injection
  await configureDependencies();
  
  // Load saved preferences
  final stores = AppStores.instance;
  await stores.themeStore.loadTheme();
  await stores.localeStore.loadLocale();
  
  runApp(TranslationProvider(
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final stores = AppStores.instance;
    
    return Observer(
      builder: (_) {
        // Get the current locale from store
        final appLocale = AppLocale.values.firstWhere(
          (l) => l.languageCode == stores.localeStore.currentLocale.languageCode,
          orElse: () => AppLocale.en,
        );
        
        return MaterialApp.router(
          title: 'PRM Final Project',
          debugShowCheckedModeBanner: false,
          
          // Router Configuration
          routerConfig: AppRouter.router,
          
          // Theme Configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: stores.themeStore.themeMode,
          
          // Localization Configuration
          locale: appLocale.flutterLocale,
          supportedLocales: AppLocale.values.map((e) => e.flutterLocale),
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
        );
      },
    );
  }
}
