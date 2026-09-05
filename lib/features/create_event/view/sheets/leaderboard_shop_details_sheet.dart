import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardShopDetailsSheet {
  static void show(
    BuildContext context, {
    required String name,
    required double amount,
    required String avatarUrl,
    int supporters = 10,
    double? goal,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
        final double finalGoal = (goal != null && goal > 0)
            ? goal
            : (amount > 600 ? amount * 1.5 : 1200);
        final double progress =
            finalGoal > 0 ? (amount / finalGoal).clamp(0.0, 1.0) : 0.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: 70.w,
                  height: 70.w,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stackTrace) {
                    return Container(
                      width: 70.w,
                      height: 70.w,
                      color: const Color(0xFFF1F1F5),
                      child: Icon(
                        Icons.person,
                        color: Colors.black26,
                        size: 35.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 20.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8.h,
                  backgroundColor: const Color(0xFFEFEFEF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF6FB6),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${amount.toStringAsFixed(0)} ',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF6FB6),
                          ),
                        ),
                        TextSpan(
                          text: 'of ${finalGoal.toStringAsFixed(0)} goal',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$supporters supporters',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 36.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Visit pop-up store',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}
