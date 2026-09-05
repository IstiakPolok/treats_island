import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sheets/leaderboard_shop_details_sheet.dart';

class LeaderboardAllStoreItem extends StatelessWidget {
  final int rank;
  final String name;
  final int supporters;
  final double amount;
  final String avatarUrl;
  final double? goal;

  const LeaderboardAllStoreItem({
    super.key,
    required this.rank,
    required this.name,
    required this.supporters,
    required this.amount,
    required this.avatarUrl,
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
            // Rank Number
            SizedBox(
              width: 32.w,
              child: Text(
                '$rank',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            // Avatar
            ClipOval(
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
            // Name and Supporters
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
                    '$supporters supporters',
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              '\$${amount.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
