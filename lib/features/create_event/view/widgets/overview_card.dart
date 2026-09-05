import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  const OverviewCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600;
    return Container(
      padding: EdgeInsets.all(isTablet ? 16.0 : 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: isTablet ? 10.0 : 10.r,
            offset: Offset(0, isTablet ? 4.0 : 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 15.0 : 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: isTablet ? 4.0 : 4.h),
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ],
              ),
              ?trailing,
            ],
          ),
          SizedBox(height: isTablet ? 12.0 : 12.h),
          child,
        ],
      ),
    );
  }
}
