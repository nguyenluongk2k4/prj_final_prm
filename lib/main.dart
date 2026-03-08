import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'core/di/injection.dart';
import 'core/app_stores.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'i18n/strings.g.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'features/auth/infrastructure/datasources/auth_datasource.dart';
import 'features/auth/presentation/stores/auth_store.dart';
import 'features/auth/presentation/stores/presence_store.dart';
import 'core/services/firebase_messaging_service.dart';
import 'core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load Env
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize Firebase (vì config thủ công bằng google-services.json nên gọi hàm này là đủ)
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );
  await NotificationService.init();
  
  // Initialize slang — will be overridden below after loading saved locale
  LocaleSettings.useDeviceLocale();
  
  // Initialize Dependency Injection
  await configureDependencies();
  await GetIt.I<FirebaseMessagingService>().init();

  // Check session: nếu đã có session thì fetch user → vào thẳng home, không cần login lại
  final supabase = Supabase.instance.client;
  if (supabase.auth.currentSession != null) {
    final authStore = GetIt.I<AuthStore>();
    final authDatasource = GetIt.I<AuthDatasource>();
    final user = await authDatasource.getCurrentUser();
    if (user != null) {
      authStore.currentUser = user;
      authStore.isAuthenticated = true;
    }
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      try {
        await supabase.from('profiles').update({
          'is_online': true,
          'last_active': DateTime.now().toIso8601String(),
        }).eq('user_id', userId);
      } catch (_) {}
    }
  }

  // Load saved preferences
  final stores = AppStores.instance;
  await stores.themeStore.loadTheme();
  await stores.localeStore.loadLocale();

  // Sync saved locale into slang's TranslationProvider
  final savedLocale = AppLocale.values.firstWhere(
    (l) => l.languageCode == stores.localeStore.currentLocale.languageCode,
    orElse: () => AppLocale.en,
  );
  LocaleSettings.setLocale(savedLocale);
  
  runApp(TranslationProvider(
    child: const AppRoot(),
  ));
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  final _presenceStore = GetIt.I<PresenceStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _presenceStore.forcePing();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _presenceStore.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _presenceStore.forcePing();
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _presenceStore.setOffline();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _presenceStore.schedulePing(),
      child: const MyApp(),
    );
  }
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
