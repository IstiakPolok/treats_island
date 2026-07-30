import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/dots_loader_widget.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lazily put the controller; it auto-navigates when ready.
    Get.put(SplashController());

    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final logoSize = isTablet ? 200.0 : 160.r;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.splashLogo,
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),

            SizedBox(height: isTablet ? 40.0 : 40.h),

            // Bouncing dots loader
            const DotsLoaderWidget(),
          ],
        ),
      ),
    );
  }
}
