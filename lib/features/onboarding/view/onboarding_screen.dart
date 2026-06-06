import 'package:flutter/material.dart';
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            // ── Upper Image (remains same) ─────────────────────────────
            Image.asset(AppAssets.onboardingImage, fit: BoxFit.cover),

            Spacer(),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Obx(() {
                return Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
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
                      // Dynamic Styled Text based on active index
                      _buildStepText(controller.currentIndex.value),
                      const SizedBox(height: 32),

                      // Next / Action Button
                      // Next / Action Button with circular progress ring
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Circular Progress Indicator representing 33%, 66%, and 100%
                            SizedBox(
                              width: 72,
                              height: 72,
                              child: CircularProgressIndicator(
                                value:
                                    (controller.currentIndex.value + 1) /
                                    controller.totalSteps,
                                strokeWidth: 3,
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            // Inner Pink Button
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
          ],
        ),
      ),
    );
  }

  /// Helper to return styled RichText for each step
  Widget _buildStepText(int index) {
    // Custom ultra-bold style for primary text
    final baseStyle = GoogleFonts.antonSc(
      fontSize: 36,
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
              const TextSpan(text: 'SWEET '),
              TextSpan(text: 'FUNDRAISING,', style: highlightStyle),
              const TextSpan(text: '\nMADE SIMPLE.'),
            ],
          ),
        );
      case 1:
        return RichText(
          text: TextSpan(
            style: baseStyle,
            children: [
              const TextSpan(text: 'KEEP '),
              TextSpan(text: '50% OF SALES.', style: highlightStyle),
              const TextSpan(text: '\nNO UPFRONT COSTS.'),
              const TextSpan(text: '\nNO HASSLE.'),
              const TextSpan(text: '\nJUST SWEETNESS.'),
            ],
          ),
        );
      case 2:
      default:
        return RichText(
          text: TextSpan(
            style: baseStyle,
            children: [
              const TextSpan(text: 'DELIVERED STRAIGHT TO\nYOUR '),
              TextSpan(text: "SUPPORTERS'\nDOORS.", style: highlightStyle),
            ],
          ),
        );
    }
  }
}
