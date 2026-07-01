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
                        controller: controller.emailController,
                        hintText: 'email address',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: 20.h),

                      Obx(
                        () => CustomTextField(
                          controller: controller.passwordController,
                          hintText: 'Password',
                          obscureText: controller.hidePassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.hidePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF707080),
                            ),
                            onPressed: controller.toggleHidePassword,
                          ),
                        ),
                      ),

                      Obx(() {
                        final pwd = controller.password.value;
                        if (pwd.isEmpty) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: TextButton.icon(
                                onPressed: controller.generateStrongPassword,
                                icon: Icon(
                                  Icons.vpn_key_rounded,
                                  color: AppColors.primary,
                                  size: 18.sp,
                                ),
                                label: Text(
                                  'Generate strong password',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        return Container(
                          margin: EdgeInsets.only(top: 15.h, bottom: 5.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9FB),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFECECEF)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PASSWORD STRENGTH GUIDANCE',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF707080),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: controller.generateStrongPassword,
                                    child: Text(
                                      'Regenerate',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              _buildCriteriaItem(
                                'At least 8 characters',
                                controller.hasMinLength,
                              ),
                              _buildCriteriaItem(
                                'One uppercase letter (A-Z)',
                                controller.hasUppercase,
                              ),
                              _buildCriteriaItem(
                                'One lowercase letter (a-z)',
                                controller.hasLowercase,
                              ),
                              _buildCriteriaItem(
                                'One number (0-9)',
                                controller.hasDigits,
                              ),
                              _buildCriteriaItem(
                                'One special character (!@#\$%^&*)',
                                controller.hasSpecialCharacters,
                              ),
                            ],
                          ),
                        );
                      }),

                      SizedBox(height: 20.h),

                      Obx(
                        () => CustomTextField(
                          controller: controller.confirmPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: controller.hideConfirmPassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.hideConfirmPassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF707080),
                            ),
                            onPressed: controller.toggleHideConfirmPassword,
                          ),
                        ),
                      ),

                      Obx(() {
                        final confirmPwd = controller.confirmPassword.value;
                        if (confirmPwd.isEmpty) return const SizedBox.shrink();

                        final matches = controller.passwordsMatch;
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Row(
                            children: [
                              Icon(
                                matches
                                    ? Icons.check_circle_rounded
                                    : Icons.error_outline_rounded,
                                color: matches ? Colors.green : Colors.red,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                matches
                                    ? 'Passwords match'
                                    : 'Passwords do not match',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: matches
                                      ? const Color(0xFF2E7D32)
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

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

  Widget _buildCriteriaItem(String title, bool isValid) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(
            isValid
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: isValid ? Colors.green : const Color(0xFFC0C0C5),
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isValid
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFF707080),
              decoration: isValid ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}
