import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class HomeFundraisingGoalCard extends StatelessWidget {
  final String remainingTime;
  final String displayName;
  final double goal;
  final double achieved;

  const HomeFundraisingGoalCard({
    super.key,
    required this.remainingTime,
    required this.displayName,
    required this.goal,
    required this.achieved,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final double factor = goal > 0 ? (achieved / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF6DDE8),
        borderRadius: BorderRadius.circular(isTablet ? 26.0 : 26.r),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(isTablet ? 26.0 : 26.r),
                bottomRight: Radius.circular(isTablet ? 26.0 : 26.r),
              ),
              child: Image.asset(
                'assets/images/eventpink.png',
                width: isTablet ? 110.0 : 110.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isTablet ? 20.0 : 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12.0 : 12.w,
                    vertical: isTablet ? 8.0 : 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8CBE1),
                    borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: isTablet ? 14.0 : 14.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                      SizedBox(width: isTablet ? 6.0 : 6.w),
                      Text(
                        remainingTime,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 24.0 : 24.h),
                Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: isTablet ? 26.0 : 28.sp,
                      color: const Color(0xFF1A1A2E),
                    ),
                    SizedBox(width: isTablet ? 8.0 : 8.w),
                    Expanded(
                      child: Text(
                        displayName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.antonSc(
                          fontSize: isTablet ? 22.0 : 24.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 24.0 : 24.h),
                Text(
                  'Your Fundraising Goal',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 15.0 : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF262626).withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: isTablet ? 10.0 : 10.h),
                Stack(
                  children: [
                    Container(
                      height: isTablet ? 8.0 : 8.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          isTablet ? 8.0 : 8.r,
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: factor,
                      child: Container(
                        height: isTablet ? 8.0 : 8.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 8.0 : 8.r,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 10.0 : 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${achieved.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 17.0 : 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '\$${goal.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 17.0 : 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
