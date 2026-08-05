import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final logoSize = isTablet ? 200.0 : 180.r;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(AppAssets.authBg, fit: BoxFit.cover),
          ),
          // Scrollable Content overlay
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Main Card and Logo container
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 24.0 : 24.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: isTablet ? 20.0 : 20.h),
                              // "Welcome to" header with outline effect
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '彡 ',
                                    style: GoogleFonts.pacifico(
                                      fontSize: isTablet ? 20.0 : 20.sp,
                                      color: const Color(0xFFF14095),
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Welcome to',
                                    style: GoogleFonts.pacifico(
                                      fontSize: isTablet ? 28.0 : 28.sp,
                                      color: const Color(0xFFF14095),
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(-1.5, -1.5),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                        Shadow(
                                          offset: Offset(1.5, -1.5),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                        Shadow(
                                          offset: Offset(1.5, 1.5),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                        Shadow(
                                          offset: Offset(-1.5, 1.5),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    ' 彡',
                                    style: GoogleFonts.pacifico(
                                      fontSize: isTablet ? 20.0 : 20.sp,
                                      color: const Color(0xFFF14095),
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isTablet ? 12.0 : 12.h),
                              // Centered Logo
                              Image.asset(
                                AppAssets.splashLogo,
                                width: logoSize,
                                height: logoSize,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: isTablet ? 16.0 : 16.h),
                              // "Virtual Fundraising" header
                              Text(
                                'Virtual Fundraising',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 26.0 : 26.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1D2951),
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      color: Colors.white70,
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: isTablet ? 4.0 : 4.h),
                              // "made easy" cursive with horizontal underlines
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ミ ─ ',
                                    style: GoogleFonts.pacifico(
                                      fontSize: isTablet ? 16.0 : 16.sp,
                                      color: const Color(0xFFF14095),
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'made easy',
                                    style: GoogleFonts.pacifico(
                                      fontSize: isTablet ? 24.0 : 24.sp,
                                      color: const Color(0xFFF14095),
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(-1.5, -1.5),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                        Shadow(
                                          offset: Offset(1.5, -1.5),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                        Shadow(
                                          offset: Offset(1.5, 1.5),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                        Shadow(
                                          offset: Offset(-1.5, 1.5),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    ' ─ 彡',
                                    style: GoogleFonts.pacifico(
                                      fontSize: isTablet ? 16.0 : 16.sp,
                                      color: const Color(0xFFF14095),
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          color: Colors.white,
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isTablet ? 28.0 : 28.h),
                              // ── Login Card ─────────────────────────────────────────
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 24.0 : 24.w,
                                  vertical: isTablet ? 28.0 : 28.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'LOGIN',
                                      style: GoogleFonts.bebasNeue(
                                        fontSize: isTablet ? 38.0 : 38.sp,
                                        color: const Color(0xFF1D2951),
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 24.0 : 24.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Obx(
                                          () => CountryCodePicker(
                                            selectedCountry: controller
                                                .selectedCountry
                                                .value,
                                            onSelect: (country) {
                                              controller.selectedCountry.value =
                                                  country;
                                            },
                                          ),
                                        ),
                                        SizedBox(width: isTablet ? 12.0 : 12.w),
                                        Expanded(
                                          child: CustomTextField(
                                            controller:
                                                controller.phoneController,
                                            hintText: 'Phone number',
                                            keyboardType: TextInputType.phone,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: isTablet ? 28.0 : 28.h),
                                    Obx(() {
                                      return controller.isLoading.value
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(AppColors.primary),
                                              ),
                                            )
                                          : PrimaryButton(
                                              text: 'Login',
                                              onPressed: controller.loginUser,
                                              backgroundColor: const Color(
                                                0xFFF14095,
                                              ),
                                            );
                                    }),
                                    SizedBox(height: isTablet ? 20.0 : 20.h),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet ? 13.0 : 13.sp,
                                          color: const Color(0xFF1A1A2E),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Don’t have an account? ',
                                          ),
                                          TextSpan(
                                            text: 'Sign Up',
                                            style: const TextStyle(
                                              color: Color(0xFFF14095),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap =
                                                  controller.navigateToSignUp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: isTablet ? 36.0 : 36.h),
                            ],
                          ),
                        ),
                        // ── Bottom Features Bar ───────────────────────────────
                        _buildBottomBar(context, isTablet),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isTablet) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isTablet ? 20.0 : 20.h,
        bottom: (isTablet ? 20.0 : 20.h) + bottomPadding,
        left: isTablet ? 12.0 : 12.w,
        right: isTablet ? 12.0 : 12.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFeatureItem(
              icon: Icons.access_time_filled_rounded,
              iconColor: const Color(0xFFF14095),
              text: 'Set up in\n90 seconds',
              isTablet: isTablet,
            ),
          ),
          _buildDivider(isTablet),
          Expanded(
            child: _buildFeatureItem(
              icon: Icons.share_rounded,
              iconColor: const Color(0xFF2196F3),
              text: 'Share your link\nwith your team',
              isTablet: isTablet,
            ),
          ),
          _buildDivider(isTablet),
          Expanded(
            child: _buildFeatureItem(
              icon: Icons.trending_up_rounded,
              iconColor: const Color(0xFF9C27B0),
              text: 'Raise more.\nStress less.',
              isTablet: isTablet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isTablet) {
    return Container(
      width: 1,
      height: isTablet ? 45.0 : 45.h,
      color: const Color(0xFFE0E0E0),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color iconColor,
    required String text,
    required bool isTablet,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isTablet ? 42.0 : 42.r,
          height: isTablet ? 42.0 : 42.r,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: isTablet ? 20.0 : 20.r),
        ),
        SizedBox(height: isTablet ? 10.0 : 10.h),
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 11.0 : 11.sp,
            color: const Color(0xFF1D2951),
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
