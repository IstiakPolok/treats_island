import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sheets/leaderboard_shop_details_sheet.dart';
import 'laurel_wreath_rank.dart';

class LeaderboardTopRankCard extends StatelessWidget {
  final dynamic rank;
  final String name;
  final double amount;
  final String avatarUrl;
  final int supporters;
  final double? goal;

  const LeaderboardTopRankCard({
    super.key,
    required this.rank,
    required this.name,
    required this.amount,
    required this.avatarUrl,
    this.supporters = 0,
    this.goal,
  });

  @override
  Widget build(BuildContext context) {
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
            // Rank Indicator on Left
            SizedBox(
              width: 54.w,
              child: Center(
                child: rank is int
                    ? LaurelWreathRank(rank: rank as int)
                    : Text(
                        '$rank',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 4.w),
            // Capsule Container
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FB),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '\$${amount.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Supporter Avatar
                    ClipOval(
                      child: Image.network(
                        avatarUrl,
                        width: 42.w,
                        height: 42.w,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, error, stackTrace) {
                          return Container(
                            width: 42.w,
                            height: 42.w,
                            color: const Color(0xFFE5E5E5),
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
                            width: 42.w,
                            height: 42.w,
                            color: const Color(0xFFE5E5E5),
                            child: Center(
                              child: SizedBox(
                                width: 14.w,
                                height: 14.w,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
