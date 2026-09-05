import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../create_event/controller/schedule_event_controller.dart';
import '../../create_event/view/event_overview_screen.dart';
import '../../otp/view/event_code_screen.dart';
import '../controller/home_controller.dart';
import 'widgets/home_event_status_card.dart';
import 'widgets/home_fundraising_goal_card.dart';
import 'widgets/home_header.dart';
import 'widgets/home_mini_video_card.dart';
import 'widgets/home_pink_action_card.dart';
import 'widgets/home_start_fundraiser_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 650.0 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24.0 : 24.w,
                vertical: isTablet ? 16.0 : 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header (Greeting, User Name, Live Time, Logo) ───────────
                  Obx(
                    () => HomeHeader(
                      userName: controller.userName.value,
                      currentDateString: controller.currentDateString.value,
                      currentTimeString: controller.currentTimeString.value,
                    ),
                  ),

                  SizedBox(height: isTablet ? 24.0 : 24.h),

                  // ── MY EVENT Section Title ─────────────────────────────────
                  Text(
                    'MY EVENT',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 16.0 : 18.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF262626),
                    ),
                  ),

                  SizedBox(height: isTablet ? 10.0 : 10.h),

                  // ── Event Status Card OR Start Fundraiser Card ─────────────
                  Obx(() {
                    if (controller.showCreated) {
                      return HomeEventStatusCard(
                        eventData: controller.eventData.value,
                        started: controller.started.value,
                        onTap: () {
                          final scheduleController =
                              Get.isRegistered<ScheduleEventController>()
                              ? Get.find<ScheduleEventController>()
                              : Get.put(ScheduleEventController());
                          Get.to(
                            () => EventOverviewScreen(
                              controller: scheduleController,
                              showShopTab: controller.shopCreated.value,
                            ),
                          );
                        },
                      );
                    }
                    return HomeStartFundraiserCard(
                      title: 'START A FUNDRAISER',
                      subtitle:
                          'Launch your fundraiser campaign in under 90 seconds',
                      assetPath: 'assets/images/unsplash_lhTF57zrDRs.png',
                      onTap: () => Get.toNamed(AppStrings.launchEventRoute),
                    );
                  }),

                  // ── Ongoing Goal Card ──────────────────────────────────────
                  Obx(() {
                    final eventData = controller.eventData.value;
                    final isOngoing =
                        eventData?['status']?.toString().toLowerCase() ==
                        'ongoing';
                    if (!isOngoing) return const SizedBox.shrink();

                    final remaining = controller.getRemainingTime(
                      eventData?['end_date']?.toString(),
                    );
                    final participant = controller.getMyParticipant();
                    final name =
                        participant?['full_name']?.toString() ??
                        controller.userName.value;
                    final double goal =
                        double.tryParse(
                          participant?['shop_goal']?.toString() ?? '',
                        ) ??
                        0.0;
                    final double achieved =
                        double.tryParse(
                          participant?['shop_achieved']?.toString() ?? '',
                        ) ??
                        0.0;

                    return Padding(
                      padding: EdgeInsets.only(top: isTablet ? 16.0 : 16.h),
                      child: HomeFundraisingGoalCard(
                        remainingTime: remaining,
                        displayName: name,
                        goal: goal,
                        achieved: achieved,
                      ),
                    );
                  }),

                  // ── Enter Event Code Card (If No Event Created) ────────────
                  Obx(() {
                    if (controller.showCreated) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.only(top: isTablet ? 16.0 : 16.h),
                      child: HomePinkActionCard(
                        title: 'ENTER EVENT CODE',
                        onTap: () => Get.to(() => const EventCodeScreen()),
                      ),
                    );
                  }),

                  SizedBox(height: isTablet ? 24.0 : 24.h),

                  // ── GET STARTED IN MINUTES Section ─────────────────────────
                  Text(
                    'GET STARTED IN MINUTES',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 13.0 : 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),

                  SizedBox(height: isTablet ? 12.0 : 12.h),

                  // ── Video Carousel ─────────────────────────────────────────
                  SizedBox(
                    height: isTablet ? 210.0 : 210.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const HomeMiniVideoCard(
                          title: 'Launch Your\nPop-Up Store',
                          subtitle:
                              'Set up your personalized candy\nstorefront in just a few taps.',
                          duration: '1:23',
                          assetPath:
                              'assets/placeholder/homescreengetstarted1.png',
                        ),
                        SizedBox(width: isTablet ? 14.0 : 14.w),
                        const HomeMiniVideoCard(
                          title: 'Share Your Store',
                          subtitle:
                              'Send your unique fund link\nthrough text, email, or social.',
                          duration: '0:58',
                          assetPath:
                              'assets/placeholder/homescreengetstarted2.png',
                        ),
                        SizedBox(width: isTablet ? 14.0 : 14.w),
                        const HomeMiniVideoCard(
                          title: 'Share Your Store',
                          subtitle:
                              'Send your unique fund link\nthrough text, email, or social.',
                          duration: '0:58',
                          assetPath:
                              'assets/placeholder/homescreengetstarted3.png',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 40.0 : 70.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
