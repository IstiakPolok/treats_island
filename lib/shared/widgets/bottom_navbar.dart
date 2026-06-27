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
              bottom: 18.h,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140.w),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(164, 211, 211, 211),
                      borderRadius: BorderRadius.circular(50.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10.r,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: GNav(
                      rippleColor: Colors.grey[300]!,
                      hoverColor: Colors.grey[100]!,
                      haptic: true,
                      tabBorderRadius: 50.r,
                      gap: 8.w,
                      color: Colors.white,
                      activeColor: Colors.white,
                      mainAxisAlignment: MainAxisAlignment.center,
                      iconSize: 26.sp,
                      tabBackgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
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
          ],
        ),
      );
    });
  }
}
