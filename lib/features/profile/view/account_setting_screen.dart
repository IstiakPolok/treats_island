import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';

class AccountSettingScreen extends StatefulWidget {
  final bool isEmbedded;
  const AccountSettingScreen({super.key, this.isEmbedded = false});

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
              image = 'https://intensely-optimal-unicorn.ngrok-free.app$image';
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
    if (name.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your name',
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
        phone: _phoneController.text.trim(),
        imagePath: _selectedImagePath,
      );

      if (response.status.isOk) {
        await SharedPreferencesHelper.saveName(name);

        // Save the new image URL returned by the API if present
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
        if (!widget.isEmbedded) {
          Get.back(); // Go back to profile screen
        }
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16.0 : 16.r),
          ),
          content: Text(
            'Are you sure to delete account',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 12.0 : 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF6FB6),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Delete account',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF5C5C),
                ),
              ),
            ),
          ],
        );
      },
    );
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
                          enabled: false, // email usually read-only
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
  final bool enabled;

  const _InputField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.enabled = true,
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
          enabled: enabled,
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
