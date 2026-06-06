import 'package:get/get.dart';

import '../../features/splash/view/splash_screen.dart';
import '../../features/onboarding/view/onboarding_screen.dart';
import '../../features/welcome/view/welcome_screen.dart';
import '../../features/login/view/login_screen.dart';
import '../../features/signup/view/signup_screen.dart';
import '../../features/signup/view/nameset_screen.dart';
import '../../features/otp/view/otp_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/home/view/launch_event_screen.dart';
import '../../shared/widgets/bottom_navbar.dart';
import '../constants/app_strings.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(name: AppStrings.splashRoute, page: () => const SplashScreen()),
    GetPage(
      name: AppStrings.onboardingRoute,
      page: () => const OnboardingScreen(),
    ),
    GetPage(name: AppStrings.welcomeRoute, page: () => const WelcomeScreen()),
    GetPage(name: AppStrings.loginRoute, page: () => const LoginScreen()),
    GetPage(name: AppStrings.signupRoute, page: () => const SignUpScreen()),
    GetPage(name: AppStrings.otpRoute, page: () => const OTPScreen()),
    GetPage(name: AppStrings.nameSetRoute, page: () => const NameSetScreen()),
    GetPage(name: AppStrings.navbarRoute, page: () => MainNavigationScreen()),
    GetPage(
      name: AppStrings.launchEventRoute,
      page: () => const LaunchEventScreen(),
    ),
  ];
}
