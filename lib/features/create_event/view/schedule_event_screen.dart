import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controller/schedule_event_controller.dart';
import 'date_time_screen.dart';
import 'event_overview_screen.dart';
import 'team_name_screen.dart';

class ScheduleEventScreen extends StatelessWidget {
  const ScheduleEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScheduleEventController());

    return Scaffold(
      backgroundColor: const Color(
        0xFFF6F6F9,
      ), // Match grey background in screenshot
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back Button ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 24.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Back',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ── Title & Subtitle ─────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text(
                      'SCHEDULE A\nFUNDRAISING EVENT',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.antonSc(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF1A1A2E),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'FUNDRAISING WINDOW',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF525252),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // ── Fundraising Window Card ──────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Duration Row
                      GestureDetector(
                        onTap: () {},
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Duration',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black38,
                              ),
                            ),
                            Row(
                              children: [
                                // Radio button outline
                                Container(
                                  width: 22.sp,
                                  height: 22.sp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF1D1D2C),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 12.sp,
                                      height: 12.sp,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF1D1D2C),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Obx(
                                  () => Text(
                                    '${controller.durationDays.value} days',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1D1D2C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Divider(
                          color: Color(0xFFEEEEF2),
                          height: 1,
                        ),
                      ),

                      // Starts Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Starts',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black38,
                            ),
                          ),
                          Row(
                            children: [
                              // Date Pill
                              GestureDetector(
                                onTap: () =>
                                    _openDateTimeSelector(context, controller),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F1F5),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Obx(
                                    () => Text(
                                      controller.formattedStartDate,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1D1D2C),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              // Time Pill
                              GestureDetector(
                                onTap: () =>
                                    _openDateTimeSelector(context, controller),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F1F5),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Obx(
                                    () => Text(
                                      controller.formattedStartTime,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.sp,
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
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Divider(
                          color: Color(0xFFEEEEF2),
                          height: 1,
                        ),
                      ),

                      // Ends Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ends',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
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
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black38,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Text(
                                  controller.formattedEndTime,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
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
              ),

              SizedBox(height: 16.h),

              // ── Organization Button ──────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              'Organizer Name',
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1D1D2C),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Obx(
                              () => Text(
                                controller.organizerName.value.isEmpty
                                    ? 'Name of Organizer'
                                    : controller.organizerName.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // ── Team Details Button ──────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
                  onTap: () => _editTeamDetails(context, controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Organization Details',
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1D1D2C),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Obx(
                                () => Text(
                                  controller.teamName.value.isEmpty
                                      ? 'Enter your team name and location'
                                      : '${controller.teamName.value} - ${controller.teamLocation.value}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16.sp,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),
              // ── Organization Button ──────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
                  onTap: () => _editOrganization(context, controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Organizer Type',
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1D1D2C),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Type of Organization',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16.sp,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // ── Terms and Conditions ─────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: controller.toggleTerms,
                      child: Obx(
                        () => Container(
                          width: 22.sp,
                          height: 22.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: controller.agreeToTerms.value
                                  ? AppColors.primary
                                  : Colors.black38,
                              width: 1.5,
                            ),
                            color: controller.agreeToTerms.value
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          child: controller.agreeToTerms.value
                              ? Icon(
                                  Icons.check,
                                  size: 14.sp,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terms and Conditions *',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1D1D2C),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'By signing up, you agree to our Terms and Conditions and Privacy Policy.',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.black45,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // ── Schedule Event Button ────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(
                  () => PrimaryButton(
                    text: controller.isLoading.value
                        ? 'Scheduling...'
                        : 'Schedul Event',
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final success = await controller.scheduleEvent();
                            if (success) {
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
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Sheets & Dialogs ────────────────────────────────────────

  void _showDurationSelector(
    BuildContext context,
    ScheduleEventController controller,
  ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Event Duration',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D1D2C),
              ),
            ),
            SizedBox(height: 16.h),
            ...[3, 5, 7, 10, 14, 30].map(
              (days) => ListTile(
                title: Text('$days days'),
                trailing: Obx(
                  () => controller.durationDays.value == days
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : const Icon(Icons.circle_outlined),
                ),
                onTap: () {
                  controller.setDuration(days);
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDateTimeSelector(
    BuildContext context,
    ScheduleEventController controller,
  ) async {
    final DateTime? selected = await Get.to<DateTime>(
      () => DateTimeScreen(
        initialDateTime: controller.startDate.value,
        durationDays: controller.durationDays.value,
      ),
    );

    if (selected != null) {
      controller.startDate.value = selected;
    }
  }

  void _editOrganization(
    BuildContext context,
    ScheduleEventController controller,
  ) {
    final List<String> categories = controller.categories.toList();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: const Color(0xFF1D1D2C),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Organization Type',
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1D2C),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              categories.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(
                        child: Text(
                          'No categories found',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : Obx(
                      () => Wrap(
                        spacing: 10.w,
                        runSpacing: 12.h,
                        children: categories.map((category) {
                          final isSelected =
                              controller.organization.value == category;
                          return GestureDetector(
                            onTap: () {
                              controller.organization.value = category;
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFFF1F1F5),
                                borderRadius: BorderRadius.circular(25.r),
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              child: Text(
                                category,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF1D1D2C)
                                      : const Color(0xFF525252),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  void _editTeamDetails(
    BuildContext context,
    ScheduleEventController controller,
  ) {
    Get.to(() => TeamNameScreen(controller: controller));
  }
}
