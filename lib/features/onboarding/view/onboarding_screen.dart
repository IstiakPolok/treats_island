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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(
        0xFFE5E5E5,
      ), // Light grey background matching screenshot
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(context, controller, size)
            : _buildMobileLayout(context, controller),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    OnboardingController controller,
  ) {
    return CustomScrollView(
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
                            key: ValueKey<int>(controller.currentIndex.value),
                            child: _buildStepText(
                              controller.currentIndex.value,
                              isTablet: false,
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Next / Action Button with circular progress ring
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Circular Progress Indicator representing 33%, 66%, and 100%
                              SizedBox(
                                width: 72
                                    .r, // FIXED: keep aspect ratio square using .r
                                height: 72
                                    .r, // FIXED: keep aspect ratio square using .r
                                child: CircularProgressIndicator(
                                  value:
                                      (controller.currentIndex.value + 1) /
                                      controller.totalSteps,
                                  strokeWidth: 3.r,
                                  backgroundColor: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
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
                                  width: 56
                                      .r, // FIXED: keep aspect ratio square using .r
                                  height: 56
                                      .r, // FIXED: keep aspect ratio square using .r
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 26
                                        .r, // FIXED: keep aspect ratio square using .r
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
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    OnboardingController controller,
    Size size,
  ) {
    return Row(
      children: [
        // Left side: Padded and stylized image container
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Image.asset(AppAssets.onboardingImage, fit: BoxFit.cover),
            ),
          ),
        ),

        // Right side: interactive content and button
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      controller.skipToNext();
                    },
                    child: Text(
                      'Skip',
                      style: GoogleFonts.poppins(
                        fontSize:
                            14, // FIXED: Changed from 16.sp to fixed 14 to prevent it from looking massive on tablet
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ),

              // Center the interactive content card
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth:
                            380, // FIXED: Constrained to 380px so it fits beautifully on wide displays
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 24, 24, 24),
                        child: Obx(() {
                          return Container(
                            padding: const EdgeInsets.all(28.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Dynamic text switcher
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 350),
                                  transitionBuilder:
                                      (
                                        Widget child,
                                        Animation<double> animation,
                                      ) {
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
                                      isTablet: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Next / Action Button with circular progress ring
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 72,
                                        height: 72,
                                        child: CircularProgressIndicator(
                                          value:
                                              (controller.currentIndex.value +
                                                  1) /
                                              controller.totalSteps,
                                          strokeWidth: 3,
                                          backgroundColor: AppColors.primary
                                              .withValues(alpha: 0.15),
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(AppColors.primary),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: controller.nextStep,
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 26,
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper to return styled RichText for each step
  Widget _buildStepText(int index, {required bool isTablet}) {
    // Custom ultra-bold style for primary text
    // On tablets, we use a fixed font size to fit the narrower split-column layout perfectly.
    final baseStyle = GoogleFonts.antonSc(
      fontSize: isTablet ? 24 : 30.sp,
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
                      size: isTablet ? 28 : 36.sp,
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
