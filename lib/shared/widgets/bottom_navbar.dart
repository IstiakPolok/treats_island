import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../core/constants/app_colors.dart';
import '../../features/home/controller/bottom_nav_bar_controller.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/profile/view/profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  final int initialIndex;
  MainNavigationScreen({super.key, this.initialIndex = 0});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<Widget> pages = [const HomeScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setInitialIndex(initialIndex);
    });

    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Stack(
          children: [
            pages[controller.currentIndex.value],
            Positioned(
              left: 0,
              right: 0,
              bottom: isTablet ? 24.0 : 18.h,
              child: SafeArea(
                top: false,
                child: Center(
                  child: SizedBox(
                    width: isTablet ? 180.0 : 140.0,
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 6.0 : 6.r),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(164, 211, 211, 211),
                        borderRadius: BorderRadius.circular(
                          isTablet ? 50.0 : 50.r,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: isTablet ? 10.0 : 10.r,
                            offset: Offset(0, isTablet ? 5.0 : 5.h),
                          ),
                        ],
                      ),
                      child: GNav(
                        rippleColor: Colors.grey[300]!,
                        hoverColor: Colors.grey[100]!,
                        haptic: true,
                        tabBorderRadius: isTablet ? 50.0 : 50.r,
                        gap: isTablet ? 24.0 : 24.w,
                        color: Colors.white,
                        activeColor: Colors.white,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        iconSize: isTablet ? 26.0 : 26.sp,
                        tabBackgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 12.0 : 12.w,
                          vertical: isTablet ? 12.0 : 12.h,
                        ),
                        selectedIndex: controller.currentIndex.value,
                        onTabChange: controller.changeIndex,
                        tabs: const [
                          GButton(icon: Icons.home_outlined),
                          GButton(icon: Icons.person_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
