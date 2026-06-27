import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';

class NameSetController extends GetxController {
  final nameController = TextEditingController();
  final RxBool isLoading = false.obs;
  final ApiService _apiService = Get.put(ApiService());

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void submitName() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final RegExp nameRegExp = RegExp(r"^[a-zA-Z\s]+$");
    if (!nameRegExp.hasMatch(name)) {
      Get.snackbar(
        'Invalid Name',
        'Name must contain only letters and spaces',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(26),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'Authentication token not found. Please log in again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.red,
        );
        isLoading.value = false;
        return;
      }

      final response = await _apiService.updateProfile(
        token: token,
        fullName: name,
      );

      if (response.status.isOk) {
        await SharedPreferencesHelper.saveName(name);
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withAlpha(26),
          colorText: Colors.black,
        );
        Get.offAllNamed(AppStrings.navbarRoute);
      } else {
        final errorMessage = response.body != null && response.body is Map
            ? (response.body['detail'] ??
                  response.body['message'] ??
                  'Failed to update profile')
            : 'Failed to update profile';
        Get.snackbar(
          'Update Failed',
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
}
