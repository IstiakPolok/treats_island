import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/primary_button.dart';

/// Welcome screen featuring a full-screen background image,
/// a centered logo, and a reusable pink primary action button.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 600;

    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen background image ───────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboardbg.png',
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
          ),

          // ── Centered Logo ──────────────────────────────────────────
          Center(
            child: Image.asset(
              AppAssets.splashLogo,
              width: isTablet ? 220.0 : 200.w,
              height: isTablet ? 220.0 : 200.h,
              fit: BoxFit.contain,
            ),
          ),

          // ── Bottom Reusable button ─────────────────────────────────
          Positioned(
            bottom: isTablet ? 60.0 : 50.h,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 450.0 : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32.0 : 24.w,
                  ),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'GET STARTED',
                        onPressed: () {
                          Get.toNamed(AppStrings.joinInRoute);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
