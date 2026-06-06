import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../controller/signup_controller.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // ── Centered Logo ──────────────────────────────────────────
                      Image.asset(
                        AppAssets.splashLogo,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.restaurant_menu_rounded,
                                size: 50,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // ── Header Text ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'SIGN UP',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.antonSc(
                            fontSize: 48,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ── Input Fields ─────────────────────────────────────────
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: 'email address',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        controller: controller.passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        controller: controller.confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),

                      // ── Terms & Conditions Checkbox ──────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => Checkbox(
                                  value: controller.agreeToTerms.value,
                                  onChanged: controller.toggleTerms,
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFFB0B0B0),
                                    width: 1.5,
                                  ),
                                )),
                            const SizedBox(width: 8),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF1A1A2E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'terms and conditions.',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.snackbar(
                                            'Terms & Conditions',
                                            'Displaying Terms and Conditions...',
                                            snackPosition: SnackPosition.BOTTOM,
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

                      const SizedBox(height: 48),

                      // ── Send Verification Code Button ────────────────────────
                      Obx(() {
                        return controller.isLoading.value
                            ? const Center(
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

                      const SizedBox(height: 28),

                      // ── Login Navigation Footer ──────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1A1A2E),
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                  color: AppColors.primary,
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
              )
            );
            
          },
        ),
      ),
    );
  }
}
