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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 28.0.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),

                      // ── Centered Logo ──────────────────────────────────────────
                      Image.asset(
                        AppAssets.splashLogo,
                        width: 200.w,
                        height: 200.h,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 20.h),

                      // ── Header Text ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'OTP CODE\nVERIFICATION',
                          style: GoogleFonts.antonSc(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1A1A2E),
                            height: 1.1,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // ── Subtitle ─────────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Code Has Been Sent To ${controller.email}',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(
                              0xFF1A1A2E,
                            ).withValues(alpha: 0.8),
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // ── OTP Input Fields ──────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => _buildOTPField(context, index, controller),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // ── Resend / Timer ────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Obx(() {
                          if (controller.canResend.value) {
                            return GestureDetector(
                              onTap: controller.resendCode,
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
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
                                        fontSize: 14.sp,
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
                                  fontSize: 14.sp,
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
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                      ),

                      SizedBox(height: 30.h),

                      // ── Error Message ────────────────────────────────────────
                      Obx(() {
                        if (controller.hasError.value) {
                          return Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              border: Border.all(
                                color: const Color(0xFFEF9A9A),
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Oh no! The code you entered is incorrect.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
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

                      const Spacer(),

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
                                    : 'Send verification code',
                                backgroundColor: controller.hasError.value
                                    ? Colors.red
                                    : AppColors.primary,
                                onPressed: controller.verifyOTP,
                              );
                      }),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOTPField(
    BuildContext context,
    int index,
    OTPController controller,
  ) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.pink.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.length == 1 && index < 5) {
              controller.focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              controller.focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
