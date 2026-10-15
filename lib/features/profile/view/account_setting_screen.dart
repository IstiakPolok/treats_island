import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../home/controller/home_controller.dart';

class AccountSettingScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onProfileUpdated;
  const AccountSettingScreen({
    super.key,
    this.isEmbedded = false,
    this.onProfileUpdated,
  });

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  String _userImageUrl = '';
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadLocalProfile();
    _fetchProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadLocalProfile() async {
    final name = await SharedPreferencesHelper.getName();
    final email = await SharedPreferencesHelper.getEmail();
    final image = await SharedPreferencesHelper.getUserImage();
    setState(() {
      _nameController.text = name;
      _userImageUrl = image;
      if (email != 'me') {
        _emailController.text = email;
      }
    });
  }

  Future<void> _fetchProfileData() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null && token.isNotEmpty) {
      try {
        final apiService = Get.isRegistered<ApiService>()
            ? Get.find<ApiService>()
            : Get.put(ApiService());
        final response = await apiService.getProfile(token);
        if (response.status.isOk &&
            response.body != null &&
            response.body is Map) {
          final fullName = response.body['full_name']?.toString() ?? '';
          final email = response.body['email']?.toString() ?? '';
          final phone = response.body['phone']?.toString() ?? '';
          var image = response.body['image']?.toString() ?? '';

          if (image.isNotEmpty) {
            if (image.startsWith('/')) {
              image = '${ApiService.defaultBaseUrl}$image';
            }
            await SharedPreferencesHelper.saveUserImage(image);
          }
          if (fullName.isNotEmpty) {
            await SharedPreferencesHelper.saveName(fullName);
          }
          if (email.isNotEmpty) {
            await SharedPreferencesHelper.saveEmail(email);
          }

          if (mounted) {
            setState(() {
              _nameController.text = fullName;
              _emailController.text = email;
              _phoneController.text = phone;
              _userImageUrl = image;
            });
          }
        }
      } catch (e) {
        // Ignore background error
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  void _saveProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'Authentication token not found.',
          snackPosition: SnackPosition.BOTTOM,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());
      final response = await apiService.updateProfile(
        token: token,
        fullName: name,
        email: email,
        phone: phone,
        imagePath: _selectedImagePath,
      );

      if (response.status.isOk) {
        await SharedPreferencesHelper.saveName(name);
        await SharedPreferencesHelper.saveEmail(email);

        // Save the new image URL returned by the API if present
        if (response.body != null && response.body is Map) {
          final returnedName = response.body['full_name']?.toString() ??
              response.body['name']?.toString();
          if (returnedName != null && returnedName.isNotEmpty) {
            await SharedPreferencesHelper.saveName(returnedName);
          }
          final returnedEmail = response.body['email']?.toString();
          if (returnedEmail != null && returnedEmail.isNotEmpty) {
            await SharedPreferencesHelper.saveEmail(returnedEmail);
          }
          var updatedImage = response.body['image']?.toString() ?? '';
          if (updatedImage.isNotEmpty) {
            if (updatedImage.startsWith('/')) {
              updatedImage = '${ApiService.defaultBaseUrl}$updatedImage';
            }
            await SharedPreferencesHelper.saveUserImage(updatedImage);
          }
        }

        // Immediately update HomeController so Home screen shows the new name & email
        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          homeController.userName.value = name;
          homeController.userEmail.value = email;
          homeController.refreshUserData();
        }

        widget.onProfileUpdated?.call();

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withAlpha(26),
          colorText: Colors.black,
        );
        if (!widget.isEmbedded) {
          Get.back(); // Go back to profile screen
        }
      } else {
        String errorMessage = 'Failed to update profile';
        if (response.body != null && response.body is Map) {
          final body = response.body as Map;
          if (body['detail'] != null) {
            errorMessage = body['detail'].toString();
          } else if (body['message'] != null) {
            errorMessage = body['message'].toString();
          } else if (body['email'] != null) {
            final e = body['email'];
            errorMessage = e is List ? e.first.toString() : e.toString();
          } else if (body['non_field_errors'] != null) {
            final e = body['non_field_errors'];
            errorMessage = e is List ? e.first.toString() : e.toString();
          } else {
            errorMessage = body.values.first.toString();
          }
        }
        Get.snackbar(
          'Update Failed',
          errorMessage,
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'Authentication token not found.',
          snackPosition: SnackPosition.BOTTOM,
        );
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());

      final response = await apiService.deleteAccount(token);

      if (response.status.isOk ||
          response.statusCode == 200 ||
          response.statusCode == 204) {
        final message = response.body is Map && response.body['message'] != null
            ? response.body['message'].toString()
            : 'Account deleted successfully.';

        await SharedPreferencesHelper.clearAllData();

        Get.offAllNamed(AppStrings.loginRoute);

        Get.snackbar(
          'Account Deleted',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withAlpha(26),
          colorText: Colors.black,
        );
      } else {
        final errorMessage = response.body != null && response.body is Map
            ? (response.body['detail'] ??
                  response.body['message'] ??
                  'Failed to delete account')
            : 'Failed to delete account';
        Get.snackbar(
          'Delete Failed',
          errorMessage.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.red,
        );
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(26),
        colorText: Colors.red,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => const _DeleteAccountDialog(),
    );

    if (confirmed == true && mounted) {
      await _deleteAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarChar = _nameController.text.isNotEmpty
        ? _nameController.text[0].toUpperCase()
        : 'J';
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 420.0 : double.infinity,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                      vertical: isTablet ? 12.0 : 12.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if (!widget.isEmbedded)
                              IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(Icons.close),
                              ),
                            Expanded(
                              child: Align(
                                alignment: widget.isEmbedded
                                    ? Alignment.centerLeft
                                    : Alignment.center,
                                child: Text(
                                  'Account setting',
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 14.0 : 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _saveProfile,
                              child: Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 12.0 : 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFF6FB6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 16.0 : 16.h),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: isTablet ? 36.0 : 36.r,
                                backgroundColor: const Color(0xFFD9D9D9),
                                backgroundImage: _selectedImagePath != null
                                    ? FileImage(File(_selectedImagePath!))
                                    : (_userImageUrl.isNotEmpty
                                          ? NetworkImage(_userImageUrl)
                                          : null),
                                child:
                                    _selectedImagePath == null &&
                                        _userImageUrl.isEmpty
                                    ? Text(
                                        avatarChar,
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet ? 20.0 : 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1A1A2E),
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(height: isTablet ? 6.0 : 6.h),
                              Text(
                                'Edit',
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 11.0 : 11.sp,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isTablet ? 18.0 : 18.h),
                        _InputField(
                          label: 'Name',
                          controller: _nameController,
                          hintText: 'John',
                        ),
                        SizedBox(height: isTablet ? 12.0 : 12.h),
                        _InputField(
                          label: 'Email',
                          controller: _emailController,
                          hintText: 'xyz@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: isTablet ? 12.0 : 12.h),
                        _InputField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          hintText: 'No phone number provided',
                        ),
                        SizedBox(height: isTablet ? 24.0 : 24.h),
                        GestureDetector(
                          onTap: () => _showDeleteDialog(context),
                          child: Text(
                            'Delete my account',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 12.0 : 12.sp,
                              color: const Color(0xFFFF5C5C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 20.0 : 20.h),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 11.0 : 11.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: isTablet ? 6.0 : 6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(fontSize: isTablet ? 13.0 : 13.sp),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              fontSize: isTablet ? 12.0 : 12.sp,
              color: Colors.black38,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F7FB),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16.0 : 16.w,
              vertical: isTablet ? 14.0 : 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 14.0 : 14.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  late final TextEditingController _controller;
  bool _isMatch = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final match = value.trim().toLowerCase() == 'delete';
    if (match != _isMatch) {
      setState(() {
        _isMatch = match;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16.0 : 16.0),
      ),
      title: Text(
        'Delete Account',
        style: GoogleFonts.poppins(
          fontSize: isTablet ? 16.0 : 16.0,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. All your data and events will be permanently removed.',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 12.0 : 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14.0),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 11.0 : 11.0,
                  color: Colors.black54,
                ),
                children: [
                  const TextSpan(text: 'Please type '),
                  TextSpan(
                    text: 'delete',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFF5C5C),
                    ),
                  ),
                  const TextSpan(text: ' to confirm:'),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              autofocus: true,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 13.0 : 13.0,
              ),
              decoration: InputDecoration(
                hintText: 'delete',
                hintStyle: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.0,
                  color: Colors.black38,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7FB),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 12.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Color(0xFFEDEDF2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5C5C),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 12.0 : 12.0,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        TextButton(
          onPressed: _isMatch ? () => Navigator.of(context).pop(true) : null,
          child: Text(
            'Delete account',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 12.0 : 12.0,
              fontWeight: FontWeight.w600,
              color: _isMatch
                  ? const Color(0xFFFF5C5C)
                  : Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }
}
