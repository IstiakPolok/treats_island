import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/schedule_event_controller.dart';

class ScheduleWindowCard extends StatelessWidget {
  final ScheduleEventController controller;
  final VoidCallback onPickDateTime;

  const ScheduleWindowCard({
    super.key,
    required this.controller,
    required this.onPickDateTime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.0 : 20.w),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20.0 : 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isTablet ? 16.0 : 16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: isTablet ? 10.0 : 10.r,
              offset: Offset(0, isTablet ? 4.0 : 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            // Duration Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 14.0 : 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                  ),
                ),
                Row(
                  children: [
                    // Radio button outline
                    Container(
                      width: isTablet ? 22.0 : 22.sp,
                      height: isTablet ? 22.0 : 22.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1D1D2C),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: isTablet ? 12.0 : 12.sp,
                          height: isTablet ? 12.0 : 12.sp,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1D1D2C),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 8.0 : 8.w),
                    Obx(
                      () => Text(
                        '${controller.durationDays.value} days',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 14.0 : 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D2C),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: isTablet ? 16.0 : 16.h),
              child: const Divider(color: Color(0xFFEEEEF2), height: 1),
            ),

            // Starts Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Starts',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 14.0 : 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                  ),
                ),
                Row(
                  children: [
                    // Date Pill
                    GestureDetector(
                      onTap: onPickDateTime,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 14.0 : 14.w,
                          vertical: isTablet ? 6.0 : 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F5),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 20.0 : 20.r,
                          ),
                        ),
                        child: Obx(
                          () => Text(
                            controller.formattedStartDate,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 13.0 : 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1D1D2C),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 8.0 : 8.w),
                    // Time Pill
                    GestureDetector(
                      onTap: onPickDateTime,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 14.0 : 14.w,
                          vertical: isTablet ? 6.0 : 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F5),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 20.0 : 20.r,
                          ),
                        ),
                        child: Obx(
                          () => Text(
                            controller.formattedStartTime,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 13.0 : 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1D1D2C),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: isTablet ? 16.0 : 16.h),
              child: const Divider(color: Color(0xFFEEEEF2), height: 1),
            ),

            // Ends Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ends',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 14.0 : 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                  ),
                ),
                Obx(
                  () => Row(
                    children: [
                      Text(
                        controller.formattedEndDate,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13.0 : 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(width: isTablet ? 14.0 : 14.w),
                      Text(
                        controller.formattedEndTime,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13.0 : 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
