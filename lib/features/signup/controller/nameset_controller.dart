import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';

class NameSetController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final RxnString selectedImagePath = RxnString();
  final RxBool isLoading = false.obs;
  final ApiService _apiService = Get.put(ApiService());
  final ImagePicker _picker = ImagePicker();

  String phone = '';

  @override
  void onInit() {
    super.onInit();
    final Map? args = Get.arguments as Map?;
    phone = args?['phone'] ?? '';
    _loadPhoneIfNeeded();
  }

  Future<void> _loadPhoneIfNeeded() async {
    if (phone.isEmpty) {
      phone = await SharedPreferencesHelper.getPhone();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar(
        'Image Selection Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void submitName() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

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

    if (email.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address',
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
        phone: phone.isNotEmpty ? phone : null,
        email: email,
        imagePath: selectedImagePath.value,
      );

      if (response.status.isOk) {
        await SharedPreferencesHelper.saveName(name);
        await SharedPreferencesHelper.saveEmail(email);

        if (response.body != null && response.body is Map) {
          var updatedImage = response.body['image']?.toString() ?? '';
          if (updatedImage.isNotEmpty) {
            if (updatedImage.startsWith('/')) {
              updatedImage = '${ApiService.defaultBaseUrl}$updatedImage';
            }
            await SharedPreferencesHelper.saveUserImage(updatedImage);
          }
        }

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
