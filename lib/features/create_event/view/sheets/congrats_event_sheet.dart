import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/schedule_event_controller.dart';
import '../widgets/overview_info_items.dart';

class CongratsEventSheet {
  static void show({
    required BuildContext context,
    required ScheduleEventController controller,
    required String organizerName,
    required ConfettiController confettiController,
    required VoidCallback onViewChecklist,
  }) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        controller.createdEvent['event'] as Map<String, dynamic>?;

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

    final String eventCode = eventData?['code']?.toString() ?? 'ZVT AYF';
    final String displayStartDate = startDateTime != null
        ? DateFormat('EEEE, MMMM dd, yyyy').format(startDateTime)
        : 'Monday, May 22, 2026';
    final String displayStartTime = startDateTime != null
        ? DateFormat('h:mm a').format(startDateTime)
        : '5.00 pm';
    final String displayEndDate = endDateTime != null
        ? DateFormat('EEEE, MMMM dd, yyyy').format(endDateTime)
        : 'Monday, May 22, 2026';
    final String displayEndTime = endDateTime != null
        ? DateFormat('h:mm a').format(endDateTime)
        : '5.00 pm';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (sheetContext) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 20.h,
                bottom: 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.celebration,
                        color: AppColors.primary,
                        size: 40.sp,
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Congratulations, $organizerName!\nYour Event Is Scheduled',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 20.0 : 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Share the event details with your team and complete\n'
                    'the checklist before your fund raise.',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 11.0 : 11.sp,
                      color: const Color(0xff525252),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 26.h),
                  DetailsRow(
                    label: 'EVENT CODE',
                    value: eventCode,
                    trailing: Icon(
                      Icons.copy_rounded,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 13.h),
                  const DashedDivider(color: Color.fromARGB(172, 0, 0, 0)),
                  SizedBox(height: 13.h),
                  Row(
                    children: [
                      Expanded(
                        child: InfoMini(
                          title: 'START DATE',
                          value: displayStartDate,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: InfoMini(
                          title: 'START TIME',
                          value: displayStartTime,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: InfoMini(
                          title: 'END DATE',
                          value: displayEndDate,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: InfoMini(
                          title: 'END TIME',
                          value: displayEndTime,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        onViewChecklist();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/checklist.png',
                            width: 16.sp,
                            height: 16.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'View checklist',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 16.0 : 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Color(0xFFFF6FB6),
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
