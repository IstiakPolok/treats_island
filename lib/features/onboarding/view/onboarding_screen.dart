import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: const Color(
        0xFFE5E5E5,
      ), // Light grey background matching screenshot
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        controller.skipToNext();
                      },
                      child: Text(
                        'Skip',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),

                  // ── Upper Image (remains same) ─────────────────────────────
                  Image.asset(AppAssets.onboardingImage, fit: BoxFit.cover),

                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.all(22.0.r),
                    child: Obx(() {
                      return Container(
                        padding: EdgeInsets.all(28.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 20.r,
                              offset: Offset(0, 8.h),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dynamic Styled Text based on active index
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    final slideAnimation =
                                        Tween<Offset>(
                                          begin: const Offset(0.2, 0.0),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutCubic,
                                          ),
                                        );
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: slideAnimation,
                                        child: child,
                                      ),
                                    );
                                  },
                              child: KeyedSubtree(
                                key: ValueKey<int>(
                                  controller.currentIndex.value,
                                ),
                                child: _buildStepText(
                                  controller.currentIndex.value,
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),

                            // Next / Action Button
                            // Next / Action Button with circular progress ring
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Circular Progress Indicator representing 33%, 66%, and 100%
                                  SizedBox(
                                    width: 72.w,
                                    height: 72.h,
                                    child: CircularProgressIndicator(
                                      value:
                                          (controller.currentIndex.value + 1) /
                                          controller.totalSteps,
                                      strokeWidth: 3.w,
                                      backgroundColor: AppColors.primary
                                          .withValues(alpha: 0.15),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            AppColors.primary,
                                          ),
                                    ),
                                  ),
                                  // Inner Pink Button
                                  GestureDetector(
                                    onTap: controller.nextStep,
                                    child: Container(
                                      width: 56.w,
                                      height: 56.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 26.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to return styled RichText for each step
  Widget _buildStepText(int index) {
    // Custom ultra-bold style for primary text
    final baseStyle = GoogleFonts.antonSc(
      fontSize: 30.sp,
      fontWeight: FontWeight.normal,
      height: 1.3,
      color: Colors.black87,
      letterSpacing: -0.5,
    );

    // Style for the pink highlighted parts
    final highlightStyle = baseStyle.copyWith(color: AppColors.primary);

    switch (index) {
      case 0:
        return RichText(
          text: TextSpan(
            style: baseStyle,
            children: [
              const TextSpan(text: 'The easiest '),
              TextSpan(text: 'FUNDRAISER', style: highlightStyle),
              const TextSpan(text: '\nyour team has ever run.'),
            ],
          ),
        );
      case 1:
        return RichText(
          text: TextSpan(
            style: baseStyle,
            children: [
              const TextSpan(
                text: 'Every sale helps your team reach its goal ',
              ),
              TextSpan(text: '\nkeep 50% ', style: highlightStyle),
              const TextSpan(text: 'of every order.'),
            ],
          ),
        );
      case 2:
      default:
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'TRUSTED BY 300+ TEAMS',
                textAlign: TextAlign.center,
                style: baseStyle,
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFFFB800),
                      size: 36.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                '4.9/5 AVERAGE RATING',
                textAlign: TextAlign.center,
                style: baseStyle,
              ),
              SizedBox(height: 12.h),
              Text(
                '\$2.8M+ RAISED',
                textAlign: TextAlign.center,
                style: baseStyle,
              ),
            ],
          ),
        );
    }
  }
}
