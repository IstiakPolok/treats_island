import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool agreeToTerms = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleTerms(bool? value) {
    if (value != null) {
      agreeToTerms.value = value;
    }
  }

  void sendVerificationCode() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

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
        'Please enter a password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar(
        'Required',
        'Please confirm your password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!agreeToTerms.value) {
      Get.snackbar(
        'Terms & Conditions',
        'You must agree to the terms and conditions to proceed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Submit details and send code
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.toNamed(AppStrings.otpRoute);
    });
  }

  void navigateToLogin() {
    Get.back(); // Goes back to Login screen
  }
}
