import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/primary_button.dart';

/// Screen displayed after WelcomeScreen.
/// Contains option to either Sign up or Log in.
class JoinInScreen extends StatelessWidget {
  const JoinInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final logoSize = isTablet ? 200.0 : 160.r;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 400.0 : double.infinity,
            ),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24.0 : 24.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),

                        // ── Centered Logo ──────────────────────────────────────────
                        Image.asset(
                          AppAssets.splashLogo,
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: isTablet ? 32.0 : 32.h),

                        // ── JOIN IN Header ──────────────────────────────────────────
                        Text(
                          'welcome',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.antonSc(
                            fontSize: isTablet ? 38.0 : 48.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: isTablet ? 8.0 : 8.h),
                        const Spacer(flex: 2),

                        // ── Action Buttons ─────────────────────────────────────────
                        PrimaryButton(
                          text: 'SIGN UP',
                          onPressed: () => Get.toNamed(AppStrings.signupRoute),
                        ),
                        SizedBox(height: isTablet ? 16.0 : 16.h),
                        SizedBox(
                          width: double.infinity,
                          height: isTablet ? 56.0 : 56.h,
                          child: OutlinedButton(
                            onPressed: () => Get.toNamed(AppStrings.loginRoute),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ), // light grey border
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(isTablet ? 30.0 : 30.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'LOG IN',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 16.0 : 16.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 70.0 : 70.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
