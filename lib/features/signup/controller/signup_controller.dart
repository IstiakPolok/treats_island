import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';

class SignUpController extends GetxController {
  final phoneController = TextEditingController();

  final RxBool agreeToTerms = false.obs;
  final RxBool isLoading = false.obs;
  final ApiService _apiService = Get.put(ApiService());

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void toggleTerms(bool? value) {
    if (value != null) {
      agreeToTerms.value = value;
    }
  }

  void sendVerificationCode() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your phone number',
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
      final response = await _apiService.sendOtp(phone);

      debugPrint('=== SIGNUP SEND OTP API RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status Text: ${response.statusText}');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Body: ${response.body}');
      debugPrint('==========================');

      if (response.status.isOk) {
        Get.snackbar(
          'Success',
          'OTP sent successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withAlpha(26),
          colorText: Colors.black,
        );

        Get.toNamed(
          AppStrings.otpRoute,
          arguments: {
            'phone': phone,
            'fromSignUp': true,
          },
        );
      } else {
        final errorMessage = response.body != null && response.body is Map
            ? (response.body['error'] ??
                  response.body['message'] ??
                  'Failed to send OTP')
            : 'Failed to send OTP';
        Get.snackbar(
          'Failed',
          errorMessage.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(26),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLogin() {
    Get.offAllNamed(AppStrings.loginRoute);
  }
}
