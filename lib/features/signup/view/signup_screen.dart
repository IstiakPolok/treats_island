import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../controller/signup_controller.dart';
import '../../profile/view/terms_conditions_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

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
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.restaurant_menu_rounded,
                                size: 50.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20.h),

                      // ── Header Text ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'SIGN UP',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.antonSc(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // ── Input Fields ─────────────────────────────────────────
                      CustomTextField(
                        controller: controller.phoneController,
                        hintText: 'phone number',
                        keyboardType: TextInputType.phone,
                      ),

                      SizedBox(height: 20.h),

                      // ── Terms & Conditions Checkbox ──────────────────────────
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Checkbox(
                                value: controller.agreeToTerms.value,
                                onChanged: controller.toggleTerms,
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                side: BorderSide(
                                  color: const Color(0xFFB0B0B0),
                                  width: 1.5.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: RichText(
                                // ignore: deprecated_member_use
                                textScaleFactor: 1.0,
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF1A1A2E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'terms and conditions.',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(
                                            () => const TermsConditionsScreen(),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 48.h),

                      // ── Send Verification Code Button ────────────────────────
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
                                text: 'Send verification code',
                                onPressed: controller.sendVerificationCode,
                              );
                      }),

                      SizedBox(height: 28.h),

                      // ── Login Navigation Footer ──────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: const Color(0xFF1A1A2E),
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = controller.navigateToLogin,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
}
