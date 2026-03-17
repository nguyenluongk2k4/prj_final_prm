import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'core/di/injection.dart';
import 'core/app_stores.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'i18n/strings.g.dart';

import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'features/auth/infrastructure/datasources/auth_datasource.dart';
import 'features/auth/presentation/stores/auth_store.dart';
import 'features/auth/presentation/stores/presence_store.dart';
import 'features/home/presentation/stores/reels_store.dart';
import 'features/call/presentation/models/call_args.dart';
import 'core/router/app_routes.dart';
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
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
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

/// Called once after first frame — navigates to InCallPage if callkit has an active accepted call.
/// Skipped if FirebaseMessagingService already handled the accept event (avoids double-push).
Future<void> _handleCallkitLaunch() async {
  // Case 1: _onCallkitEvent fired but router wasn't ready — args were stashed
  final pending = FirebaseMessagingService.pendingCallArgs;
  if (pending != null) {
    FirebaseMessagingService.pendingCallArgs = null;
    AppRouter.router.push(AppRoutes.callActive, extra: pending);
    return;
  }

  // Case 2: _onCallkitEvent already navigated successfully — skip
  if (FirebaseMessagingService.callAcceptHandled) return;

  // Case 3: App was killed, user accepted from OS notification before app booted
  try {
    final calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is! List || calls.isEmpty) return;

    final call = calls.first as Map?;
    if (call == null) return;

    final callStatus = call['callStatus']?.toString() ?? '';
    if (callStatus != 'accepted') {
      await FlutterCallkitIncoming.endAllCalls();
      return;
    }

    final extra = call['extra'] as Map? ?? {};
    final channelId = extra['channel_id']?.toString() ?? '';
    final callerId = extra['caller_id']?.toString() ?? '';
    final receiverId = extra['receiver_id']?.toString() ?? '';
    final isVideo = extra['is_video']?.toString() == 'true';
    final callerName = call['nameCaller']?.toString() ?? 'Người dùng';
    final callSessionId = extra['call_session_id']?.toString();

    if (channelId.isEmpty || callerId.isEmpty) return;

    final args = CallArgs(
      channelId: channelId,
      localUserId: receiverId,
      remoteUserId: callerId,
      remoteName: callerName,
      remoteAvatarUrl: null,
      isVideo: isVideo,
      isIncoming: true,
      callSessionId: callSessionId,
    );

    await Future.delayed(const Duration(milliseconds: 500));
    AppRouter.router.push(AppRoutes.callActive, extra: args);
  } catch (_) {}
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
    _requestOverlayPermission();
    // Delay to ensure router is mounted before navigating
    Future.delayed(const Duration(milliseconds: 800), _handleCallkitLaunch);
  }

  /// Request SYSTEM_ALERT_WINDOW — needed for full-screen call when app is killed
  Future<void> _requestOverlayPermission() async {
    final status = await Permission.systemAlertWindow.status;
    if (!status.isGranted) {
      await Permission.systemAlertWindow.request();
    }
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
      // Stop reels audio when app goes to background
      try {
        GetIt.I<ReelsStore>().setPageVisibility(false);
        GetIt.I<ReelsStore>().stopAudio();
      } catch (_) {}
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
