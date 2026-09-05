import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMiniVideoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String assetPath;

  const HomeMiniVideoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return ClipRRect(
      borderRadius: BorderRadius.circular(isTablet ? 22.0 : 22.r),
      child: SizedBox(
        width: isTablet ? 210.0 : 210.w,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(assetPath, fit: BoxFit.cover)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: isTablet ? 12.0 : 12.w,
              top: isTablet ? 12.0 : 12.h,
              child: Container(
                width: isTablet ? 34.0 : 34.w,
                height: isTablet ? 34.0 : 34.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded),
              ),
            ),
            Positioned(
              right: isTablet ? 12.0 : 12.w,
              top: isTablet ? 12.0 : 12.h,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 8.0 : 8.w,
                  vertical: isTablet ? 4.0 : 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(isTablet ? 12.0 : 12.r),
                ),
                child: Text(
                  duration,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 11.0 : 11.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: isTablet ? 12.0 : 12.w,
              right: isTablet ? 12.0 : 12.w,
              bottom: isTablet ? 14.0 : 14.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 13.0 : 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isTablet ? 6.0 : 6.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 10.0 : 11.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
