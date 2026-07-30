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
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24.0 : 28.0.w,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                              'LOGIN',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.antonSc(
                                fontSize: isTablet ? 38.0 : 48.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                          SizedBox(height: isTablet ? 30.0 : 30.h),
                          // ── Input Fields ─────────────────────────────────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Obx(
                                () => CountryCodePicker(
                                  selectedCountry:
                                      controller.selectedCountry.value,
                                  onSelect: (country) {
                                    controller.selectedCountry.value = country;
                                  },
                                ),
                              ),
                              SizedBox(width: isTablet ? 12.0 : 12.w),
                              Expanded(
                                child: CustomTextField(
                                  controller: controller.phoneController,
                                  hintText: 'phone number',
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 48.0 : 48.h),
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
                          SizedBox(height: isTablet ? 28.0 : 28.h),
                          // ── Sign Up Navigation Footer ────────────────────────────
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 14.0 : 14.sp,
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
                                      fontSize: isTablet ? 14.0 : 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = controller.navigateToSignUp,
                                  ),
                                ],
                              ),
                            ),
                          ),
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
