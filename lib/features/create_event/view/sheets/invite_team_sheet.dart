import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/schedule_event_controller.dart';
import '../../utils/share_helper.dart';

class InviteTeamSheet {
  static void show(BuildContext context, ScheduleEventController controller) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        controller.createdEvent['event'] as Map<String, dynamic>?;

    final code =
        eventData?['code'] ?? controller.createdEvent['code'] ?? '';

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

    final String startD = startDateTime != null
        ? DateFormat('MM/dd/yy').format(startDateTime)
        : '___/___/26';
    final String startT = startDateTime != null
        ? DateFormat('h:mm a').format(startDateTime).toLowerCase()
        : '9:00 am';
    final String endD = endDateTime != null
        ? DateFormat('MM/dd/yy').format(endDateTime)
        : '___/___/26';
    final String endT = endDateTime != null
        ? DateFormat('h:mm a').format(endDateTime).toLowerCase()
        : '9:00 am';

    final String inviteLink =
        'https://treatsislandcandy.store/join-event?je=$code';

    final String shareText =
        'Hello Team - I set up a virtual fundraiser with Treats Island Candy! It is 100% contactless. We get to keep 50% of total profit and Treat Island Candy will ship the product directly to our buyers. Each of us will create a Pop-Up Store selling this specialized candy! The prices range from \$15 to \$25 per container and you won\'t find these premium products in general stores. Our fundraising window begins on $startD at $startT and goes until $endD, at $endT. Before the fundraiser begins:\n\n'
        'Click on the link $inviteLink to JOIN THE EVENT\n\n'
        'Confirm the Event Code $code.   Download the APP.\n\n'
        'Create your personalized Pop-Up Store';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 16.h,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      icon: const Icon(Icons.close),
                    ),
                    Text(
                      'Invite your team',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 16.0 : 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'INSTRUCTION FOR YOUR TEAM',
                  style: GoogleFonts.antonSc(
                    fontSize: isTablet ? 18.0 : 18.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  constraints: BoxConstraints(maxHeight: 220.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8FB),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFEAEAEE)),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      shareText,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Builder(
                  builder: (btnContext) {
                    return SizedBox(
                      width: double.infinity,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () {
                          final box =
                              btnContext.findRenderObject() as RenderBox?;
                          ShareHelper.shareTextAndImage(
                            shareText,
                            box != null
                                ? (box.localToGlobal(Offset.zero) & box.size)
                                : null,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'Invite your team',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Builder(
                      builder: (iconContext) => GestureDetector(
                        onTap: () {
                          final box =
                              iconContext.findRenderObject() as RenderBox?;
                          ShareHelper.shareTextAndImage(
                            shareText,
                            box != null
                                ? (box.localToGlobal(Offset.zero) & box.size)
                                : null,
                          );
                        },
                        child: Image.asset(
                          'assets/icons/logos_facebook.png',
                          width: 26.sp,
                          height: 26.sp,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (iconContext) => GestureDetector(
                        onTap: () {
                          final box =
                              iconContext.findRenderObject() as RenderBox?;
                          ShareHelper.shareTextAndImage(
                            shareText,
                            box != null
                                ? (box.localToGlobal(Offset.zero) & box.size)
                                : null,
                          );
                        },
                        child: Image.asset(
                          'assets/icons/logos_messenger.png',
                          width: 26.sp,
                          height: 26.sp,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (iconContext) => GestureDetector(
                        onTap: () {
                          final box =
                              iconContext.findRenderObject() as RenderBox?;
                          ShareHelper.shareTextAndImage(
                            shareText,
                            box != null
                                ? (box.localToGlobal(Offset.zero) & box.size)
                                : null,
                          );
                        },
                        child: Image.asset(
                          'assets/icons/logos_whatsapp-icon.png',
                          width: 26.sp,
                          height: 26.sp,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (iconContext) => GestureDetector(
                        onTap: () {
                          final box =
                              iconContext.findRenderObject() as RenderBox?;
                          ShareHelper.shareTextAndImage(
                            shareText,
                            box != null
                                ? (box.localToGlobal(Offset.zero) & box.size)
                                : null,
                          );
                        },
                        child: Image.asset(
                          'assets/icons/boxicons_message-detail-filled.png',
                          width: 26.sp,
                          height: 26.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
