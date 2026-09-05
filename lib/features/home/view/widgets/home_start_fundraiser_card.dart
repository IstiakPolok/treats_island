import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import 'arrow_button.dart';

class HomeStartFundraiserCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final VoidCallback? onTap;

  const HomeStartFundraiserCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 24.0 : 24.r),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16.0 : 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.antonSc(
                  fontSize: isTablet ? 24.0 : 28.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: isTablet ? 6.0 : 6.h),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 13.0 : 14.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isTablet ? 18.0 : 18.h),
              const ArrowButton(
                backgroundColor: Colors.white,
                iconColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
