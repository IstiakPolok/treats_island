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
  int _selectedMenuIndex = 0;

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

  Widget _buildDetailView(int index) {
    switch (index) {
      case 0:
        return const AccountSettingScreen(isEmbedded: true);
      case 1:
        return const EventsListScreen(isEmbedded: true);
      case 2:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Help Center',
              style: GoogleFonts.poppins(
                color: const Color(0xFF1A1A2E),
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            centerTitle: false,
          ),
          body: Center(
            child: Text(
              'Help center information and support details will appear here.',
              style: GoogleFonts.poppins(color: Colors.black45, fontSize: 13.0),
            ),
          ),
        );
      case 3:
        return const TermsConditionsScreen(isEmbedded: true);
      default:
        return const Center(child: Text('Select an option'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isTablet
          ? Row(
              children: [
                // Left Pane: Menu list
                SizedBox(
                  width: 320.0,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: 16.0,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(22.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 40.0),
                              GestureDetector(
                                onTap: _isUploading
                                    ? null
                                    : _updateProfileImage,
                                child: CircleAvatar(
                                  radius: 42.0,
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  backgroundImage:
                                      _userImageUrl.isNotEmpty && !_isUploading
                                      ? NetworkImage(_userImageUrl)
                                      : null,
                                  child: _isUploading
                                      ? const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        )
                                      : (_userImageUrl.isEmpty
                                            ? Text(
                                                _userName.isNotEmpty
                                                    ? _userName[0].toUpperCase()
                                                    : 'J',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(
                                                    0xFF1A1A2E,
                                                  ),
                                                ),
                                              )
                                            : null),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _userName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    _userEmail,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Account',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
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
                                      isSelected: _selectedMenuIndex == 0,
                                      onTap: () {
                                        setState(() => _selectedMenuIndex = 0);
                                      },
                                    ),
                                    const Divider(
                                      height: 1.0,
                                      color: Color(0xFFEDEDF2),
                                    ),
                                    _ProfileListItem(
                                      icon: Icons.event_outlined,
                                      label: 'Events',
                                      isSelected: _selectedMenuIndex == 1,
                                      onTap: () {
                                        setState(() => _selectedMenuIndex = 1);
                                      },
                                    ),
                                    const Divider(
                                      height: 1.0,
                                      color: Color(0xFFEDEDF2),
                                    ),
                                    _ProfileListItem(
                                      icon: Icons.help_outline,
                                      label: 'Help center',
                                      isSelected: _selectedMenuIndex == 2,
                                      onTap: () {
                                        setState(() => _selectedMenuIndex = 2);
                                      },
                                    ),
                                    const Divider(
                                      height: 1.0,
                                      color: Color(0xFFEDEDF2),
                                    ),
                                    _ProfileListItem(
                                      icon: Icons.description_outlined,
                                      label: 'Terms & conditions',
                                      isSelected: _selectedMenuIndex == 3,
                                      onTap: () {
                                        setState(() => _selectedMenuIndex = 3);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
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
                              const SizedBox(height: 30.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Divider
                const VerticalDivider(width: 1, color: Color(0xFFEDEDF2)),
                // Right Pane: Detail View
                Expanded(child: _buildDetailView(_selectedMenuIndex)),
              ],
            )
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 500.0 : double.infinity,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 18.0 : 18.w,
                          vertical: isTablet ? 16.0 : 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 22.0 : 22.r,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: isTablet ? 30.0 : 30.h),
                            GestureDetector(
                              onTap: _isUploading ? null : _updateProfileImage,
                              child: CircleAvatar(
                                radius: isTablet ? 42.0 : 42.r,
                                backgroundColor: const Color(0xFFD9D9D9),
                                backgroundImage:
                                    _userImageUrl.isNotEmpty && !_isUploading
                                    ? NetworkImage(_userImageUrl)
                                    : null,
                                child: _isUploading
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      )
                                    : (_userImageUrl.isEmpty
                                          ? Text(
                                              _userName.isNotEmpty
                                                  ? _userName[0].toUpperCase()
                                                  : 'J',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: isTablet
                                                    ? 18.0
                                                    : 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF1A1A2E),
                                              ),
                                            )
                                          : null),
                              ),
                            ),
                            SizedBox(height: isTablet ? 12.0 : 12.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _userName,
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 16.0 : 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 4.0 : 4.h),
                                Text(
                                  _userEmail,
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 11.0 : 11.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 18.0 : 18.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20.0 : 20.w,
                          vertical: isTablet ? 16.0 : 16.h,
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Account',
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 12.0 : 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            SizedBox(height: isTablet ? 10.0 : 10.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 12.0 : 12.w,
                                vertical: isTablet ? 6.0 : 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 18.0 : 18.r,
                                ),
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
                                    onTap: () => Get.to(
                                      () => const AccountSettingScreen(),
                                    ),
                                  ),
                                  Divider(
                                    height: isTablet ? 1.0 : 1.h,
                                    color: const Color(0xFFEDEDF2),
                                  ),
                                  _ProfileListItem(
                                    icon: Icons.event_outlined,
                                    label: 'Events',
                                    onTap: () =>
                                        Get.to(() => const EventsListScreen()),
                                  ),
                                  Divider(
                                    height: isTablet ? 1.0 : 1.h,
                                    color: const Color(0xFFEDEDF2),
                                  ),
                                  const _ProfileListItem(
                                    icon: Icons.help_outline,
                                    label: 'Help center',
                                  ),
                                  Divider(
                                    height: isTablet ? 1.0 : 1.h,
                                    color: const Color(0xFFEDEDF2),
                                  ),
                                  _ProfileListItem(
                                    icon: Icons.description_outlined,
                                    label: 'Terms & conditions',
                                    onTap: () => Get.to(
                                      () => const TermsConditionsScreen(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isTablet ? 14.0 : 14.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 12.0 : 12.w,
                                vertical: isTablet ? 6.0 : 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 18.0 : 18.r,
                                ),
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
                            SizedBox(height: isTablet ? 70.0 : 70.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
  final bool isSelected;

  const _ProfileListItem({
    required this.icon,
    required this.label,
    this.iconColor,
    this.labelColor,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isTablet ? 14.0 : 14.r),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDE8F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(isTablet ? 14.0 : 14.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 8.0 : 6.w,
            vertical: isTablet ? 12.0 : 10.h,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: isTablet ? 18.0 : 18.sp,
                color: isSelected
                    ? const Color(0xFFFF6FB6)
                    : (iconColor ?? const Color(0xFF1A1A2E)),
              ),
              SizedBox(width: isTablet ? 10.0 : 10.w),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 12.0 : 12.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFFFF6FB6)
                        : (labelColor ?? const Color(0xFF1A1A2E)),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: isTablet ? 18.0 : 18.sp,
                color: isSelected ? const Color(0xFFFF6FB6) : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
