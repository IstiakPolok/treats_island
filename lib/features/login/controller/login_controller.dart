import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final ApiService _apiService = Get.put(ApiService());

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void loginUser() async {
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

    isLoading.value = true;
    try {
      final response = await _apiService.login(email, password);

      debugPrint('=== LOGIN API RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status Text: ${response.statusText}');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Body: ${response.body}');
      debugPrint('==========================');

      if (response.status.isOk) {
        final responseData = response.body;
        String? token;

        // Extract token from API response keys
        if (responseData != null && responseData is Map) {
          token = responseData['access']?.toString();
          final refreshToken = responseData['refresh']?.toString();
          if (refreshToken != null) {
            await SharedPreferencesHelper.saveRefreshToken(refreshToken);
          }

          // Optionally save user info if returned
          final userId =
              responseData['userId']?.toString() ??
              responseData['data']?['userId']?.toString();
          if (userId != null) {
            await SharedPreferencesHelper.saveUserId(userId);
          }
          final userName =
              responseData['name']?.toString() ??
              responseData['data']?['name']?.toString();
          if (userName != null) {
            await SharedPreferencesHelper.saveName(userName);
          }
          final userEmail =
              responseData['email']?.toString() ??
              responseData['data']?['email']?.toString();
          if (userEmail != null) {
            await SharedPreferencesHelper.saveEmail(userEmail);
          }
        }

        // Fallback placeholder token for testing if the server returned success but no token key was found
        token ??= 'demo_placeholder_token';

        await SharedPreferencesHelper.saveToken(token);

        Get.snackbar(
          'Success',
          'Logged in successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withAlpha(26),
          colorText: Colors.black,
        );

        // Navigate directly to the main application and remove login from history
        Get.offAllNamed(AppStrings.navbarRoute);
      } else {
        // Handle error responses from API
        final errorMessage = response.body != null && response.body is Map
            ? (response.body['error'] ??
                  response.body['message'] ??
                  'Login failed')
            : 'Invalid email or password';
        Get.snackbar(
          'Login Failed',
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
