import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../controller/schedule_event_controller.dart';
import '../event_overview_screen.dart';

class ConfirmEventDialog {
  static void show(BuildContext context, ScheduleEventController controller) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 40.0 : 16.w,
          vertical: isTablet ? 24.0 : 24.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
        ),
        child: Container(
          width: isTablet ? 450.0 : double.infinity,
          padding: EdgeInsets.all(isTablet ? 24.0 : 24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Confirm Event Details',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 20.0 : 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D1D2C),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        size: isTablet ? 24.0 : 24.sp,
                        color: const Color(0xFF1D1D2C),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 8.0 : 8.h),
                Text(
                  'Please review your event settings before scheduling.',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: isTablet ? 20.0 : 20.h),
                const Divider(color: Color(0xFFEEEEF2), height: 1),
                SizedBox(height: isTablet ? 16.0 : 16.h),

                // Details List
                _buildInfoRow(
                  context,
                  'Organizer Name',
                  controller.organizerName.value.isEmpty
                      ? 'Not specified'
                      : controller.organizerName.value,
                  isTablet,
                ),
                _buildInfoRow(
                  context,
                  'Organization Type',
                  controller.organization.value,
                  isTablet,
                ),
                _buildInfoRow(
                  context,
                  'Organization Name',
                  controller.teamName.value.isEmpty
                      ? 'My Team'
                      : controller.teamName.value,
                  isTablet,
                ),
                _buildInfoRow(
                  context,
                  'Location',
                  controller.teamLocation.value.isEmpty
                      ? 'Not specified'
                      : controller.teamLocation.value,
                  isTablet,
                ),
                _buildInfoRow(
                  context,
                  'Duration',
                  '${controller.durationDays.value} Days',
                  isTablet,
                ),
                _buildInfoRow(
                  context,
                  'Starts',
                  '${controller.formattedStartDate} at ${controller.formattedStartTime}',
                  isTablet,
                ),
                _buildInfoRow(
                  context,
                  'Ends',
                  '${controller.formattedEndDate} at ${controller.formattedEndTime}',
                  isTablet,
                ),

                SizedBox(height: isTablet ? 12.0 : 12.h),

                // Action Buttons
                Obx(
                  () => PrimaryButton(
                    text: controller.isLoading.value
                        ? 'Scheduling...'
                        : 'Confirm & Schedule',
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final success = await controller.scheduleEvent();
                            if (success) {
                              Get.back(); // close confirmation dialog
                              Get.to(
                                () => EventOverviewScreen(
                                  controller: controller,
                                  showCongratsSheet: true,
                                ),
                              );
                            }
                          },
                  ),
                ),
                SizedBox(height: isTablet ? 8.0 : 8.h),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 12.0 : 12.h,
                      ),
                    ),
                    child: Text(
                      'Cancel & Edit',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 14.0 : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 14.0 : 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 11.0 : 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black38,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: isTablet ? 4.0 : 4.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 14.0 : 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1D1D2C),
            ),
          ),
        ],
      ),
    );
  }
}
