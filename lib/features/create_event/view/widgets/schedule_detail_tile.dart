import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleDetailTile extends StatelessWidget {
  final String title;
  final String value;
  final String placeholder;
  final VoidCallback? onTap;
  final bool showArrow;

  const ScheduleDetailTile({
    super.key,
    required this.title,
    required this.value,
    required this.placeholder,
    this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final displayValue = value.trim().isEmpty ? placeholder : value;
    final isPlaceholder = value.trim().isEmpty;

    final content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20.0 : 20.w,
        vertical: isTablet ? 16.0 : 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 14.0 : 14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: isTablet ? 10.0 : 10.r,
            offset: Offset(0, isTablet ? 4.0 : 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 15.0 : 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D1D2C),
                  ),
                ),
                SizedBox(height: isTablet ? 4.0 : 4.h),
                Text(
                  displayValue,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    color: isPlaceholder ? Colors.black38 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: isTablet ? 16.0 : 16.sp,
              color: Colors.black38,
            ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.0 : 20.w),
      child: onTap != null
          ? GestureDetector(onTap: onTap, child: content)
          : content,
    );
  }
}
