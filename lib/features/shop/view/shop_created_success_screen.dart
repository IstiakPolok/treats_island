import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../create_event/controller/schedule_event_controller.dart';
import '../../create_event/view/event_overview_screen.dart';
import '../controller/stripe_connect_controller.dart';

class ShopCreatedSuccessScreen extends StatefulWidget {
  final ScheduleEventController scheduleController;

  const ShopCreatedSuccessScreen({super.key, required this.scheduleController});

  @override
  State<ShopCreatedSuccessScreen> createState() =>
      _ShopCreatedSuccessScreenState();
}

class _ShopCreatedSuccessScreenState extends State<ShopCreatedSuccessScreen> {
  late final ConfettiController _confettiController;
  final StripeConnectController _stripeController =
      Get.isRegistered<StripeConnectController>()
      ? Get.find<StripeConnectController>()
      : Get.put(StripeConnectController());

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
      _stripeController.fetchConnectStatus();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _getShareLink() {
    final fundraiser = widget.scheduleController.fundraiserDetails;
    final String? link = fundraiser['share_link']?.toString();
    if (link != null && link.isNotEmpty && link != 'null') {
      return link;
    }
    final id =
        fundraiser['id'] ??
        widget.scheduleController.createdEvent['event']?['id'] ??
        widget.scheduleController.createdEvent['id'];
    if (id != null) {
      return 'https://treatsislandgo.com/shop/$id';
    }
    return 'https://treatsislandgo.com';
  }

  void _goToDashboard() {
    Get.off(
      () => EventOverviewScreen(
        controller: widget.scheduleController,
        showShopTab: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final String shareLink = _getShareLink();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 580.0 : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32.0 : 24.w,
                    vertical: isTablet ? 24.0 : 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: isTablet ? 20.0 : 20.h),

                      // Celebration icon
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEAF4),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFF6FB6,
                              ).withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '🎉',
                            style: TextStyle(fontSize: isTablet ? 40.0 : 38.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 18.0 : 18.h),

                      Text(
                        'Woohoo!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.antonSc(
                          fontSize: isTablet ? 32.0 : 32.sp,
                          color: const Color(0xFF1A1A2E),
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Your Popup Store is Live!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 18.0 : 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF6FB6),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Customers can start buying candy and supporting your cause right now.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13.0 : 13.sp,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // Share Link Box
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isTablet ? 18.0 : 16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FA),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: const Color(0xFFE8E8EE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.link_rounded,
                                  size: 18.sp,
                                  color: const Color(0xFF1A1A2E),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Share Link',
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 12.0 : 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            SelectableText(
                              shareLink,
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 14.0 : 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(text: shareLink),
                                      );
                                      Get.snackbar(
                                        'Copied',
                                        'Store link copied to clipboard!',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.black
                                            .withValues(alpha: 0.8),
                                        colorText: Colors.white,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.copy_rounded,
                                      size: 16.sp,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                    label: Text(
                                      'Copy Link',
                                      style: GoogleFonts.poppins(
                                        fontSize: isTablet ? 13.0 : 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1A1A2E),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Color(0xFFD4D4DF),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          24.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      SharePlus.instance.share(
                                        ShareParams(
                                          text:
                                              'Check out my Pop-Up Store on Treats Island!\n$shareLink',
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.share_rounded,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Share',
                                      style: GoogleFonts.poppins(
                                        fontSize: isTablet ? 13.0 : 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1A1A2E),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          24.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),
                      Divider(color: const Color(0xFFEEEEF4), thickness: 1.2),
                      SizedBox(height: 20.h),

                      // // Stripe Connect Soft Onboarding Card
                      // Container(
                      //   width: double.infinity,
                      //   padding: EdgeInsets.all(isTablet ? 20.0 : 18.w),
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFFAF7FD),
                      //     borderRadius: BorderRadius.circular(22.r),
                      //     border: Border.all(
                      //       color: const Color(0xFFE2D6F5),
                      //       width: 1.2,
                      //     ),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Text(
                      //             '💰',
                      //             style: TextStyle(
                      //               fontSize: isTablet ? 22.0 : 22.sp,
                      //             ),
                      //           ),
                      //           SizedBox(width: 10.w),
                      //           Expanded(
                      //             child: Text(
                      //               'Set Up Your 50% Profit Payouts',
                      //               style: GoogleFonts.poppins(
                      //                 fontSize: isTablet ? 15.0 : 15.sp,
                      //                 fontWeight: FontWeight.w700,
                      //                 color: const Color(0xFF1A1A2E),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(height: 10.h),
                      //       Text(
                      //         'Connect your bank account or debit card with Stripe to receive direct deposits.',
                      //         style: GoogleFonts.poppins(
                      //           fontSize: isTablet ? 13.0 : 13.sp,
                      //           color: Colors.black87,
                      //           height: 1.4,
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.h),
                      //       Text(
                      //         'No rush! Your sales earnings are safely held until you connect.',
                      //         style: GoogleFonts.poppins(
                      //           fontSize: isTablet ? 11.5 : 11.5.sp,
                      //           color: Colors.black54,
                      //         ),
                      //       ),
                      //       SizedBox(height: 20.h),

                      //       // Connect Button
                      //       Obx(
                      //         () => SizedBox(
                      //           width: double.infinity,
                      //           height: isTablet ? 50.0 : 50.h,
                      //           child: ElevatedButton(
                      //             onPressed: _stripeController
                      //                     .isOnboardingLoading.value
                      //                 ? null
                      //                 : () async {
                      //                     final success = await _stripeController
                      //                         .startOnboarding();
                      //                     if (success) {
                      //                       _goToDashboard();
                      //                     }
                      //                   },
                      //             style: ElevatedButton.styleFrom(
                      //               backgroundColor: const Color(0xFFFF6FB6),
                      //               elevation: 0,
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(30.r),
                      //               ),
                      //             ),
                      //             child: _stripeController
                      //                     .isOnboardingLoading.value
                      //                 ? const CircularProgressIndicator(
                      //                     color: Colors.white,
                      //                   )
                      //                 : Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.center,
                      //                     children: [
                      //                       Icon(
                      //                         Icons.account_balance_rounded,
                      //                         color: Colors.white,
                      //                         size: 18.sp,
                      //                       ),
                      //                       SizedBox(width: 8.w),
                      //                       Text(
                      //                         'Connect Bank Account (Stripe)',
                      //                         style: GoogleFonts.poppins(
                      //                           fontSize: isTablet ? 14.0 : 14.sp,
                      //                           fontWeight: FontWeight.w600,
                      //                           color: Colors.white,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // SizedBox(height: 20.h),

                      // Non-blocking button
                      TextButton(
                        onPressed: _goToDashboard,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: Text(
                          "I'll do this later",
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFFFF6FB6),
                Color(0xFF635BFF),
                Colors.amber,
                Colors.lightGreen,
                Colors.cyan,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
