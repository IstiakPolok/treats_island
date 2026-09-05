import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bottom_navbar.dart';
import '../../controller/schedule_event_controller.dart';
import 'event_countdown_widget.dart';

class EventOverviewHeader extends StatelessWidget {
  final ScheduleEventController controller;
  final bool isShopSelected;
  final ValueChanged<bool> onTabSelected;
  final VoidCallback onEditTap;
  final VoidCallback onChecklistTap;
  final VoidCallback onRefresh;

  const EventOverviewHeader({
    super.key,
    required this.controller,
    required this.isShopSelected,
    required this.onTabSelected,
    required this.onEditTap,
    required this.onChecklistTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Container(
      width: double.infinity,
      padding: isTablet
          ? const EdgeInsets.fromLTRB(32.0, 56.0, 32.0, 18.0)
          : EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 18.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E2FF),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(isTablet ? 26.0 : 26.r),
        ),
      ),
      child: Column(
        children: [
          // Top App Bar Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Get.offAll(() => MainNavigationScreen()),
                icon: const Icon(Icons.close),
              ),
              Expanded(
                child: Center(
                  child: Obx(() {
                    final Map<String, dynamic>? eventData =
                        controller.createdEvent['event']
                            as Map<String, dynamic>?;
                    final String status =
                        eventData?['status']?.toString() ?? '';
                    final bool isOngoing = status.toLowerCase() == 'ongoing';

                    if (isOngoing) {
                      final parsedStart = eventData?['start_date'] != null
                          ? DateTime.tryParse(
                              eventData!['start_date'].toString(),
                            )
                          : null;
                      final durationDays = eventData?['duration'] != null
                          ? (int.tryParse(
                                  eventData!['duration'].toString(),
                                ) ??
                                5)
                          : 5;
                      return EventCountdownWidget(
                        startDate: parsedStart ?? DateTime.now(),
                        durationDays: parsedStart != null ? durationDays : 0,
                      );
                    }

                    return Text(
                      isShopSelected ? 'Shop' : 'Event',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18.0 : 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    );
                  }),
                ),
              ),
              Obx(() {
                final Map<String, dynamic>? eventData =
                    controller.createdEvent['event']
                        as Map<String, dynamic>?;
                final String status =
                    eventData?['status']?.toString() ?? '';
                final bool isUpcoming = status.toLowerCase() == 'upcoming';
                final bool isOngoing = status.toLowerCase() == 'ongoing';

                return Theme(
                  data: Theme.of(context).copyWith(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xFF1A1A2E),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    color: Colors.white,
                    elevation: 4,
                    offset: const Offset(0, 40),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        onEditTap();
                      } else if (value == 'start') {
                        final eData = controller.createdEvent['event']
                            as Map<String, dynamic>?;
                        final int? eventId =
                            eData?['id'] as int? ??
                            controller.createdEvent['id'] as int?;
                        if (eventId != null) {
                          final nowUtcStr = DateTime.now()
                              .toUtc()
                              .toIso8601String()
                              .replaceAll(RegExp(r'\.\d+'), '');
                          final success = await controller.updateEvent(
                            eventId: eventId,
                            startDateIso: nowUtcStr,
                          );
                          if (success) {
                            await controller.fetchMyEvents();
                            onRefresh();
                          }
                        }
                      } else if (value == 'extend') {
                        final eData = controller.createdEvent['event']
                            as Map<String, dynamic>?;
                        final int? eventId =
                            eData?['id'] as int? ??
                            controller.createdEvent['id'] as int?;
                        if (eventId != null) {
                          final success = await controller.extendEvent(
                            eventId: eventId,
                          );
                          if (success) {
                            await controller.fetchMyEvents();
                            onRefresh();
                          }
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            enabled: !isOngoing,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: isOngoing
                                      ? Colors.grey
                                      : const Color(0xFFFE53A1),
                                  size: 18.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'Edit Event',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 14.0 : 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isOngoing
                                          ? Colors.grey
                                          : const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'start',
                            enabled: !isOngoing,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flash_on,
                                  color: isOngoing
                                      ? Colors.grey
                                      : const Color(0xFFFE53A1),
                                  size: 18.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'Start Event Now',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 14.0 : 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isOngoing
                                          ? Colors.grey
                                          : const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'extend',
                            enabled: !isUpcoming,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  color: isUpcoming
                                      ? Colors.grey
                                      : const Color(0xFFFE53A1),
                                  size: 18.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'Extend 3 Days More',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 14.0 : 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isUpcoming
                                          ? Colors.grey
                                          : const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 6.h),
          // Organizer and Event Title Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() {
                  final Map<String, dynamic>? eventData =
                      controller.createdEvent['event']
                          as Map<String, dynamic>?;

                  DateTime? startDateTime;
                  DateTime? endDateTime;
                  if (eventData?['start_date'] != null) {
                    startDateTime = DateTime.tryParse(
                      eventData!['start_date'].toString(),
                    )?.toLocal();
                  }
                  if (eventData?['end_date'] != null) {
                    endDateTime = DateTime.tryParse(
                      eventData!['end_date'].toString(),
                    )?.toLocal();
                  }

                  final String dynamicTeamName =
                      eventData?['name']?.toString() ?? 'No Name added';
                  final String dateRangeStr =
                      (startDateTime != null && endDateTime != null)
                          ? '${DateFormat('MMM d').format(startDateTime)} - ${DateFormat('MMM d').format(endDateTime)}'
                          : 'No Date Added';

                  final creatorMap =
                      eventData?['creator'] as Map<String, dynamic>?;
                  final String creatorName =
                      creatorMap?['full_name']?.toString() ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creatorName.isNotEmpty
                            ? '$creatorName  '
                            : 'Organizer',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          color: Colors.black45,
                        ),
                      ),
                      SizedBox(height: isTablet ? 2.0 : 2.h),
                      Text(
                        dynamicTeamName,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 16.0 : 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: isTablet ? 2.0 : 2.h),
                      Text(
                        dateRangeStr,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              InkWell(
                onTap: onChecklistTap,
                borderRadius: BorderRadius.circular(
                  isTablet ? 18.0 : 18.r,
                ),
                child: CircleAvatar(
                  radius: isTablet ? 18.0 : 18.r,
                  backgroundColor: Colors.black,
                  child: Stack(
                    children: [
                      Center(
                        child: Image(
                          image: const AssetImage(
                            'assets/icons/checklist.png',
                          ),
                          width: isTablet ? 20.0 : 20.w,
                          height: isTablet ? 20.0 : 20.w,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: isTablet ? 10.0 : 10.w,
                          height: isTablet ? 10.0 : 10.w,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16.0 : 16.h),
          // Segmented Tab Selector
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onTabSelected(false),
                    borderRadius: BorderRadius.circular(24.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isShopSelected
                            ? Colors.white
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          isTablet ? 24.0 : 24.r,
                        ),
                        border: Border.all(
                          color: isShopSelected
                              ? Colors.black12
                              : Colors.transparent,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: isTablet ? 14.0 : 14.sp,
                              color: isShopSelected
                                  ? Colors.black45
                                  : Colors.white,
                            ),
                            SizedBox(width: isTablet ? 6.0 : 6.w),
                            Text(
                              'Event',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 13.0 : 13.sp,
                                fontWeight: FontWeight.w600,
                                color: isShopSelected
                                    ? Colors.black45
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 8.0 : 8.w),
                Expanded(
                  child: InkWell(
                    onTap: () => onTabSelected(true),
                    borderRadius: BorderRadius.circular(
                      isTablet ? 24.0 : 24.r,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 12.0 : 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isShopSelected
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(
                          isTablet ? 24.0 : 24.r,
                        ),
                        border: Border.all(
                          color: isShopSelected
                              ? Colors.transparent
                              : Colors.black12,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.storefront_outlined,
                              size: isTablet ? 14.0 : 14.sp,
                              color: isShopSelected
                                  ? Colors.white
                                  : Colors.black45,
                            ),
                            SizedBox(width: isTablet ? 6.0 : 6.w),
                            Obx(() {
                              final String? shopName = controller
                                  .fundraiserDetails['name']
                                  ?.toString();
                              final bool hasName = shopName != null &&
                                  shopName.trim().isNotEmpty &&
                                  shopName != 'null';
                              return Text(
                                hasName
                                    ? 'Pop-UP Store'
                                    : 'Create Pop-UP Store',
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 13.0 : 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isShopSelected
                                      ? Colors.white
                                      : Colors.black45,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
