import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/api_service.dart';
import '../../controller/schedule_event_controller.dart';
import '../leaderboard_screen.dart';
import '../sheets/leaderboard_shop_details_sheet.dart';

class FundraiseSummaryCard extends StatelessWidget {
  final ScheduleEventController controller;

  const FundraiseSummaryCard({super.key, required this.controller});

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.black.withValues(alpha: 0.05));
  }

  Widget _buildLeaderboardItem(
    BuildContext context,
    int index,
    String name,
    int supporters,
    double amount,
    String avatarUrl, {
    double? goal,
  }) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return GestureDetector(
      onTap: () => LeaderboardShopDetailsSheet.show(
        context,
        name: name,
        amount: amount,
        avatarUrl: avatarUrl,
        supporters: supporters,
        goal: goal,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              child: Text(
                '$index',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 13.0 : 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.network(
                avatarUrl,
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) {
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
                loadingBuilder: (ctx, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 40.w,
                    height: 40.w,
                    color: const Color(0xFFF1F1F5),
                    child: Center(
                      child: SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 13.0 : 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$supporters supporters',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 11.0 : 11.sp,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${amount.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 13.0 : 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        controller.createdEvent['event'] as Map<String, dynamic>?;
    final double totalSale =
        eventData != null && eventData['total_achieved'] != null
            ? double.tryParse(eventData['total_achieved'].toString()) ?? 0.0
            : 0.0;
    final List participants = eventData?['participants'] as List? ?? [];
    final int storeCount = participants.length;

    // Sort participants by shop_achieved in descending order for the leaderboard
    final List sortedParticipants = List.from(participants);
    sortedParticipants.sort((a, b) {
      final double achievedA =
          double.tryParse(a['shop_achieved']?.toString() ?? '0') ?? 0.0;
      final double achievedB =
          double.tryParse(b['shop_achieved']?.toString() ?? '0') ?? 0.0;
      return achievedB.compareTo(achievedA);
    });

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FB),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fundraise Summary',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 15.0 : 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$${totalSale.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 28.0 : 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Total sale',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 12.0 : 12.sp,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBF4),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 14.sp,
                        color: const Color(0xFFFF6FB6),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$storeCount',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF6FB6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Leaderboard',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 15.0 : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => LeaderboardScreen(controller: controller),
                  );
                },
                child: Text(
                  'See more',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 12.0 : 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFF6FB6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (sortedParticipants.length <= 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'No participants yet',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 12.0 : 12.sp,
                    color: Colors.black45,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedParticipants.length > 5
                  ? 5
                  : sortedParticipants.length,
              separatorBuilder: (ctx, index) => _buildDivider(),
              itemBuilder: (ctx, index) {
                final participant =
                    sortedParticipants[index] as Map<String, dynamic>;
                final String participantName =
                    participant['full_name']?.toString() ?? 'Unnamed Seller';
                final String imageSubpath =
                    participant['image']?.toString() ?? '';
                final String avatarUrl = ApiService.formatImageUrl(
                  imageSubpath,
                );
                final double achieved =
                    double.tryParse(
                      participant['shop_achieved']?.toString() ?? '0',
                    ) ??
                    0.0;
                final double goal =
                    double.tryParse(
                      participant['shop_goal']?.toString() ?? '0',
                    ) ??
                    0.0;
                final int supportersCount =
                    int.tryParse(
                      participant['total_supporters']?.toString() ?? '0',
                    ) ??
                    0;
                return _buildLeaderboardItem(
                  context,
                  index + 1,
                  participantName,
                  supportersCount,
                  achieved,
                  avatarUrl,
                  goal: goal,
                );
              },
            ),
        ],
      ),
    );
  }
}
