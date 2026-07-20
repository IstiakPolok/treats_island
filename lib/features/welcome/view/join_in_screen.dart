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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // ── Centered Logo ──────────────────────────────────────────
                    Image.asset(
                      AppAssets.splashLogo,
                      width: 200.w,
                      height: 200.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 32.h),

                    // ── JOIN IN Header ──────────────────────────────────────────
                    Text(
                      'welcome',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.antonSc(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // ── Subtitle ────────────────────────────────────────────────
                    // Text(
                    //   'FUNDRAISING WINDOW',
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 14.sp,
                    //     fontWeight: FontWeight.w500,
                    //     color: const Color(0xFF707080),
                    //     letterSpacing: 1.2,
                    //   ),
                    // ),
                    const Spacer(flex: 2),

                    // ── Action Buttons ─────────────────────────────────────────
                    PrimaryButton(
                      text: 'SIGN UP',
                      onPressed: () => Get.toNamed(AppStrings.signupRoute),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
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
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'LOG IN',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
