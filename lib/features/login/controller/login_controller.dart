import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';
import '../../../shared/widgets/widgets.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final Rx<Country> selectedCountry = const Country(
    name: 'United States',
    flag: '🇺🇸',
    code: '+1',
  ).obs;

  final RxBool isLoading = false.obs;
  final ApiService _apiService = Get.put(ApiService());

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void loginUser() async {
    var phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    final fullPhone = '${selectedCountry.value.code}$phone';

    isLoading.value = true;
    try {
      final response = await _apiService.sendOtp(fullPhone);

      debugPrint('=== SEND OTP API RESPONSE ===');
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
            'phone': fullPhone,
            'fromSignUp': false,
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

  Future<void> _registerDeviceToken(String authToken) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      debugPrint('=== DEVICE TOKEN REGISTER DEBUG ===');
      debugPrint('FCM Token: $fcmToken');

      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('Device token register skipped: FCM token is empty.');
        debugPrint('===================================');
        return;
      }

      final payload = {
        'token': fcmToken,
        'platform': _platformName,
        'deviceName': _deviceName,
        'device_id': '',
        'osVersion': _osVersion,
      };

      debugPrint('Payload: $payload');

      final response = await _apiService.registerNotificationToken(
        authToken: authToken,
        token: fcmToken,
        platform: _platformName,
        deviceName: _deviceName,
        deviceId: '',
        osVersion: _osVersion,
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status Text: ${response.statusText}');
      debugPrint('Body: ${response.body}');
      debugPrint('===================================');
    } catch (e) {
      debugPrint('=== DEVICE TOKEN REGISTER ERROR ===');
      debugPrint('Error: $e');
      debugPrint('===================================');
    }
  }

  String get _platformName {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return defaultTargetPlatform.name;
    }
  }

  String get _deviceName {
    return '';
  }

  String get _osVersion {
    return '';
  }
}
