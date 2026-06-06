import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';

class OnboardingController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final int totalSteps = 3;

  void nextStep() {
    if (currentIndex.value < totalSteps - 1) {
      currentIndex.value++;
    } else {
      skipToNext();
    }
  }

  void skipToNext() {
    Get.offAllNamed(AppStrings.welcomeRoute);
  }
}
