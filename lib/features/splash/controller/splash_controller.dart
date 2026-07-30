import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/shared_preferences_helper.dart';

/// SplashController handles the splash screen timer logic.
/// It navigates to the onboarding screen after a delay.
class SplashController extends GetxController {
  /// Progress value for the animated loader (0.0 → 1.0).
  final RxDouble loadingProgress = 0.0.obs;

  /// Whether the loading animation is complete.
  final RxBool isLoadingComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startLoadingAnimation();
  }

  /// Gradually increments progress then navigates away.
  void _startLoadingAnimation() async {
    // Animate progress from 0 to 1 over ~2 seconds in 25ms steps.
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      loadingProgress.value = i / 100.0;
    }

    isLoadingComplete.value = true;

    // Small pause before navigating.
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Check if token exists in SharedPreferences
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null && token.isNotEmpty) {
      final email = await SharedPreferencesHelper.getEmail();
      if (email.isEmpty || email == 'me' || email == 'null') {
        Get.offNamed(AppStrings.nameSetRoute);
      } else {
        Get.offNamed(AppStrings.navbarRoute);
      }
    } else {
      Get.offNamed(AppStrings.onboardingRoute);
    }
  }
}
