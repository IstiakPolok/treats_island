import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';

class NameSetController extends GetxController {
  final nameController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void submitName() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    // Simulate API call to save name
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.offAllNamed(AppStrings.navbarRoute);
    });
  }
}
