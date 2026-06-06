import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool agreeToTerms = false.obs;
  final RxBool isLoading = false.obs;
  final ApiService _apiService = Get.put(ApiService());

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

  void sendVerificationCode() async {
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

    isLoading.value = true;
    try {
      final response = await _apiService.register(
        email,
        password,
        confirmPassword,
      );

      if (response.status.isOk) {
        final responseData = response.body;
        final successMessage = responseData != null && responseData is Map
            ? (responseData['message'] ?? 'Email sent successfully.')
            : 'Email sent successfully.';

        Get.snackbar(
          'Success',
          successMessage.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withAlpha(26),

          colorText: Colors.black,
        );

        Get.toNamed(
          AppStrings.otpRoute,
          arguments: {'fromSignUp': true, 'email': email},
        );
      } else {
        final errorMessage = response.body != null && response.body is Map
            ? (response.body['message'] ?? 'Registration failed')
            : 'Registration failed';
        Get.snackbar(
          'Registration Failed',
          errorMessage.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(26),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLogin() {
    Get.back(); // Goes back to Login screen
  }
}
