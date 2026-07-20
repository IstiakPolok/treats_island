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

    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen background image ───────────────────────────
          Image.asset(
            AppAssets.welcomeBg,
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          ),

          // ── Centered Logo ──────────────────────────────────────────
          Center(
            child: Image.asset(
              AppAssets.splashLogo,
              width: 200.w,
              height: 200.h,
              fit: BoxFit.contain,
            ),
          ),

          // ── Bottom Reusable button ─────────────────────────────────
          Positioned(
            bottom: 50,
            left: 24,
            right: 24,
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
        ],
      ),
    );
  }
}
