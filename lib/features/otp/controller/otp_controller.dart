import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';

class OTPController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final RxString code = ''.obs;

  final RxInt activeIndex = 0.obs;
  final RxInt secondsRemaining = 45.obs;
  final RxBool canResend = false.obs;
  final RxBool hasError = false.obs;
  final RxBool isLoading = false.obs;
  Timer? _timer;
  final ApiService _apiService = Get.put(ApiService());

  String phone = '';
  bool fromSignUp = false;

  @override
  void onInit() {
    startTimer();
    final Map? args = Get.arguments as Map?;
    phone = args?['phone'] ?? args?['email'] ?? '';
    fromSignUp = args?['fromSignUp'] ?? false;
    otpController.addListener(() {
      code.value = otpController.text;
      activeIndex.value = otpController.text.length;
    });
    super.onInit();
    _listenForSms();
  }

  void _listenForSms() async {
    try {
      final appSignature = await SmsAutoFill().getAppSignature;
      debugPrint('=== App Signature for SMS: $appSignature ===');
      await SmsAutoFill().listenForCode();
      SmsAutoFill().code.listen((smsCode) {
        if (smsCode.isNotEmpty && smsCode.length == 6) {
          otpController.text = smsCode;
          verifyOTP();
        }
      });
    } catch (e) {
      debugPrint('Error starting SMS autofill: $e');
    }
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

  void resendCode() async {
    hasError.value = false;
    if (phone.isEmpty) return;
    try {
      final response = await _apiService.sendOtp(phone);
      if (response.status.isOk) {
        startTimer();
        Get.snackbar(
          'OTP Resent',
          'A new verification code has been sent.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to resend code.',
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
    }
  }

  Future<void> _registerDeviceToken(String authToken) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;
      await _apiService.registerNotificationToken(
        authToken: authToken,
        token: fcmToken,
        platform: kIsWeb
            ? 'web'
            : (defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android'),
        deviceName: '',
        deviceId: '',
        osVersion: '',
      );
    } catch (e) {
      debugPrint('FCM Token registration error: $e');
    }
  }

  void verifyOTP() async {
    String otp = otpController.text;
    if (otp.length < 6) {
      hasError.value = true;
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    try {
      if (phone.isEmpty) {
        Get.snackbar(
          'Error',
          'Phone number not found. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.red,
        );
        isLoading.value = false;
        return;
      }

      final response = await _apiService.verifyOtp(phone, otp);

      if (response.status.isOk) {
        final responseData = response.body;
        if (responseData != null && responseData is Map) {
          final accessToken = responseData['access']?.toString();
          final refreshToken = responseData['refresh']?.toString();

          if (accessToken != null) {
            await SharedPreferencesHelper.saveToken(accessToken);
            await _registerDeviceToken(accessToken);
          }
          if (refreshToken != null) {
            await SharedPreferencesHelper.saveRefreshToken(refreshToken);
          }

          final user = responseData['user'];
          String? userEmail;
          String? userPhone;
          if (user != null && user is Map) {
            userEmail = user['email']?.toString();
            userPhone = user['phone']?.toString();
            final fullName = user['full_name']?.toString();
            final image = user['image']?.toString();
            final userId = user['id']?.toString();

            if (userId != null) {
              await SharedPreferencesHelper.saveUserId(userId);
            }
            if (fullName != null && fullName.isNotEmpty && fullName != 'null') {
              await SharedPreferencesHelper.saveName(fullName);
            }
            if (userEmail != null &&
                userEmail.isNotEmpty &&
                userEmail != 'null') {
              await SharedPreferencesHelper.saveEmail(userEmail);
            }
            if (userPhone != null &&
                userPhone.isNotEmpty &&
                userPhone != 'null') {
              await SharedPreferencesHelper.savePhone(userPhone);
            }
            if (image != null && image.isNotEmpty && image != 'null') {
              await SharedPreferencesHelper.saveUserImage(image);
            }
          }

          Get.snackbar(
            'Success',
            'OTP verified successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withAlpha(26),
            colorText: Colors.black,
          );

          if (userEmail == null || userEmail.isEmpty || userEmail == 'null') {
            Get.offAllNamed(
              AppStrings.nameSetRoute,
              arguments: {'phone': userPhone ?? phone},
            );
          } else {
            Get.offAllNamed(AppStrings.navbarRoute);
          }
        }
      } else {
        hasError.value = true;
        final errorMessage = response.body != null && response.body is Map
            ? (response.body['message'] ?? 'OTP verification failed')
            : 'Invalid OTP code';
        Get.snackbar(
          'Verification Failed',
          errorMessage.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      hasError.value = true;
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

  @override
  void onClose() {
    _timer?.cancel();
    try {
      SmsAutoFill().unregisterListener();
    } catch (e) {
      debugPrint('Error unregistering SMS listener: $e');
    }
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}
