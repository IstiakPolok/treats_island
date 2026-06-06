import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void sendVerificationCode() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Handle authentication / code sending logic here
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      // For now, navigate to the OTP verification screen
      Get.toNamed(AppStrings.otpRoute);
    });
  }

  void forgetPassword() {
    Get.snackbar(
      'Reset Password',
      'Password reset instructions sent to your email',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void navigateToSignUp() {
    Get.toNamed(AppStrings.signupRoute);
  }
}
