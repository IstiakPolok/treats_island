import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/schedule_event_controller.dart';

class ShopActionRow extends StatelessWidget {
  final ScheduleEventController controller;
  final Map<String, dynamic>? fundraiser;
  final VoidCallback onShareTap;

  const ShopActionRow({
    super.key,
    required this.controller,
    required this.fundraiser,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final goalVal = fundraiser?['goal'];
    final double? parsedGoal =
        goalVal != null ? double.tryParse(goalVal.toString()) : null;
    final String goalText =
        parsedGoal != null ? '\$${parsedGoal.toInt()}' : '\$0';

    final achievedVal = fundraiser?['achieved'];
    final double? parsedAchieved =
        achievedVal != null ? double.tryParse(achievedVal.toString()) : null;
    final String achievedText =
        parsedAchieved != null ? '\$${parsedAchieved.toInt()}' : '\$0';

    final Map<String, dynamic>? eventData =
        controller.createdEvent['event'] as Map<String, dynamic>?;
    final String status = eventData?['status']?.toString() ?? '';
    final bool isOngoing = status.toLowerCase() == 'ongoing';

    if (isOngoing) {
      final double achVal = parsedAchieved ?? 0.0;
      final double gVal = parsedGoal ?? 1200.0;
      final double progress =
          gVal > 0 ? (achVal / gVal).clamp(0.0, 1.0) : 0.0;

      // Calculate time remaining using start_date and duration
      String timeToGo = 'Ongoing';
      if (eventData?['start_date'] != null && eventData?['duration'] != null) {
        final parsedStart = DateTime.tryParse(
          eventData!['start_date'].toString(),
        );
        final durationDays =
            int.tryParse(eventData['duration'].toString()) ?? 5;
        if (parsedStart != null) {
          final end = parsedStart.add(Duration(days: durationDays));
          final now = DateTime.now();
          final diff = end.difference(now);
          if (diff.isNegative) {
            timeToGo = 'Event ended';
          } else {
            final days = diff.inDays;
            final hours = diff.inHours % 24;
            timeToGo = '$days Day $hours Hours To Go';
          }
        }
      }

      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: -10.h,
              child: Image.asset(
                'assets/images/money.png',
                width: 160.w,
                height: 160.w,
                fit: BoxFit.contain,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Fundraise',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 13.0 : 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          achievedText,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 28.0 : 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF6FB6),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: onShareTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.15),
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Text(
                          'Share Link',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12.h,
                    backgroundColor: const Color(0xFFF1F1F5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF6FB6),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          timeToGo,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 13.0 : 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Goal ',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 13.0 : 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                          TextSpan(
                            text: goalText,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 15.0 : 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fundraising Goal',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                    if (isOngoing)
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Text(
                          'Achieved',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 12.0 : 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goalText,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18.0 : 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    if (isOngoing)
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Text(
                          achievedText,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 18.0 : 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF6FB6),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onShareTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6FB6),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Share Link',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 11.0 : 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
