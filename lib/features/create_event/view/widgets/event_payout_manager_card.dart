import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../otp/view/verification_required_screen.dart';
import '../../controller/schedule_event_controller.dart';
import 'overview_card.dart';

class EventPayoutManagerCard extends StatelessWidget {
  final ScheduleEventController controller;

  const EventPayoutManagerCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Obx(() {
      final Map<String, dynamic> rawMap = controller.createdEvent;
      final Map<String, dynamic>? eventData = rawMap['event'] is Map
          ? rawMap['event'] as Map<String, dynamic>
          : null;
      final String? payoutNumber =
          eventData?['payout_manager']?.toString() ??
          rawMap['payout_manager']?.toString();
      final bool hasPayoutNumber =
          payoutNumber != null &&
          payoutNumber.trim().isNotEmpty &&
          payoutNumber != 'null';

      return OverviewCard(
        title: 'Payout Manager',
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 10.0 : 10.w,
            vertical: isTablet ? 4.0 : 4.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F5),
            borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
          ),
          child: Text(
            'Secure & Simple',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 10.0 : 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasPayoutNumber) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payout Manager Number',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 11.0 : 11.sp,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        payoutNumber,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 15.0 : 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(() => const VerificationRequiredScreen());
                    },
                    icon: Icon(
                      Icons.edit,
                      color: const Color(0xFFFE53A1),
                      size: isTablet ? 18.0 : 18.sp,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Verify yourself and select how to receive\n'
                'the event earnings.',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.sp,
                  color: Colors.black45,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const VerificationRequiredScreen());
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Get started',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 14.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
