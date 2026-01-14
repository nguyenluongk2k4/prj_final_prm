import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/phone_signup_page.dart';
import '../../features/auth/presentation/pages/verification_page.dart';
import '../../features/auth/presentation/pages/profile_details_page.dart';
import '../../features/auth/presentation/pages/gender_selection_page.dart';
import '../../features/auth/presentation/pages/interests_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/settings_page.dart';
import '../app_stores.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
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
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginPage(),
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
    ],
    // Handle deep links
    redirect: (context, state) {
      // Add authentication logic here if needed
      return null;
    },
  );
}
