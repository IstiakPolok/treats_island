import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../controller/schedule_event_controller.dart';
import 'widgets/leaderboard_all_store_item.dart';
import 'widgets/leaderboard_top_rank_card.dart';

class LeaderboardScreen extends StatelessWidget {
  final ScheduleEventController controller;

  const LeaderboardScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SharedPreferencesHelper.getEmail(),
      builder: (context, userEmailSnapshot) {
        final localEmail = userEmailSnapshot.data ?? '';

        final Map<String, dynamic>? eventData =
            controller.createdEvent['event'] as Map<String, dynamic>?;
        final List participants = eventData?['participants'] as List? ?? [];

        // Sort participants by achieved amount descending
        final List sortedParticipants = List.from(participants);
        sortedParticipants.sort((a, b) {
          final double achievedA =
              double.tryParse(a['shop_achieved']?.toString() ?? '0') ?? 0.0;
          final double achievedB =
              double.tryParse(b['shop_achieved']?.toString() ?? '0') ?? 0.0;
          return achievedB.compareTo(achievedA);
        });

        // Extract ME info if present
        final meObj =
            sortedParticipants.firstWhereOrNull((e) {
              final pEmail = e['email']?.toString() ?? '';
              return pEmail.isNotEmpty &&
                  pEmail.toLowerCase() == localEmail.toLowerCase();
            }) ??
            sortedParticipants.firstWhereOrNull(
              (e) => e['is_mine'] == true || e['is_creator'] == true,
            );

        final int meRank = meObj != null
            ? sortedParticipants.indexOf(meObj) + 1
            : 1;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Custom Header Row
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back,
                          size: 24.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Leader Board',
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.info_outline,
                          size: 24.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content List
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    children: [
                      if (sortedParticipants.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.h),
                          child: Center(
                            child: Text(
                              'No participants registered yet',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        // Top 3 Leader Cards
                        for (int i = 0; i < sortedParticipants.length && i < 3; i++)
                          LeaderboardTopRankCard(
                            rank: i + 1,
                            name: sortedParticipants[i]['full_name']?.toString() ?? 'Unnamed',
                            amount: double.tryParse(sortedParticipants[i]['shop_achieved']?.toString() ?? '0') ?? 0.0,
                            avatarUrl: ApiService.formatImageUrl(sortedParticipants[i]['image']?.toString()),
                            supporters: int.tryParse(sortedParticipants[i]['total_supporters']?.toString() ?? '0') ?? 0,
                            goal: double.tryParse(sortedParticipants[i]['shop_goal']?.toString() ?? '0'),
                          ),

                        // Visual Break Dots
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCDCE0),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ME Card
                        LeaderboardTopRankCard(
                          rank: meObj != null ? meRank : 1,
                          name: meObj != null ? (meObj['full_name']?.toString() ?? 'ME') : 'ME',
                          amount: meObj != null ? (double.tryParse(meObj['shop_achieved']?.toString() ?? '0') ?? 0.0) : 0.0,
                          avatarUrl: (meObj != null && meObj['image'] != null && meObj['image'].toString().isNotEmpty)
                              ? ApiService.formatImageUrl(meObj['image'].toString())
                              : 'https://i.pravatar.cc/150?img=33',
                          supporters: meObj != null ? (int.tryParse(meObj['total_supporters']?.toString() ?? '0') ?? 0) : 0,
                          goal: meObj != null ? double.tryParse(meObj['shop_goal']?.toString() ?? '0') : 1200,
                        ),

                        SizedBox(height: 32.h),
                        // All Store List Header
                        Text(
                          'All store',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // All Store List (show all stores, including top 3)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sortedParticipants.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 20.h,
                            color: Colors.grey.shade100,
                            thickness: 1.h,
                          ),
                          itemBuilder: (context, index) {
                            final p = sortedParticipants[index] as Map<String, dynamic>;
                            final String pName = p['full_name']?.toString() ?? 'Unnamed';
                            final String img = p['image']?.toString() ?? '';
                            final String pAvatar = ApiService.formatImageUrl(img);
                            final double pAmount = double.tryParse(p['shop_achieved']?.toString() ?? '0') ?? 0.0;
                            final double pGoal = double.tryParse(p['shop_goal']?.toString() ?? '0') ?? 0.0;
                            final int pSupporters = int.tryParse(p['total_supporters']?.toString() ?? '0') ?? 0;
                            return LeaderboardAllStoreItem(
                              rank: index + 1,
                              name: pName,
                              supporters: pSupporters,
                              amount: pAmount,
                              avatarUrl: pAvatar,
                              goal: pGoal,
                            );
                          },
                        ),
                      ],
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
