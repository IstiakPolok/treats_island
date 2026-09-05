import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import 'arrow_button.dart';

class HomePinkActionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const HomePinkActionCard({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isTablet ? 160.0 : 160.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF6DDE8),
          borderRadius: BorderRadius.circular(isTablet ? 26.0 : 26.r),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/pinkeventcard.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20.0 : 20.w,
                vertical: isTablet ? 18.0 : 18.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.antonSc(
                      fontSize: isTablet ? 24.0 : 28.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  const ArrowButton(
                    backgroundColor: AppColors.primary,
                    iconColor: Colors.white,
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
