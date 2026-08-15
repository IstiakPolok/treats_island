import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../controller/otp_controller.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OTPController());
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
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 480.0 : double.infinity,
                ),
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
                                  // ── OTP Card ─────────────────────────────────────────
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'VERIFY OTP',
                                          style: GoogleFonts.bebasNeue(
                                            fontSize: isTablet ? 38.0 : 38.sp,
                                            color: const Color(0xFF1D2951),
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: isTablet ? 14.0 : 14.h,
                                        ),
                                        Text(
                                          'Code Has Been Sent To ${controller.phone}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: isTablet ? 14.0 : 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(
                                              0xFF1A1A2E,
                                            ).withValues(alpha: 0.8),
                                          ),
                                        ),
                                        SizedBox(
                                          height: isTablet ? 28.0 : 28.h,
                                        ),
                                        // OTP Input Fields Stack
                                        AutofillGroup(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.otpFocusNode
                                                  .requestFocus();
                                            },
                                            child: Stack(
                                              children: [
                                                // Visual styled circles
                                                Obx(() {
                                                  final codeValue =
                                                      controller.code.value;
                                                  final activeIdx = controller
                                                      .activeIndex
                                                      .value;
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: List.generate(6, (
                                                      index,
                                                    ) {
                                                      final isActive =
                                                          activeIdx == index;
                                                      final char =
                                                          index <
                                                              codeValue.length
                                                          ? codeValue[index]
                                                          : '';
                                                      return Container(
                                                        width: isTablet
                                                            ? 50.0
                                                            : 42.r,
                                                        height: isTablet
                                                            ? 50.0
                                                            : 42.r,
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              const Color(
                                                                0xFFF14095,
                                                              ).withValues(
                                                                alpha: 0.05,
                                                              ),
                                                          border: Border.all(
                                                            color: isActive
                                                                ? const Color(
                                                                    0xFFF14095,
                                                                  )
                                                                : const Color(
                                                                    0xFFF14095,
                                                                  ).withValues(
                                                                    alpha: 0.3,
                                                                  ),
                                                            width: isActive
                                                                ? (isTablet
                                                                      ? 2.0
                                                                      : 2.w)
                                                                : (isTablet
                                                                      ? 1.0
                                                                      : 1.w),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            char,
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  fontSize:
                                                                      isTablet
                                                                      ? 18.0
                                                                      : 18.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  );
                                                }),
                                                // Invisible TextField overlaying the Row
                                                Positioned.fill(
                                                  child: Opacity(
                                                    opacity: 0.01,
                                                    child: TextField(
                                                      controller: controller
                                                          .otpController,
                                                      focusNode: controller
                                                          .otpFocusNode,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 6,
                                                      autofillHints: const [
                                                        AutofillHints
                                                            .oneTimeCode,
                                                      ],
                                                      decoration:
                                                          const InputDecoration(
                                                            counterText: '',
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                      onChanged: (value) {
                                                        if (value.length == 6) {
                                                          controller
                                                              .verifyOTP();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: isTablet ? 24.0 : 24.h,
                                        ),
                                        // Resend code option
                                        Obx(() {
                                          if (controller.canResend.value) {
                                            return GestureDetector(
                                              onTap: controller.resendCode,
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: GoogleFonts.poppins(
                                                    fontSize: isTablet
                                                        ? 14.0
                                                        : 14.sp,
                                                    color: const Color(
                                                      0xFF1A1A2E,
                                                    ).withValues(alpha: 0.6),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  children: [
                                                    const TextSpan(
                                                      text:
                                                          'Didn’t receive the code? ',
                                                    ),
                                                    const TextSpan(
                                                      text: 'Resend',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFFF14095,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: GoogleFonts.poppins(
                                                  fontSize: isTablet
                                                      ? 14.0
                                                      : 14.sp,
                                                  color: const Color(
                                                    0xFF1A1A2E,
                                                  ).withValues(alpha: 0.6),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: [
                                                  const TextSpan(
                                                    text: 'Resend code in ',
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${controller.secondsRemaining.value}s',
                                                    style: const TextStyle(
                                                      color: Color(0xFFF14095),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }),
                                        SizedBox(
                                          height: isTablet ? 20.0 : 20.h,
                                        ),
                                        // Error Message Container
                                        Obx(() {
                                          if (controller.hasError.value) {
                                            return Container(
                                              padding: EdgeInsets.all(
                                                isTablet ? 12.0 : 12.r,
                                              ),
                                              margin: EdgeInsets.only(
                                                bottom: isTablet ? 20.0 : 20.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFEBEE),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFEF9A9A,
                                                  ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      isTablet ? 20.0 : 20.r,
                                                    ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                    size: isTablet
                                                        ? 20.0
                                                        : 20.sp,
                                                  ),
                                                  SizedBox(
                                                    width: isTablet ? 8.0 : 8.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Oh no! The code you entered is incorrect.',
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: isTablet
                                                                ? 13.0
                                                                : 13.sp,
                                                            color: Colors
                                                                .red
                                                                .shade800,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }),
                                        // Verification Submit Button
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
                                                  text:
                                                      controller.hasError.value
                                                      ? 'Try again?'
                                                      : 'Submit',
                                                  backgroundColor:
                                                      controller.hasError.value
                                                      ? Colors.red
                                                      : const Color(0xFFF14095),
                                                  onPressed:
                                                      controller.verifyOTP,
                                                );
                                        }),
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
            ),
          ),
          // Floating Absolute Back Button
          Positioned(
            top: 10.h,
            left: 10.w,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.sp,
                        color: const Color(0xFF1D2951),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Back',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D2951),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
