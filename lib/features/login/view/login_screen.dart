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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: Builder(
                builder: (context) {
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                              'LOGIN',
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
                          Obx(() => CustomTextField(
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
                          )),
                          SizedBox(height: 16.h),
                          // ── Forget Password Button ────────────────────────────────
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: controller.forgetPassword,
                              child: Text(
                                'Forget password?',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 48.h),
                          // ── Login Button ─────────────────────────────────────────
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
                                    text: 'Login',
                                    onPressed: controller.loginUser,
                                  );
                          }),
                          SizedBox(height: 28.h),
                          // ── Sign Up Navigation Footer ────────────────────────────
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
                                  const TextSpan(
                                    text: 'Don’t have an account? ',
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = controller.navigateToSignUp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
