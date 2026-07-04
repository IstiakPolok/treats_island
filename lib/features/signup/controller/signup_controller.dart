import 'dart:math';
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

  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;

  void toggleHidePassword() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleHideConfirmPassword() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('SignUpController: onInit called');
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
    confirmPasswordController.addListener(() {
      confirmPassword.value = confirmPasswordController.text;
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool get hasMinLength => password.value.length >= 8;
  bool get hasUppercase => password.value.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => password.value.contains(RegExp(r'[a-z]'));
  bool get hasDigits => password.value.contains(RegExp(r'[0-9]'));
  bool get hasSpecialCharacters =>
      password.value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool get passwordsMatch =>
      password.value.isNotEmpty && password.value == confirmPassword.value;

  void generateStrongPassword() {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';
    const special = '!@#\$%^&*';
    const allChars = '$uppercase$lowercase$digits$special';

    final rand = Random.secure();

    final chars = [
      uppercase[rand.nextInt(uppercase.length)],
      lowercase[rand.nextInt(lowercase.length)],
      digits[rand.nextInt(digits.length)],
      special[rand.nextInt(special.length)],
    ];

    for (int i = 0; i < 8; i++) {
      chars.add(allChars[rand.nextInt(allChars.length)]);
    }

    chars.shuffle(rand);
    final generated = chars.join('');

    passwordController.text = generated;
    confirmPasswordController.text = generated;
    password.value = generated;
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

    if (password.length < 8) {
      Get.snackbar(
        'Required',
        'Password must be at least 8 characters long',
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
    debugPrint('SignUpController: Attempting registration for email: $email');
    try {
      final response = await _apiService.register(
        email,
        password,
        confirmPassword,
      );
      debugPrint('SignUpController: Response Status = ${response.statusCode}');
      debugPrint('SignUpController: Response Body = ${response.body}');

      debugPrint('=== SIGNUP API RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status Text: ${response.statusText}');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Body: ${response.body}');
      debugPrint('==========================');

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
      debugPrint('SignUpController: Registration error: $e');
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
