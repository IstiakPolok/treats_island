import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
                      ),

                      const SizedBox(height: 20),

                      // ── Header Text ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'LOGIN',
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

                      const SizedBox(height: 16),

                      // ── Forget Password Button ────────────────────────────────
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: controller.forgetPassword,
                          child: Text(
                            'Forget password?',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
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

                      // ── Sign Up Navigation Footer ────────────────────────────
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
                              const TextSpan(text: 'Don’t have an account? '),
                              TextSpan(
                                text: 'Sign Up',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = controller.navigateToSignUp,
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
