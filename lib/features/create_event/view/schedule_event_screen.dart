import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controller/schedule_event_controller.dart';
import 'date_time_screen.dart';
import 'team_name_screen.dart';
import 'sheets/confirm_event_dialog.dart';
import 'sheets/organization_type_dialog.dart';
import 'widgets/schedule_detail_tile.dart';
import 'widgets/schedule_terms_checkbox.dart';
import 'widgets/schedule_window_card.dart';

class ScheduleEventScreen extends StatelessWidget {
  const ScheduleEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScheduleEventController());
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
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
                  ScheduleWindowCard(
                    controller: controller,
                    onPickDateTime: () =>
                        _openDateTimeSelector(context, controller),
                  ),

                  SizedBox(height: isTablet ? 16.0 : 16.h),

                  // ── Organizer Name Tile ──────────────────────────────────
                  Obx(
                    () => ScheduleDetailTile(
                      title: 'Organizer Name',
                      value: controller.organizerName.value,
                      placeholder: 'Name of Organizer',
                    ),
                  ),

                  SizedBox(height: isTablet ? 12.0 : 12.h),

                  // ── Team Details Tile ────────────────────────────────────
                  Obx(
                    () => ScheduleDetailTile(
                      title: 'Organization Name',
                      value: controller.teamName.value.isEmpty
                          ? ''
                          : '${controller.teamName.value} - ${controller.teamLocation.value}',
                      placeholder: 'Enter your team name and location',
                      showArrow: true,
                      onTap: () => _editTeamDetails(context, controller),
                    ),
                  ),

                  SizedBox(height: isTablet ? 12.0 : 12.h),

                  // ── Organization Type Tile ───────────────────────────────
                  Obx(
                    () => ScheduleDetailTile(
                      title: 'Organizer Type',
                      value: controller.organization.value,
                      placeholder: 'Type of Organization',
                      showArrow: true,
                      onTap: () => _editOrganization(context, controller),
                    ),
                  ),

                  SizedBox(height: isTablet ? 12.0 : 12.h),

                  // ── Terms and Conditions ─────────────────────────────────
                  ScheduleTermsCheckbox(
                    agreeToTerms: controller.agreeToTerms,
                    onToggle: controller.toggleTerms,
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
                            : () => _onSchedulePressed(context, controller),
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

  // ── Actions & Dialog Triggers ──────────────────────────────────────

  void _onSchedulePressed(
    BuildContext context,
    ScheduleEventController controller,
  ) {
    if (!controller.agreeToTerms.value) {
      Get.snackbar(
        'Required',
        'Please agree to the Terms and Conditions to schedule the event.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (controller.organization.value.isEmpty ||
        controller.organization.value == 'Select an Organization Type') {
      Get.snackbar(
        'Required',
        'Please select an Organization Type to schedule the event.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(26),
        colorText: Colors.red,
      );
      return;
    }
    ConfirmEventDialog.show(context, controller);
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
    OrganizationTypeDialog.show(context, controller);
  }

  void _editTeamDetails(
    BuildContext context,
    ScheduleEventController controller,
  ) {
    Get.to(() => TeamNameScreen(controller: controller));
  }
}
