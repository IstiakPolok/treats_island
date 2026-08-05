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
import '../../profile/view/terms_conditions_screen.dart';

class ScheduleEventScreen extends StatelessWidget {
  const ScheduleEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScheduleEventController());
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(
        0xFFF6F6F9,
      ), // Match grey background in screenshot
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 550.0 : double.infinity,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Back Button ──────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                      vertical: isTablet ? 12.0 : 12.h,
                    ),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: isTablet ? 24.0 : 24.sp,
                            color: const Color(0xFF1A1A2E),
                          ),
                          SizedBox(width: isTablet ? 8.0 : 8.w),
                          Text(
                            'Back',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 16.0 : 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 20.0 : 20.h),

                  // ── Title & Subtitle ─────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'SCHEDULE A\nFUNDRAISING EVENT',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.antonSc(
                            fontSize: isTablet ? 34.0 : 34.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1A1A2E),
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: isTablet ? 12.0 : 12.h),
                        Text(
                          'FUNDRAISING WINDOW',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 16.0 : 16.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF525252),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 24.0 : 24.h),

                  // ── Fundraising Window Card ──────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 20.0 : 20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          isTablet ? 16.0 : 16.r,
                        ),
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
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16.0 : 16.h,
                            ),
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
                                  fontSize: isTablet ? 14.0 : 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black38,
                                ),
                              ),
                              Row(
                                children: [
                                  // Date Pill
                                  GestureDetector(
                                    onTap: () => _openDateTimeSelector(
                                      context,
                                      controller,
                                    ),
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
                                    onTap: () => _openDateTimeSelector(
                                      context,
                                      controller,
                                    ),
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
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16.0 : 16.h,
                            ),
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
                  ),

                  SizedBox(height: isTablet ? 16.0 : 16.h),

                  // ── Organizer Name Button ────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 20.0 : 20.w,
                        vertical: isTablet ? 16.0 : 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          isTablet ? 14.0 : 14.r,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: isTablet ? 10.0 : 10.r,
                            offset: Offset(0, isTablet ? 4.0 : 4.h),
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
                                    fontSize: isTablet ? 15.0 : 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1D1D2C),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 4.0 : 4.h),
                                Obx(
                                  () => Text(
                                    controller.organizerName.value.isEmpty
                                        ? 'Name of Organizer'
                                        : controller.organizerName.value,
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 13.0 : 13.sp,
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

                  SizedBox(height: isTablet ? 12.0 : 12.h),

                  // ── Team Details Button ──────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                    ),
                    child: GestureDetector(
                      onTap: () => _editTeamDetails(context, controller),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20.0 : 20.w,
                          vertical: isTablet ? 16.0 : 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 14.0 : 14.r,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: isTablet ? 10.0 : 10.r,
                              offset: Offset(0, isTablet ? 4.0 : 4.h),
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
                                    'Organization Name',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 15.0 : 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1D1D2C),
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 4.0 : 4.h),
                                  Obx(
                                    () => Text(
                                      controller.teamName.value.isEmpty
                                          ? 'Enter your team name and location'
                                          : '${controller.teamName.value} - ${controller.teamLocation.value}',
                                      style: GoogleFonts.poppins(
                                        fontSize: isTablet ? 13.0 : 13.sp,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: isTablet ? 16.0 : 16.sp,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 12.0 : 12.h),

                  // ── Organization Button ──────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                    ),
                    child: GestureDetector(
                      onTap: () => _editOrganization(context, controller),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20.0 : 20.w,
                          vertical: isTablet ? 16.0 : 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 14.0 : 14.r,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: isTablet ? 10.0 : 10.r,
                              offset: Offset(0, isTablet ? 4.0 : 4.h),
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
                                      fontSize: isTablet ? 15.0 : 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1D1D2C),
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 4.0 : 4.h),
                                  Obx(
                                    () => Text(
                                      controller.organization.value.isEmpty
                                          ? 'Type of Organization'
                                          : controller.organization.value,
                                      style: GoogleFonts.poppins(
                                        fontSize: isTablet ? 13.0 : 13.sp,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: isTablet ? 16.0 : 16.sp,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 12.0 : 12.h),

                  // ── Terms and Conditions ─────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: controller.toggleTerms,
                          child: Obx(
                            () => Container(
                              width: isTablet ? 22.0 : 22.sp,
                              height: isTablet ? 22.0 : 22.sp,
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
                                      size: isTablet ? 14.0 : 14.sp,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: isTablet ? 12.0 : 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                Get.to(() => const TermsConditionsScreen()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Terms and Conditions *',
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 14.0 : 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1D1D2C),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 4.0 : 4.h),
                                Text(
                                  'By signing up, you agree to our Terms and Conditions and Privacy Policy.',
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 12.0 : 12.sp,
                                    color: Colors.black45,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 40.0 : 40.h),

                  // ── Schedule Event Button ────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                    ),
                    child: Obx(
                      () => PrimaryButton(
                        text: controller.isLoading.value
                            ? 'Scheduling...'
                            : 'Schedule Event',
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (!controller.agreeToTerms.value) {
                                  Get.snackbar(
                                    'Required',
                                    'Please agree to the Terms and Conditions to schedule the event.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                if (controller.organization.value.isEmpty ||
                                    controller.organization.value ==
                                        "Select an Organization Type") {
                                  Get.snackbar(
                                    'Required',
                                    'Please select an Organization Type to schedule the event.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.withAlpha(26),
                                    colorText: Colors.red,
                                  );
                                  return;
                                }
                                _showConfirmationDialog(context, controller);
                              },
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 30.0 : 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Helper Sheets & Dialogs ────────────────────────────────────────

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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 40.0 : 16.w,
          vertical: isTablet ? 40.0 : 24.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
        ),
        child: Container(
          width: isTablet ? 450.0 : double.infinity,
          padding: EdgeInsets.all(isTablet ? 24.0 : 24.w),
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
                      size: isTablet ? 24.0 : 24.sp,
                      color: const Color(0xFF1D1D2C),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16.0 : 16.w),
                  Text(
                    'Organization Type',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 20.0 : 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1D2C),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 28.0 : 28.h),

              categories.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 24.0 : 24.h,
                      ),
                      child: Center(
                        child: Text(
                          'No categories found',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : Obx(
                      () => Wrap(
                        spacing: isTablet ? 10.0 : 10.w,
                        runSpacing: isTablet ? 12.0 : 12.h,
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
                                horizontal: isTablet ? 16.0 : 16.w,
                                vertical: isTablet ? 10.0 : 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFFF1F1F5),
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 25.0 : 25.r,
                                ),
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
                                  fontSize: isTablet ? 14.0 : 14.sp,
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
              SizedBox(height: isTablet ? 12.0 : 12.h),
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

  void _showConfirmationDialog(
    BuildContext context,
    ScheduleEventController controller,
  ) {
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
                ),
                _buildInfoRow(
                  context,
                  'Organization Type',
                  controller.organization.value,
                ),
                _buildInfoRow(
                  context,
                  'Organization Name',
                  controller.teamName.value.isEmpty
                      ? 'My Team'
                      : controller.teamName.value,
                ),
                _buildInfoRow(
                  context,
                  'Location',
                  controller.teamLocation.value.isEmpty
                      ? 'Not specified'
                      : controller.teamLocation.value,
                ),
                _buildInfoRow(
                  context,
                  'Duration',
                  '${controller.durationDays.value} Days',
                ),
                _buildInfoRow(
                  context,
                  'Starts',
                  '${controller.formattedStartDate} at ${controller.formattedStartTime}',
                ),
                _buildInfoRow(
                  context,
                  'Ends',
                  '${controller.formattedEndDate} at ${controller.formattedEndTime}',
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

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 14.0 : 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black38,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1D1D2C),
            ),
          ),
        ],
      ),
    );
  }
}
