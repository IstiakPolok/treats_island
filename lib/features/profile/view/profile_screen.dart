import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import 'account_setting_screen.dart';
import 'events_list_screen.dart';
import 'terms_conditions_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'John';
  String _userEmail = 'johndoe@gmail.com';
  String _userImageUrl = '';
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadLocalProfile();
    _fetchProfileData();
  }

  Future<void> _loadLocalProfile() async {
    final name = await SharedPreferencesHelper.getName();
    final email = await SharedPreferencesHelper.getEmail();
    final image = await SharedPreferencesHelper.getUserImage();
    if (mounted) {
      setState(() {
        if (name.isNotEmpty) _userName = name;
        if (email.isNotEmpty && email != 'me') _userEmail = email;
        _userImageUrl = image;
      });
    }
  }

  Future<void> _updateProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });
      try {
        final token = await SharedPreferencesHelper.getAccessToken();
        if (token == null || token.isEmpty) {
          Get.snackbar('Error', 'Authentication token not found.');
          return;
        }

        final apiService = Get.isRegistered<ApiService>()
            ? Get.find<ApiService>()
            : Get.put(ApiService());

        final response = await apiService.updateProfile(
          token: token,
          imagePath: pickedFile.path,
        );

        if (response.status.isOk) {
          if (response.body != null && response.body is Map) {
            var updatedImage = response.body['image']?.toString() ?? '';
            if (updatedImage.isNotEmpty) {
              if (updatedImage.startsWith('/')) {
                updatedImage = '${ApiService.defaultBaseUrl}$updatedImage';
              }
              await SharedPreferencesHelper.saveUserImage(updatedImage);
              setState(() {
                _userImageUrl = updatedImage;
              });
            }
          }
          Get.snackbar(
            'Success',
            'Profile image updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withAlpha(26),
            colorText: Colors.green,
          );
        } else {
          Get.snackbar(
            'Upload Failed',
            'Failed to update profile image',
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
            _isUploading = false;
          });
        }
      }
    }
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
              if (fullName.isNotEmpty) _userName = fullName;
              if (email.isNotEmpty) _userEmail = email;
              _userImageUrl = image;
            });
          }
        }
      } catch (e) {
        // Ignore background error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  GestureDetector(
                    onTap: _isUploading ? null : _updateProfileImage,
                    child: CircleAvatar(
                      radius: 42.r,
                      backgroundColor: const Color(0xFFD9D9D9),
                      backgroundImage: _userImageUrl.isNotEmpty && !_isUploading
                          ? NetworkImage(_userImageUrl)
                          : null,
                      child: _isUploading
                          ? const CircularProgressIndicator(strokeWidth: 2)
                          : (_userImageUrl.isEmpty
                                ? Text(
                                    _userName.isNotEmpty
                                        ? _userName[0].toUpperCase()
                                        : 'J',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  )
                                : null),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _userName,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _userEmail,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Account',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ProfileListItem(
                          icon: Icons.settings_outlined,
                          label: 'Account setting',
                          onTap: () =>
                              Get.to(() => const AccountSettingScreen()),
                        ),
                        Divider(height: 1.h, color: const Color(0xFFEDEDF2)),
                        _ProfileListItem(
                          icon: Icons.event_outlined,
                          label: 'Events',
                          onTap: () => Get.to(() => const EventsListScreen()),
                        ),
                        Divider(height: 1.h, color: const Color(0xFFEDEDF2)),
                        const _ProfileListItem(
                          icon: Icons.help_outline,
                          label: 'Help center',
                        ),
                        Divider(height: 1.h, color: const Color(0xFFEDEDF2)),
                        _ProfileListItem(
                          icon: Icons.description_outlined,
                          label: 'Terms & conditions',
                          onTap: () => Get.to(() => const TermsConditionsScreen()),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _ProfileListItem(
                      icon: Icons.logout,
                      label: 'Log out',
                      iconColor: const Color(0xFFFF5C5C),
                      labelColor: const Color(0xFFFF5C5C),
                      onTap: () async {
                        await SharedPreferencesHelper.clearAllData();
                        Get.offAllNamed(AppStrings.loginRoute);
                      },
                    ),
                  ),
                  SizedBox(height: 70.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback? onTap;

  const _ProfileListItem({
    required this.icon,
    required this.label,
    this.iconColor,
    this.labelColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: iconColor ?? const Color(0xFF1A1A2E),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: labelColor ?? const Color(0xFF1A1A2E),
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 18.sp, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
