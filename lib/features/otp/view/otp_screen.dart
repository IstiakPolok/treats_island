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
    final logoSize = isTablet ? 200.0 : 160.r;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 420.0 : double.infinity,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24.0 : 28.0.w,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: isTablet ? 20.0 : 20.h),

                          // ── Centered Logo ──────────────────────────────────────────
                          Image.asset(
                            AppAssets.splashLogo,
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: isTablet ? 20.0 : 20.h),

                          // ── Header Text ──────────────────────────────────────────
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'OTP CODE\nVERIFICATION',
                              style: GoogleFonts.antonSc(
                                fontSize: isTablet ? 38.0 : 48.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF1A1A2E),
                                height: 1.1,
                              ),
                            ),
                          ),

                          SizedBox(height: isTablet ? 16.0 : 16.h),

                          // ── Subtitle ─────────────────────────────────────────────
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Code Has Been Sent To ${controller.phone}',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 14.0 : 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(
                                  0xFF1A1A2E,
                                ).withValues(alpha: 0.8),
                              ),
                            ),
                          ),

                          SizedBox(height: isTablet ? 32.0 : 32.h),

                          // ── OTP Input Fields ──────────────────────────────────────
                          AutofillGroup(
                            child: GestureDetector(
                              onTap: () {
                                controller.otpFocusNode.requestFocus();
                              },
                              child: Stack(
                                children: [
                                  // Visual styled circles
                                  Obx(() {
                                    final codeValue = controller.code.value;
                                    final activeIdx = controller.activeIndex.value;
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        6,
                                        (index) {
                                          final isActive = activeIdx == index;
                                          final char = index < codeValue.length
                                              ? codeValue[index]
                                              : '';
                                          return Container(
                                            width: isTablet ? 56.0 : 48.r,
                                            height: isTablet ? 56.0 : 48.r,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.pink.withValues(
                                                alpha: 0.05,
                                              ),
                                              border: Border.all(
                                                color: isActive
                                                    ? AppColors.primary
                                                    : Colors.pink.withValues(
                                                        alpha: 0.3,
                                                      ),
                                                width: isActive
                                                    ? (isTablet ? 2.0 : 2.w)
                                                    : (isTablet ? 1.0 : 1.w),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                char,
                                                style: GoogleFonts.poppins(
                                                  fontSize: isTablet
                                                      ? 18.0
                                                      : 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                  // Invisible TextField overlaying the Row to handle keyboard & autofill
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.01,
                                      child: TextField(
                                        controller: controller.otpController,
                                        focusNode: controller.otpFocusNode,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        autofillHints: const [
                                          AutofillHints.oneTimeCode,
                                        ],
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          if (value.length == 6) {
                                            controller.verifyOTP();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: isTablet ? 16.0 : 16.h),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Obx(() {
                              if (controller.canResend.value) {
                                return GestureDetector(
                                  onTap: controller.resendCode,
                                  child: RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                        fontSize: isTablet ? 14.0 : 14.sp,
                                        color: const Color(
                                          0xFF1A1A2E,
                                        ).withValues(alpha: 0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Didn’t receive the code? ',
                                        ),
                                        TextSpan(
                                          text: 'Resend',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: isTablet ? 14.0 : 14.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 14.0 : 14.sp,
                                      color: const Color(
                                        0xFF1A1A2E,
                                      ).withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Resend code in '),
                                      TextSpan(
                                        text:
                                            '${controller.secondsRemaining.value}s',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: isTablet ? 14.0 : 14.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                          ),

                          SizedBox(height: isTablet ? 30.0 : 30.h),

                          // ── Error Message ────────────────────────────────────────
                          Obx(() {
                            if (controller.hasError.value) {
                              return Container(
                                padding: EdgeInsets.all(isTablet ? 12.0 : 12.r),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEE),
                                  border: Border.all(
                                    color: const Color(0xFFEF9A9A),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 20.0 : 20.r,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: isTablet ? 20.0 : 20.sp,
                                    ),
                                    SizedBox(width: isTablet ? 8.0 : 8.w),
                                    Expanded(
                                      child: Text(
                                        'Oh no! The code you entered is incorrect.',
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet ? 13.0 : 13.sp,
                                          color: Colors.red.shade800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          SizedBox(height: isTablet ? 16.0 : 16.h),

                          // ── Verification Button ──────────────────────────────────
                          Obx(() {
                            return controller.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  )
                                : PrimaryButton(
                                    text: controller.hasError.value
                                        ? 'Try again?'
                                        : 'Submit',
                                    backgroundColor: controller.hasError.value
                                        ? Colors.red
                                        : AppColors.primary,
                                    onPressed: controller.verifyOTP,
                                  );
                          }),

                          SizedBox(height: isTablet ? 20.0 : 20.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
