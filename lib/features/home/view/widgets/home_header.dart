import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String currentDateString;
  final String currentTimeString;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.currentDateString,
    required this.currentTimeString,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HELLO,',
                style: GoogleFonts.antonSc(
                  fontSize: isTablet ? 38.0 : 48.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: isTablet ? 4.0 : 4.h),
              Text(
                userName,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 24.0 : 32.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: isTablet ? 12.0 : 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              AppAssets.splashLogo,
              width: isTablet ? 48.0 : 48.w,
              height: isTablet ? 48.0 : 48.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: isTablet ? 8.0 : 8.h),
            Text(
              currentDateString,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 12.0 : 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: isTablet ? 2.0 : 2.h),
            Text(
              currentTimeString,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 11.0 : 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
