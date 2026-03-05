import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/stores/auth_store.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/phone_signup_page.dart';
import '../../features/auth/presentation/pages/verification_page.dart';
import '../../features/auth/presentation/pages/profile_details_page.dart';
import '../../features/auth/presentation/pages/gender_selection_page.dart';
import '../../features/auth/presentation/pages/interests_page.dart';
import '../../features/auth/presentation/pages/bio_province_page.dart';
import '../../features/auth/presentation/pages/enable_location_page.dart';
import '../../features/auth/presentation/pages/friends_page.dart';
import '../../features/auth/presentation/pages/notification_page.dart';
import '../../features/home/presentation/pages/main_page.dart';
import '../../features/home/presentation/pages/match_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';

import '../../features/auth/presentation/pages/email_register_page.dart';
import '../../features/auth/presentation/pages/settings_page.dart';
import '../../features/home/presentation/pages/edit_profile_page.dart';
import '../app_stores.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: GetIt.I<AuthStore>().isAuthenticated
        ? AppRoutes.home
        : AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signupName,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.phoneSignup,
        name: AppRoutes.phoneSignupName,
        builder: (context, state) => const PhoneSignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.verification,
        name: AppRoutes.verificationName,
        builder: (context, state) => const VerificationPage(),
      ),
      GoRoute(
        path: AppRoutes.profileDetails,
        name: AppRoutes.profileDetailsName,
        builder: (context, state) => const ProfileDetailsPage(),
      ),
      GoRoute(
        path: AppRoutes.genderSelection,
        name: AppRoutes.genderSelectionName,
        builder: (context, state) => const GenderSelectionPage(),
      ),
      GoRoute(
        path: AppRoutes.interests,
        name: AppRoutes.interestsName,
        builder: (context, state) => const InterestsPage(),
      ),
      GoRoute(
        path: AppRoutes.friends,
        name: AppRoutes.friendsName,
        builder: (context, state) => const FriendsPage(),
      ),
      GoRoute(
        path: AppRoutes.notification,
        name: AppRoutes.notificationName,
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: AppRoutes.location,
        name: AppRoutes.locationName,
        builder: (context, state) => const EnableLocationPage(),
      ),
      GoRoute(
        path: AppRoutes.bioProvince,
        name: AppRoutes.bioProvinceName,
        builder: (context, state) => const BioProvincePage(),
      ),
      // ── Main shell: shared nav bar, tab content via IndexedStack ────────
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: AppRoutes.matches,
        name: AppRoutes.matchesName,
        builder: (context, state) => const MainPage(initialTab: 1),
      ),
      GoRoute(
        path: AppRoutes.match,
        name: AppRoutes.matchName,
        builder: (context, state) => const MatchPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.emailRegister,
        name: AppRoutes.emailRegisterName,
        builder: (context, state) => const EmailRegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsName,
        builder: (context, state) {
          final stores = AppStores.instance;
          return SettingsPage(
            themeStore: stores.themeStore,
            localeStore: stores.localeStore,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: AppRoutes.editProfileName,
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
    // Handle deep links
    redirect: (context, state) {
      // Add authentication logic here if needed
      return null;
    },
  );
}
