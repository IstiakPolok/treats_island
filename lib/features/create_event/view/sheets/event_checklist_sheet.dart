import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../otp/view/verification_required_screen.dart';
import '../../../shop/view/create_pop_up_store_screen.dart';
import '../../controller/schedule_event_controller.dart';
import '../widgets/overview_info_items.dart';

class EventChecklistSheet {
  static void show({
    required BuildContext context,
    required ScheduleEventController controller,
    required String organizerName,
    required VoidCallback onInviteTeamTap,
  }) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        controller.createdEvent['event'] as Map<String, dynamic>?;
    final List participants = eventData?['participants'] as List? ?? [];
    final bool isTeamInvited = participants.length > 1;

    final String? payoutNumber =
        eventData?['payout_manager']?.toString() ??
        controller.createdEvent['payout_manager']?.toString();
    final bool hasPayoutNumber =
        payoutNumber != null &&
        payoutNumber.trim().isNotEmpty &&
        payoutNumber != 'null';

    final String? shopName = controller.fundraiserDetails['name']?.toString();
    final bool hasShop =
        shopName != null && shopName.trim().isNotEmpty && shopName != 'null';

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
            top: 12.h,
            bottom: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Hi, $organizerName',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16.0 : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Lets get your event set up for success.',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.sp,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 18.h),
              const ChecklistRow(
                text: 'Fundraiser event created',
                checked: true,
              ),
              SizedBox(height: 12.h),
              ChecklistRow(
                text: 'Invite your team to fundraise',
                checked: isTeamInvited,
                showArrow: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  onInviteTeamTap();
                },
              ),
              SizedBox(height: 12.h),
              ChecklistRow(
                text: 'Add your payment  method',
                checked: hasPayoutNumber,
                showArrow: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  Get.to(() => const VerificationRequiredScreen());
                },
              ),
              SizedBox(height: 12.h),
              ChecklistRow(
                text: 'Create Organizer Pop-Up Store',
                checked: hasShop,
                showArrow: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  Get.to(() => const CreatePopUpStoreScreen());
                },
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }
}
