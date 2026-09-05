import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../controller/schedule_event_controller.dart';
import 'overview_card.dart';

class EventTeamCard extends StatelessWidget {
  final ScheduleEventController controller;
  final VoidCallback onInviteSellerTap;

  const EventTeamCard({
    super.key,
    required this.controller,
    required this.onInviteSellerTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Obx(() {
      final Map<String, dynamic>? eventData =
          controller.createdEvent['event'] as Map<String, dynamic>?;

      final List participants = eventData?['participants'] as List? ?? [];

      if (participants.isEmpty || participants.length == 1) {
        return OverviewCard(
          title: 'Invite Your Team',
          subtitle: 'Nobody Has Joined Yet',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/eventteaminvite.png',
                  width: 200.w,
                  height: 120.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: 140.w,
                height: 36.h,
                child: ElevatedButton(
                  onPressed: onInviteSellerTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Invite Seller',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 12.0 : 12.sp,
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

      return OverviewCard(
        title: 'Your Team',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: participants.length,
              separatorBuilder: (context, index) => Divider(
                height: 24.h,
                color: Colors.black.withValues(alpha: 0.05),
              ),
              itemBuilder: (context, index) {
                final participant =
                    participants[index] as Map<String, dynamic>;
                final String name =
                    participant['full_name']?.toString() ?? 'No Name';
                final String? imageRelPath = participant['image']?.toString();
                final String imageUrl = ApiService.formatImageUrl(
                  imageRelPath,
                );

                return Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 14.0 : 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 40.w,
                                  height: 40.w,
                                  color: const Color(0xFFF1F1F5),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black26,
                                    size: 20.sp,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 40.w,
                              height: 40.w,
                              color: const Color(0xFFF1F1F5),
                              child: Icon(
                                Icons.person,
                                color: Colors.black26,
                                size: 20.sp,
                              ),
                            ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 14.0 : 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 140.w,
                height: 36.h,
                child: ElevatedButton(
                  onPressed: onInviteSellerTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Invite Seller',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 12.0 : 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
