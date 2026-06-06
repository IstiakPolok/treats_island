import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';

class OTPController extends GetxController {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  final RxInt secondsRemaining = 45.obs;
  final RxBool canResend = false.obs;
  final RxBool hasError = false.obs;
  final RxBool isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    secondsRemaining.value = 45;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
  }

  void resendCode() {
    // Implement resend logic here
    hasError.value = false;
    startTimer();
    Get.snackbar(
      'OTP Resent',
      'A new verification code has been sent.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void verifyOTP() {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length < 6) {
      hasError.value = true;
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      if (otp == "140000") { // Simulated logic for success based on image hint
         hasError.value = false;
         Get.snackbar('Success', 'Phone number verified successfully!');
         Get.offAllNamed(AppStrings.nameSetRoute);
      } else {
        hasError.value = true;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
